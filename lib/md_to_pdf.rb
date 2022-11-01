# -*- frozen_string_literal: true -*-

require 'yaml'
require 'nokogiri'
require 'fileutils'
require 'md_to_pdf/ids_generator'
require 'md_to_pdf/markdown_parser'
require 'md_to_pdf/attributes_parser'
require 'md_to_pdf/styles'
require 'md_to_pdf/style_converter'
require 'md_to_pdf/pdf_document'
require 'md_to_pdf/hyphenate'

module MarkdownToPDF
  class Generator
    def initialize(fonts_path:, styling_image_path:, styling_yml_filename:)
      @attrib_parser = AttributesParser.new
      @convert = StyleConverter.new
      @fonts_path = fonts_path || '.'
      @styling_images_path = styling_image_path || '.'
      yml = styling_yml_filename ? YAML.load_file(styling_yml_filename) : {}
      @styles = Styles.new(yml)
    end

    def file_to_pdf(markdown_file, pdf_destination, images_path = nil)
      markdown = File.read(markdown_file)
      markdown_to_pdf(markdown, pdf_destination, images_path || File.dirname(markdown_file))
    end

    def file_to_pdf_bin(markdown_file, images_path = nil)
      markdown = File.read(markdown_file)
      markdown_to_pdf_bin(markdown, images_path || File.dirname(markdown_file))
    end

    def markdown_to_pdf(markdown_string, pdf_destination, images_path)
      FileUtils.mkdir_p File.dirname(pdf_destination)
      render_markdown(markdown_string, images_path)
      @pdf.render_file(pdf_destination)
    end

    def markdown_to_pdf_bin(markdown_string, images_path)
      render_markdown(markdown_string, images_path)
      @pdf.render
    end

    private

    def render_markdown(markdown_string, images_path)
      pdf_setup_document
      @images_path = images_path
      doc = Parser.new.parse_markdown(markdown_string, @styles.default_fields)
      @hyphens = Hyphenate.new(doc[:language], doc[:hyphenation])
      render_doc(doc)
    end

    def render_doc(doc)
      opts = @convert.pdf_root_options(@styles.page)
      root = doc[:root]
      render_node(root, opts)
      render_footnotes(opts)
      render_page_footer(doc[:footer], @styles.page_footer, opts)
      render_page_footer(doc[:footer2], @styles.page_footer2, opts)
      render_page_footer(doc[:footer3], @styles.page_footer3, opts)
      render_page_header(doc[:header], @styles.page_header, opts)
      render_page_header(doc[:header2], @styles.page_header2, opts)
      render_page_header(doc[:header3], @styles.page_header3, opts)
      render_page_logo(doc[:logo], root, opts)
    end

    def pdf_setup_document
      @ids = IdGenerator.new
      @footnotes = []
      @pdf = PDFDocument.new(@convert.pdf_document_options(@styles.page))
      @convert.pdf_init_fonts(@pdf, @styles.fonts, @fonts_path)
    end

    # page numbers

    def render_page_numbers(opts, doc)
      style = @styles.page_numbers
      return if style['disabled']

      template = doc[:page_number_template] || style['template'] || ''
      return if template.empty?

      @pdf.number_pages(
        template,
        @convert.opts_page_numbers(style, opts, @pdf.bounds.right)
      )
    end

    # page footer
    def render_page_repeat_multiline(text, top, style, opts)
      return if style['disabled']

      font_opts = @convert.opts_font(style, opts)

      filter_page = style['filter-pages'] || []
      @pdf.repeat(lambda { |pg| !filter_page.include?(pg) }, dynamic: true) do
        page_top = top
        @pdf.set_font(@pdf.find_font(font_opts[:font]))
        lines = text
                  .gsub('<page>', @pdf.page_number.to_s)
                  .gsub('<total>', @pdf.page_count.to_s)
                  .split("\n").map do |h|
          line = h.strip
          {
            text: line,
            height: @pdf.height_of(line, font_opts.merge({ final_gap: false })),
            width: @pdf.width_of(line, font_opts)
          }
        end
        lines.each do |line|
          left = @pdf.alignment_to_x(style['align'], line[:width])
          @pdf.draw_text(line[:text], font_opts.merge({ at: [left, page_top] }))
          page_top -= line[:height] + (font_opts[:leading] || 0)
        end
      end
    end

    def render_page_footer(footer, style, opts)
      return if footer.nil? || footer.empty?

      top = @pdf.bounds.bottom + (style['offset'] || 0)
      render_page_repeat_multiline(footer, top, style, opts)
    end

    # page header
    def render_page_header(header, style, opts)
      return if header.nil? || header.empty?

      top = @pdf.bounds.top - (style['offset'] || 0)
      render_page_repeat_multiline(header, top, style, opts)
    end

    # page logo
    def render_page_logo(logo, node, opts)
      return if logo.nil? || logo.empty?

      style = @styles.page_logo
      return if style['disabled']

      image_file = validate_image(logo, node)
      image_obj, image_info = @pdf.build_image_object(image_file)

      top = @pdf.bounds.top - (style['offset'] || 0)

      width = @pdf.bounds.width
      max_width = @convert.parse_pt(style['max-width'])
      unless max_width.nil?
        width = [max_width, width].min
      end

      logo_opts = opts.dup

      logo_opts[:scale] = [width / image_info.width.to_f, 1].min
      left = @pdf.alignment_to_x(style['align'], width)
      logo_opts[:at] = [left, top]
      filter_page = style['filter-pages'] || []
      @pdf.repeat(lambda { |pg| !filter_page.include?(pg) }) do
        @pdf.embed_image(image_obj, image_info, logo_opts)
      end
    end

    # type :header

    def measure_header(node, opts)
      style = @styles.headline
      style = style.merge(@styles.headline_level(node.header_level))
      h_opts = @convert.merge_opts(
        @convert.opts_font(style, opts),
        @convert.opts_padding(style)
      )
      header_opts = opts.merge(h_opts)
      (opts[:top_padding] || 0) + (opts[:bottom_padding] || 0) +
        @pdf.height_of_formatted(inner_data(node, header_opts), @convert.filter_block_hash(header_opts))
    end

    def render_header(node, opts)
      style = @styles.headline
      style = style.merge(@styles.headline_level(node.header_level))

      h_opts = @convert.merge_opts(
        @convert.opts_font(style, opts),
        @convert.opts_padding(style)
      )

      content = node.to_plaintext.gsub("\n", '').gsub(' ', ' ')

      id = @ids.generate_id(content)
      pdf_dest = @pdf.dest_xyz(0, @pdf.y)
      @pdf.add_dest(id, pdf_dest)

      header_opts = opts.merge(h_opts)

      page_margins = @convert.opts_margin(@styles.page)
      space_above = @pdf.bounds.top + page_margins[:top_margin] - @pdf.y
      if space_above < 10
        header_opts[:top_padding] = 0
      end

      with_block_padding(header_opts) do
        @pdf.formatted_text(inner_data(node, header_opts), @convert.filter_block_hash(header_opts))
      end
    end

    # type :paragraph

    def render_paragraph(node, opts)
      style = @styles.paragraph
      n = node.first_child
      if n && n.type == :image
        image_opts = opts.dup
        nn = n.next
        if nn && nn.type == :text && nn.string_content.start_with?('{:') && nn.string_content.end_with?('}')
          attribs = @attrib_parser.parse_attribute_list(nn.string_content.slice(2..-2))
          image_opts[:image_classes] = attribs['class']
          nn.delete
        end
        nn = n.next
        return render_standalone_image(n, image_opts) unless nn
      end

      p_opts = @convert.merge_opts(
        opts,
        { align: (style['align'] || 'justify').to_sym },
        @convert.opts_font(style, opts)
      )

      p_padding_opts = @convert.opts_padding(style)
      with_block_padding_all(p_padding_opts) do
        nodes = []
        until n.nil?
          test = n
          n = n.next
          if test.type == :image
            unless nodes.empty?
              @pdf.formatted_text(inner_data(nodes, p_opts), @convert.filter_block_hash(p_opts))
              nodes = []
            end
            render_standalone_image(test, opts)
          else
            nodes.push(test)
          end
        end
        unless nodes.empty?
          @pdf.formatted_text(inner_data(nodes, p_opts), @convert.filter_block_hash(p_opts))
        end
      end
    end

    # type :text

    def data_text(node, opts)
      @convert.text_hash(@hyphens.hyphenate(node.string_content), opts)
    end

    # type :strong

    def data_strong(node, opts)
      inner_data(node, opts.merge({ styles: (opts[:styles] || []) + [:bold] }))
    end

    # type :emph

    def data_emph(node, opts)
      inner_data(node, opts.merge({ styles: (opts[:styles] || []) + [:italic] }))
    end

    # type :strikethrough

    def data_strikethrough(node, opts)
      inner_data(node, opts.merge({ styles: (opts[:styles] || []) + [:strikethrough] }))
    end

    # type :link

    def data_link(node, opts)
      style = @styles.link
      link_opts = @convert.opts_font(style, opts)
      link = node.url
      if link.start_with?('#')
        link_opts[:anchor] = link.sub(/\A#/, '')
      else
        link_opts[:link] = link
      end
      inner_data(node, link_opts)
    end

    # type: code

    def data_code(node, opts)
      @convert.text_hash(node.string_content, @convert.opts_font(@styles.code, opts))
    end

    # type: footnote_reference

    def data_footnote_reference(node, opts)
      style = @styles.footnote_reference
      link_opts = @convert.opts_font(style, opts)
      link_opts[:anchor] = "ft_#{node.string_content}"
      @convert.text_hash(node.string_content, link_opts)
    end

    # type: softbreak
    def data_softbreak(_node, opts)
      @convert.text_hash(" ", opts, false)
    end

    # type: break

    def data_linebreak(_node, opts)
      @convert.text_hash("\n", opts, false)
    end

    # type: footnote_definition

    def render_footnotes(opts)
      style = @styles.footnote_definition
      @footnotes.each_with_index do |node, index|
        point = style['point'] || {}
        footnote_anchor_opts = @convert.opts_font(point, opts)
        footnote_anchor_width = @pdf.width_of((index + 1).to_s, footnote_anchor_opts)
        id = "ft_#{index + 1}"
        pdf_dest = @pdf.dest_xyz(0, @pdf.y)
        @pdf.add_dest(id, pdf_dest)
        @pdf.float { @pdf.formatted_text([@convert.text_hash((index + 1).to_s, footnote_anchor_opts)]) }
        @pdf.indent(footnote_anchor_width) do
          render_node(node, opts)
        end
      end
    end

    # type: list_item

    def render_listitem(node, opts)
      render_node(node, opts)
    end

    # type: list

    def count_list_level(node)
      level = 1
      parent = node.parent
      until parent.nil?
        if parent.type == :list
          level += 1
        end
        parent = parent.parent
      end
      level
    end

    def render_list(node, opts)
      is_ordered = node.list_type == :ordered_list

      level = count_list_level(node)
      style = @styles.list(is_ordered)
      style_level = @styles.list_level(is_ordered, level)
      style = style.merge(style_level)

      point_style = @styles.list_prefix(is_ordered)
      point_style_level = @styles.list_prefix_level(is_ordered, level)
      point_style = point_style.merge(point_style_level)

      list_start = is_ordered ? (node.list_start || 0) : 0

      # node.list_tight unused here
      with_block_padding_all(@convert.opts_padding(style)) do
        node.each_with_index do |li, index|
          bullet = @convert.list_point(point_style, is_ordered, index + list_start)
          bullet_opts = @convert.opts_font(point_style, opts)
          bullet_width = @pdf.width_of("#{bullet} ", bullet_opts)
          if style['point-inline']
            child = li.first_child
            text_node = CommonMarker::Node.new(:text)
            text_node.string_content = "#{bullet} "
            if child.nil?
              @pdf.formatted_text([@convert.text_hash(bullet, bullet_opts)])
            else
              if child.type == :paragraph && child.first_child
                child.first_child.insert_before(text_node)
              else
                child.insert_before(text_node)
              end
              list_opts = @convert.opts_font(style, opts)
              li.each do |inner_node|
                if inner_node.type == :paragraph
                  convert(inner_node, list_opts)
                else
                  @pdf.indent(bullet_width) { convert(inner_node, list_opts) }
                end
              end
            end
          else
            @pdf.float { @pdf.formatted_text([@convert.text_hash(bullet, bullet_opts)]) }
            @pdf.indent(bullet_width) { convert(li, @convert.opts_font(style, opts)) }
          end
        end
      end
    end

    # type: table

    def render_table(node, opts)
      column_widths = Array.new(node.table_alignments.length, @pdf.bounds.right / node.table_alignments.length)
      table_style = @styles.table
      cell_style = table_style['cell'] || {}
      header_style = table_style['header'] || {}
      table_cell_style_opts = @convert.opts_table_cell(cell_style, opts)

      data = []
      header = 0
      node.each do |row|
        data_row = []
        row.each do |cell|
          cell_data = inner_data(cell, opts)
          data_row.push(cell_data)
        end
        if row.type == :table_header
          non_empty = data_row.find { |cell_data| !cell_data.empty? }
          next if non_empty.nil?

          header += 1
        end
        cells_row = []
        padding_left = table_cell_style_opts[:padding_left] || 0
        padding_right = table_cell_style_opts[:padding_right] || 0
        data_row.each_with_index do |cell_data, index|
          cell_width = column_widths[index] - padding_left - padding_right
          cells_row.push(make_table_cell_or_subtable(cell_data, opts, node.table_alignments[index], cell_width))
        end
        data.push(cells_row)
      end

      with_block_margin_all(@convert.opts_margin(table_style)) do
        @pdf.table(
          data,
          width: @pdf.bounds.right,
          header: header == 0 ? false : header,
          cell_style: table_cell_style_opts,
          column_widths: column_widths
        ) do
          node.table_alignments.each_with_index do |alignment, index|
            columns(index).align = alignment unless alignment == nil
          end
          if header > 0
            header_background_color = header_style['background-color']
            header_font_style = header_style['style'] ? header_style['style'].to_sym : nil
            header_font_size = header_style['size'] || cell_style['size'] || opts[:size]
            header_font_color = header_style['color']

            header_cells = cells.columns(0..-1).rows(0..(header - 1))
            header_cells.each do |cell|
              cell.background_color = header_background_color
              cell.font_style = header_font_style
              cell.text_color = header_font_color
              cell.size = header_font_size
            end
          end
        end
      end
    end

    # type: blockquote

    def data_blockquote(node, opts)
      result = []
      case node.type
      when :paragraph
        cell_data = inner_data(node, opts)
        cell = make_table_cell_or_subtable(cell_data, opts, :left, @pdf.bounds.right)
        result.push([cell])
      when :blockquote
        subtable_rows = []
        node.each do |child|
          subtable_data = data_blockquote(child, opts)
          subtable_rows.concat(subtable_data)
        end
        subtable = @pdf.make_table(subtable_rows, cell_style: opts) do
          (0..(row_length)).each do |i|
            rows(i).padding_left = 20
            rows(i).padding_top = 0
            rows(i).padding_bottom = 0
            rows(i).padding_right = 0
          end
        end
        result.push([subtable])
      else
        warn("Unsupported node.type #{node.type} in data_blockquote()", node.type, node)
      end
      result
    end

    def render_blockquote(node, opts)
      style = @styles.blockquote
      cell_style_opts = @convert.opts_table_cell(style, opts)
      data_rows = []
      node.each do |row|
        data_rows.concat(data_blockquote(row, cell_style_opts))
      end
      data = data_rows
      with_block_margin_all(@convert.opts_margin(style)) do
        @pdf.table(data, width: @pdf.bounds.right, cell_style: cell_style_opts) do
          (0..(row_length - 2)).each do |i|
            rows(i).padding_bottom = cell_style_opts[:leading] || 0
          end
          (1..(row_length)).each do |i|
            rows(i).padding_top = cell_style_opts[:leading] || 0
          end
        end
      end
    end

    # type: code_block

    def render_codeblock(node, opts)
      style = @styles.codeblock
      text = node.string_content.gsub(' ', Prawn::Text::NBSP)
      cell_style_opts = @convert.opts_table_cell(style, opts).merge({ border_width: 0 })
      cell = Prawn::Table::Cell::Text.new(
        @pdf, [0, 0],
        content: merge_cell_data([cell_style_opts.merge({ text: text })]),
        font: cell_style_opts[:font],
        size: cell_style_opts[:size],
        inline_format: true
      )
      with_block_margin_all(@convert.opts_margin(style)) do
        @pdf.table([[cell]], width: @pdf.bounds.right, cell_style: cell_style_opts)
      end
    end

    # type: hrule

    def render_hrule(_node, _opts)
      style = @styles.hrule
      opts = @convert.opts_margin(style)
      line_width_before = @pdf.line_width
      with_block_margin(opts) do
        @pdf.line_width = @convert.first_number(style['line-width'], 1)
        @pdf.stroke_horizontal_line(
          @pdf.bounds.left + (opts[:left_margin] || 0),
          @pdf.bounds.right - (opts[:right_margin] || 0)
        )
        @pdf.line_width = line_width_before
      end
    end

    # type: image

    def data_image(node, _opts)
      url = node.url
      return unless url

      image_file = validate_image(url, node)
      return if image_file.nil?

      { image: image_file }
    end

    def render_image(node, _opts)
      warn("Rendering span/table images is currently not supported", "img", node)
      nil
    end

    def render_standalone_image(node, opts)
      url = node.url
      return nil unless url

      embed_image(url, node, opts)
    end

    # type: inline_html

    def render_html(node, opts)
      html = node.string_content.gsub("\n", '').strip
      parsed_data = Nokogiri::HTML.fragment(html)
      parsed_data.children.each do |tag|
        case tag.name
        when 'img'
          embed_image(tag.attr('src'), node, opts.merge({ image_classes: tag.attr('class') }))
        when 'text'
          @pdf.formatted_text([@convert.text_hash(tag.text, opts)])
        when 'comment'
          # ignore html comments
        when 'br'
          @pdf.formatted_text([@convert.text_hash("\n", opts, false)])
        when 'br-page'
          @pdf.start_new_page
        else
          warn("WARNING: render_html; Html tag on root level currently unsupported.", tag.name, node)
        end
      end
    end

    def data_inlinehtml(node, opts)
      html = node.string_content
      parsed_data = Nokogiri::HTML.fragment(html)
      result = []
      parsed_data.children.each do |tag|
        case tag.name
        when 'text'
          result.push(@convert.text_hash(tag.text, opts))
        when 'comment'
          # ignore html comments
        when 'br'
          result.push(@convert.text_hash("\n", opts, false))
        else
          warn("WARNING: inline_html; Html tag currently unsupported.", tag.name, node)
        end
      end
      result
    end

    # helpers

    def convert(node, opts)
      case node.type
      when :header
        render_header(node, opts)
      when :paragraph
        render_paragraph(node, opts)
      when :list
        render_list(node, opts)
      when :list_item
        render_listitem(node, opts)
      when :table
        render_table(node, opts)
      when :blockquote
        render_blockquote(node, opts)
      when :code_block
        render_codeblock(node, opts)
      when :hrule
        render_hrule(node, opts)
      when :image
        render_image(node, opts)
      when :html
        render_html(node, opts)
      when :footnote_definition
        @footnotes.push(node)
        nil
      else
        warn("Unsupported node.type #{node.type} in convert(node)", node.type, node)
        nil
      end
    end

    def convert_data(node, opts)
      case node.type
      when :text
        data_text(node, opts)
      when :strong
        data_strong(node, opts)
      when :emph
        data_emph(node, opts)
      when :strikethrough
        data_strikethrough(node, opts)
      when :link
        data_link(node, opts)
      when :image
        data_image(node, opts)
      when :code
        data_code(node, opts)
      when :inline_html, :html
        data_inlinehtml(node, opts)
      when :footnote_reference
        data_footnote_reference(node, opts)
      when :softbreak
        data_softbreak(node, opts)
      when :linebreak
        data_linebreak(node, opts)
      when :footnote_definition
        @footnotes.push(node)
      else
        warn("Unsupported node.type #{node.type} in convert_data()", node.type, node)
        nil
      end
    end

    def validate_image(filename, node)
      if filename !~ /\.jpe?g$|\.png$/
        warn(
          "Requested to render images that are potentially not a JPEG or PNG.\n" \
          "The image might not be present if it's not in one of these formats.",
          filename, node
        )
        return nil
      end
      if filename.start_with?('http:', 'https:')
        warn("Images must be local", filename, node)
        return nil
      end

      image_file = File.expand_path(File.join(@images_path, filename))
      unless File.exist?(image_file)
        image_file = File.expand_path(File.join(@styling_images_path, filename))
        unless File.exist?(image_file)
          warn("Image file not found", image_file, node)
          return nil
        end
      end
      image_file
    end

    def embed_image(filename, node, opts)
      image_file = validate_image(filename, node)
      return if image_file.nil?

      style = @styles.image

      image_classes = (opts[:image_classes] || '').split

      image_classes.each do |image_class|
        style = style.merge(@styles.image_class(image_class))
      end

      image_opts = @convert.opts_margin(style)

      align = (style['align'] || 'center').to_sym

      image_obj, image_info = @pdf.build_image_object(image_file)
      options = { position: align }
      width = @pdf.bounds.width - (image_opts[:left_margin] || 0) - (image_opts[:right_margin] || 0)
      max_width = @convert.parse_pt(style['max-width'])
      unless max_width.nil?
        width = [max_width, width].min
      end

      options[:scale] = [width / image_info.width.to_f, 1].min
      #   options[:height] = img.attr['height'].to_i / (@options[:image_dpi] || 150.0) * 72
      #   options[:width] = img.attr['width'].to_i / (@options[:image_dpi] || 150.0) * 72
      img_class = ''
      if img_class =~ /\bright\b/
        options[:position] = :right
        @pdf.float { @pdf.embed_image(image_obj, image_info, options) }
      else
        with_block_margin(image_opts) do
          @pdf.embed_image(image_obj, image_info, options)
        end
      end
    end

    def make_subtable_cell(cell_data, opts)
      Prawn::Table::Cell::Text.new(
        @pdf, [0, 0],
        content: merge_cell_data(cell_data),
        font: opts[:font],
        size: opts[:size],
        borders: [],
        inline_format: true
      )
    end

    def make_table_cell(cell_data, opts)
      Prawn::Table::Cell::Text.new(
        @pdf, [0, 0],
        content: merge_cell_data(cell_data),
        font: opts[:font],
        size: opts[:size],
        padding: opts[:cell_padding],
        inline_format: true
      )
    end

    def image_in_table_column(image_data, width)
      image_data.merge({ fit: [width, 200], position: :center, vposition: :center })
    end

    def make_subtable(cell_data, opts, alignment, width)
      rows = []
      row = []
      cell_data.each do |elem|
        if elem[:image]
          rows.push([make_subtable_cell(row, opts)]) unless row.empty?
          rows.push([image_in_table_column(elem, width).merge({ borders: [] })])
          row = []
        else
          row.push(elem)
        end
      end
      rows.push([make_subtable_cell(row, opts)]) unless row.empty?
      @pdf.make_table(rows, width: width) do
        columns(0).align = alignment unless alignment == nil
      end
    end

    def make_table_cell_or_subtable(cell_data, opts, alignment, width)
      image_data = cell_data.find { |elem| elem[:image] }
      if image_data
        return image_in_table_column(image_data, width) if cell_data.length === 1

        return make_subtable(cell_data, opts, alignment, width)
      end
      make_table_cell(cell_data, opts)
    end

    def cell_inline_formatting(cell_data_part)
      value = cell_data_part[:text] || ''
      # https://prawnpdf.org/docs/0.11.1/Prawn/Text.html internal format

      value = "<link href=\"#{cell_data_part[:link]}\">#{value}</link>" if cell_data_part.key?(:link)
      value = "<link anchor=\"#{cell_data_part[:anchor]}\">#{value}</link>" if cell_data_part.key?(:anchor)
      value = "<color rgb=\"#{cell_data_part[:color]}\">#{value}</color>" if cell_data_part.include?(:color)
      value = "<font size=\"#{cell_data_part[:size]}\">#{value}</font>" if cell_data_part.key?(:size)
      if cell_data_part.key?(:character_spacing)
        value = "<font character_spacing=\"#{cell_data_part[:character_spacing]}\">#{value}</font>"
      end
      value = "<font name=\"#{cell_data_part[:font]}\">#{value}</font>" if cell_data_part.key?(:font)

      styles = cell_data_part[:styles]
      if styles
        value = "<b>#{value}</b>" if styles.include?(:bold)
        value = "<i>#{value}</i>" if styles.include?(:italic)
        value = "<u>#{value}</u>" if styles.include?(:underline)
        value = "<strikethrough>#{value}</strikethrough>" if styles.include?(:strikethrough)
        value = "<sub>#{value}</sub>" if styles.include?(:sub)
        value = "<sup>#{value}</sup>" if styles.include?(:sup)
      end
      value
    end

    def merge_cell_data(cell_data)
      cell_data.map { |part| cell_inline_formatting(part) }.join
    end

    def inner_data(list, opts)
      list_opts = opts.dup
      result = []
      list.each do |inner_node|
        new_opts = if inner_node.type == :inline_html
                     @convert.html_tag_to_font_style(inner_node.string_content, list_opts)
                   end
        if new_opts
          list_opts = new_opts
        else
          result.push(convert_data(inner_node, list_opts))
        end
      end
      result.flatten.compact
    end

    def render_node(node, opts)
      list = []
      node.each do |child|
        list.push(child)
      end
      render_node_list(list, opts)
    end

    def render_node_list(list, opts)
      avoid_dangling_headers = true
      list_opts = opts.dup
      return smart_render_node_list(list, list_opts) if avoid_dangling_headers

      list.each { |inner_node| convert(inner_node, list_opts) }
    end

    def smart_render_headers(list, opts, threshold)
      return if list.empty?

      height = 0
      list.each do |header_node|
        height += measure_header(header_node, opts)
      end

      space_from_bottom = @pdf.y - @pdf.bounds.bottom - height
      if space_from_bottom < threshold
        @pdf.start_new_page
      end
      list.each do |header_node|
        render_header(header_node, opts)
      end
    end

    def smart_render_node_list(list, opts)
      # outline
      # 1. collect consecutive headers
      # 2. measure headers
      # 3. if not %threshold% free space on page left, create new page
      # 4. render headers
      # 5. render items
      # 6. goto 1.
      threshold = 150
      header_nodes = []
      list.each do |inner_node|
        if inner_node.type == :header
          header_nodes.push(inner_node)
        else
          smart_render_headers(header_nodes, opts, threshold)
          header_nodes = []
          convert(inner_node, opts)
        end
      end
      smart_render_headers(header_nodes, opts, threshold)
    end

    def warn(text, element, node)
      puts "WARNING: #{text}\nGot #{element} at #{node.sourcepos.inspect}\n\n"
    end

    def with_block_padding(opts)
      @pdf.move_down(opts[:top_padding]) if opts.key?(:top_padding)
      yield
      @pdf.move_down(opts[:bottom_padding]) if opts.key?(:bottom_padding)
    end

    def with_block_margin(opts)
      @pdf.move_down(opts[:top_margin]) if opts.key?(:top_margin)
      yield
      @pdf.move_down(opts[:bottom_margin]) if opts.key?(:bottom_margin)
    end

    def with_block_padding_all(opts, &block)
      with_block_padding(opts) do
        @pdf.indent(opts[:left_padding] || 0, opts[:right_padding] || 0, &block)
      end
    end

    def with_block_margin_all(opts, &block)
      with_block_margin(opts) do
        @pdf.indent(opts[:left_margin] || 0, opts[:right_margin] || 0, &block)
      end
    end
  end

  def self.init_generator(styling_yml_filename)
    MarkdownToPDF::Generator.new(
      styling_yml_filename: styling_yml_filename,
      styling_image_path: File.join(File.dirname(styling_yml_filename), 'images'),
      fonts_path: File.join(File.dirname(styling_yml_filename), 'fonts')
    )
  end

  def self.generate_markdown_pdf(markdown_file, styling_yml_filename, destination_filename)
    renderer = init_generator(styling_yml_filename)
    renderer.file_to_pdf(markdown_file, destination_filename)
  end

  def self.render_markdown(markdown_file, styling_yml_filename)
    renderer = init_generator(styling_yml_filename)
    renderer.file_to_pdf_bin(markdown_file)
  end

  def self.generate_markdown_string_pdf(markdown_string, styling_yml_filename, images_path, destination_filename)
    renderer = init_generator(styling_yml_filename)
    renderer.markdown_to_pdf(markdown_string, destination_filename, images_path)
  end

  def self.render_markdown_string(markdown_string, styling_yml_filename, images_path)
    renderer = init_generator(styling_yml_filename)
    renderer.markdown_to_pdf_bin(markdown_string, images_path)
  end
end
