module MarkdownToPDF
  module HTML
    def html_tag_to_font_style(tag, opts)
      case tag.downcase
      when '<u>', '<ins>'
        add_font_style(opts, :underline)
      when '</u>', '</ins>'
        remove_font_style(opts, :underline)
      when '<b>', '<strong>'
        add_font_style(opts, :bold)
      when '</b>', '</strong>'
        remove_font_style(opts, :bold)
      when '<i>'
        add_font_style(opts, :italic)
      when '</i>'
        remove_font_style(opts, :italic)
      when '<sub>'
        add_font_style(opts, :subscript)
      when '</sub>'
        remove_font_style(opts, :subscript)
      when '<sup>'
        add_font_style(opts, :superscript)
      when '</sup>'
        remove_font_style(opts, :superscript)
      when '<strikethrough>', '<s>', '<del>'
        add_font_style(opts, :strikethrough)
      when '</strikethrough>', '</s>', '</del>'
        remove_font_style(opts, :strikethrough)
      when '</font>'
        remove_font_stack_opts(opts)
      when '</a>'
        remove_link_stack_opts(opts)
      else
        node = Nokogiri::HTML.fragment(tag).children[0]
        return opts if node.nil?

        if node.name == 'a' && node.attr('href')
          result = link_opts(node.attr('href'), opts)
          result[:link_stack_opts] = result[:link_stack_opts] || []
          result[:link_stack_opts].push(opts)
          result
        elsif node && node.name == 'font' && node.attr('size')
          size = (node.attr('size') || '0').to_i
          return opts if size < 1

          result = opts.dup
          result[:font_stack_opts] = result[:font_stack_opts] || []
          result[:font_stack_opts].push(opts)
          result[:size] = size
          result
        end
      end
    end

    def remove_font_stack_opts(opts)
      result = opts
      list = opts[:font_stack_opts]
      if list && !list.empty?
        result = list.pop
      end
      result
    end

    def remove_link_stack_opts(opts)
      result = opts
      list = opts[:link_stack_opts]
      if list && !list.empty?
        result = list.pop
      end
      result
    end

    def draw_html(node, opts)
      html = node.string_content.gsub("\n", '').strip
      parsed_data = Nokogiri::HTML.fragment(html)
      draw_html_tag(parsed_data, node, opts)
    end

    def data_inlinehtml(node, opts)
      html = node.string_content
      return [] if html.downcase == '</a>' || html.downcase == '</font>'

      parsed_data = Nokogiri::HTML.fragment(html)
      data_inlinehtml_tag(parsed_data, node, opts)
    end

    private

    def data_inlinehtml_tag(tag, node, opts)
      result = []
      current_opts = opts
      tag.children.each do |sub|
        case sub.name
        when 'text'
          result.push(text_hash(sub.text, current_opts))
        when 'a'
          url = sub.attr('href')
          unless url.nil?
            if url.start_with?('#')
              current_opts[:anchor] = url.sub(/\A#/, '')
            else
              current_opts[:link] = url
            end
          end
        when 'comment'
          # ignore html comments
        when 'img'
          result.push(data_inline_image_tag(sub, node, opts))
        when 'ul', 'ol'
          result.concat(data_inlinehtml_list_tag(sub, node, opts))
        when 'label', 'li'
          result.concat(data_inlinehtml_tag(sub, node, opts))
        when 'p'
          result.concat(data_inlinehtml_tag(sub, node, opts)).push(text_hash_raw("\n", current_opts))
        when 'br'
          result.push(text_hash_raw("\n", current_opts))
        when 'input'
          # ignore, if handled in tasklist
          unless sub['md_to_pdf_done'] == "true"
            process_children, current_opts = handle_unknown_html_tag(sub, node, current_opts)
            draw_html_tag(sub, node, opts) if process_children
          end
        else
          data_array, current_opts = handle_unknown_inline_html_tag(sub, node, current_opts)
          result.concat(data_array)
        end
      end
      result
    end

    def data_image_style_opts(tag, _node, _opts)
      result = {}
      if tag.attr("style")
        image_styles = tag.attr("style").split(';').to_h do |pair|
          k, v = pair.split(':', 2)
          [k, v]
        end
        if image_styles['width']
          custom_max_width = parse_pt(image_styles['width'])
          result[:custom_max_width] = custom_max_width unless custom_max_width.nil? || custom_max_width <= 0
        end
      end
      result[:image_classes] = tag.attr('class')
      result[:image_caption] = find_img_caption(tag)
      result
    end

    def data_inline_image_tag(tag, node, opts)
      { image: tag.attr('src') }.merge(data_image_style_opts(tag, node, opts))
    end

    def data_inlinehtml_list_tag(tag, node, opts)
      result = []
      points, level, _list_style, content_opts = data_html_list(tag, node, opts)
      result.push(text_hash_raw("\n", content_opts).merge({ list_level: level, list_indent: 0 })) if level > 1
      points.each do |point|
        data = data_inlinehtml_tag(point[:tag], node, content_opts)
        data.push(text_hash_raw("\n", content_opts).merge({ list_entry_type: 'end' }))
        data[0][:list_entry_type] = 'first' unless data.empty?
        data.unshift(text_hash(point[:bullet], point[:opts]).merge({ list_entry_type: 'bullet' }))
        data.each do |item|
          item[:list_level] = level if item[:list_level].nil?
          item[:list_indent] = point[:width] if item[:list_indent].nil?
          item[:list_indent_space] = point[:space_width] if item[:list_indent_space].nil?
        end
        result.concat(data)
      end
      result
    end

    def collect_html_table_tag_rows(tag, table_font_opts, opts)
      rows = []
      tag.children.each do |sub|
        case sub.name
        when 'tbody', 'thead'
          rows.concat(collect_html_table_tag_rows(sub, table_font_opts, opts))
        when 'tr'
          rows.push(collect_html_table_tag_row(sub, table_font_opts, opts))
        end
      end
      rows
    end

    def draw_html_table_tag(tag, opts)
      table_font_opts = build_table_font_opts(opts)
      rows = collect_html_table_tag_rows(tag, table_font_opts, opts)
      column_count = 0
      rows.each do |row|
        column_count = [column_count, row.length].max
      end
      column_alignments = Array.new(column_count, :left)
      header_row_count = count_html_header_rows(tag)
      table = build_table_settings(header_row_count, opts)
      opts[:opts_cell] = table[:opts_cell]
      draw_table_data(table, rows, column_alignments, opts)
    end

    def count_html_header_rows(tag, header_count = 0)
      tag.children.each do |sub|
        case sub.name
        when 'thead'
          header_count = count_html_header_rows(sub, header_count)
        when 'tr'
          header_count += 1
        end
      end
      header_count
    end

    def draw_html_tag(tag, node, opts)
      current_opts = opts
      tag.children.each do |sub|
        case sub.name
        when 'img'
          embed_image(sub.attr('src'), node, current_opts
                                               .merge(data_image_style_opts(sub, node, current_opts)))
        when 'text'
          @pdf.formatted_text([text_hash(sub.text, current_opts)])
        when 'a'
          draw_html_tag(sub, node, link_opts(sub.attr('href'), current_opts))
        when 'table'
          draw_html_table_tag(sub, current_opts)
        when 'ul', 'ol'
          draw_html_list_tag(sub, node, current_opts)
        when 'comment'
          # ignore html comments
        when 'br'
          if is_page_break_tag?(sub)
            @pdf.start_new_page
          else
            @pdf.formatted_text([text_hash_raw("\n", current_opts)])
          end
        when 'br-page', 'page-br'
          @pdf.start_new_page
        when 'p', 'figure'
          draw_html_tag(sub, node, current_opts)
        when 'figcaption'
          # ignore, it is handled in img
        when 'input'
          # ignore, if handled in tasklist
          unless sub['md_to_pdf_done'] == "true"
            process_children, current_opts = handle_unknown_html_tag(sub, node, current_opts)
            draw_html_tag(sub, node, opts) if process_children
          end
        else
          if sub.name == 'div' && is_page_break_tag?(sub)
            @pdf.start_new_page
          else
            process_children, current_opts = handle_unknown_html_tag(sub, node, current_opts)
            draw_html_tag(sub, node, opts) if process_children
          end
        end
      end
    end

    def is_page_break_tag?(tag)
      return false unless tag.key?('style')

      style = tag.get_attribute('style') || ''
      /page-break-(before|after)\s*:\s*always/ === style
    end

    def find_img_caption(tag)
      if tag.name == 'figure'
        figcaption = tag.search("figcaption").first
        figcaption&.text
      elsif tag.parent
        find_img_caption(tag.parent)
      end
    end

    def cell_inline_formatting(cell_data_part)
      return cell_data_part[:text] if cell_data_part[:raw]

      # https://prawnpdf.org/docs/prawn/2.5.0/Prawn/Text.html inline format
      value = cell_inline_formatting_data(cell_data_part)
      cell_inline_formatting_styles(cell_data_part, value)
    end

    def cell_inline_formatting_styles(cell_data_part, value)
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

    def cell_inline_formatting_data(cell_data_part)
      value = cell_data_part[:text] || ''
      value = "<link href=\"#{cell_data_part[:link]}\">#{value}</link>" if cell_data_part.key?(:link)
      value = "<link anchor=\"#{cell_data_part[:anchor]}\">#{value}</link>" if cell_data_part.key?(:anchor)
      value = "<color rgb=\"#{cell_data_part[:color]}\">#{value}</color>" if cell_data_part.include?(:color)
      value = "<font size=\"#{cell_data_part[:size]}\">#{value}</font>" if cell_data_part.key?(:size)
      if cell_data_part.key?(:character_spacing)
        value = "<font character_spacing=\"#{cell_data_part[:character_spacing]}\">#{value}</font>"
      end
      value = "<font name=\"#{cell_data_part[:font]}\">#{value}</font>" if cell_data_part.key?(:font)
      value
    end

    def add_font_style(opts, style)
      merge_opts(opts, { styles: (opts[:styles] || []) + [style] })
    end

    def remove_font_style(opts, style)
      merge_opts(opts, { styles: (opts[:styles] || []) - [style] })
    end

    def collect_html_table_tag_cell(tag, opts)
      cell_data = data_inlinehtml_tag(tag, nil, opts)
      if tag.key?('style')
        style = tag.get_attribute('style') || ''
        cell_background_color = parse_html_color(style, /background-color:(.*?)(?:;|\z)/)
        cell_border_color = parse_html_color(style, /border-color:(.*?)(?:;|\z)/)
        cell_border_width = parse_html_pt(style, /border-width:(.*?)(?:;|\z)/)
        cell_border_style = parse_html_border_style(style)
        cell_border = style.scan(/border:(.*?)(?:;|\z)/)
        unless cell_border.empty?
          cell_border_compact = cell_border.last[0].split(' ', 3)
          if cell_border_width.nil?
            test_size = parse_pt(cell_border_compact[0])
            cell_border_width = test_size unless test_size.nil?
          end
          if cell_border_style.nil?
            test_style = parse_border_style(cell_border_compact[1])
            cell_border_style = test_style unless test_style.nil?
          end
          if cell_border_color.nil?
            test_color = parse_color(cell_border_compact[2])
            cell_border_color = test_color unless test_color.nil?
          end
        end
        cell_data = [{}] if cell_data.empty?
        cell_data[0][:cell_background_color] = cell_background_color
        cell_data[0][:cell_border_color] = cell_border_color
        cell_data[0][:cell_border_width] = cell_border_width
        cell_data[0][:cell_border_style] = cell_border_style
      end
      cell_data
    end

    def parse_html_border_style(style)
      res = style.scan(/border-style:(.*?)(?:;|\z)/)
      parse_border_style(res.last[0]) unless res.empty?
    end

    def parse_border_style(border_style)
      case border_style
      when 'dotted'
        :dotted
      when 'dashed'
        :dashed
      else
        :solid
      end
    end

    def parse_html_pt(style, size_regexp)
      res = style.scan(size_regexp)
      parse_pt(res.last[0]) unless res.empty?
    end

    def parse_html_color(style, color_regexp)
      res = style.scan(color_regexp)
      parse_color(res.last[0]) unless res.empty?
    end

    def space_stuffing(width, space_width)
      amount = (width / space_width).truncate
      return '' if amount < 1

      Prawn::Text::NBSP * amount
    end

    def indent_html_table_list_items(cell_data)
      cell_data.each do |item|
        next if item[:list_level].nil?

        # Note: There is no settings for paddings of text fragments in Prawn::Table
        # so as a workaround the lists are stuffed with spaces, which is of course not pixel perfect

        # first indenting with spaces of multiline list items
        # * item
        #   multiline item
        #   multiline item
        if item[:list_entry_type].nil? && item[:text] != "\n"
          item[:text] = "#{space_stuffing(item[:list_indent], item[:list_indent_space])}#{item[:text]}"
        end

        # second indenting of nested lists
        # * item
        #   multiline item
        #   * sub list item
        #   * sub list item
        #     sub list multiline item
        if item[:list_level] > 1 && (item[:list_entry_type].nil? || item[:list_entry_type] == 'bullet') && item[:text] != "\n"
          item[:text] = "#{space_stuffing(item[:list_indent], item[:list_indent_space])}#{item[:text]}"
        end
      end
      cell_data
    end

    def collect_html_table_tag_row(tag, table_font_opts, opts)
      cells = []
      tag.children.each do |sub|
        case sub.name
        when 'th'
          cell_data = collect_html_table_tag_cell(sub, opts.merge(table_font_opts[:header]))
          cells.push(indent_html_table_list_items(cell_data))
        when 'td'
          cell_data = collect_html_table_tag_cell(sub, opts.merge(table_font_opts[:cell]))
          cells.push(indent_html_table_list_items(cell_data))
        end
      end
      cells
    end
  end
end
