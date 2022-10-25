require 'prawn/measurements'
require 'md_to_pdf/version'

module MarkdownToPDF
  class StyleConverter
    include Prawn::Measurements

    def opts_padding(style)
      {
        left_padding: first_number_mm(style['padding-left-mm'], style['padding-mm'], 0),
        right_padding: first_number_mm(style['padding-right-mm'], style['padding-mm'], 0),
        bottom_padding: first_number_mm(style['padding-bottom-mm'], style['padding-mm'], 0),
        top_padding: first_number_mm(style['padding-top-mm'], style['padding-mm'], 0)
      }
    end

    def opts_margin(style)
      {
        left_margin: first_number_mm(style['margin-left-mm'], style['margin-mm'], 0),
        right_margin: first_number_mm(style['margin-right-mm'], style['margin-mm'], 0),
        bottom_margin: first_number_mm(style['margin-bottom-mm'], style['margin-mm'], 0),
        top_margin: first_number_mm(style['margin-top-mm'], style['margin-mm'], 0)
      }
    end

    def first_number(*args)
      args.find { |value| !value.nil? }
    end

    def first_number_mm(*args)
      mm2pt(args.find { |value| !value.nil? })
    end

    def merge_opts(*args)
      result = {}
      args.each { |o| result = result.merge(o) }
      result.compact
    end

    def opts_table_cell(style, opts)
      # :overflow => :shrink_to_fit, :min_font_size => 8,
      merge_opts(
        { background_color: style['background-color'] },
        opts_borders(style),
        opts_font(style, opts),
        opts_table_cell_padding(style)
      )
    end

    def opts_table_cell_padding(style)
      {
        padding_left: first_number_mm(style['padding-left-mm'], style['padding-mm'], 0),
        padding_right: first_number_mm(style['padding-right-mm'], style['padding-mm'], 0),
        padding_bottom: first_number_mm(style['padding-bottom-mm'], style['padding-mm'], 0),
        padding_top: first_number_mm(style['padding-top-mm'], style['padding-mm'], 0)
      }
    end

    def opts_borders_colors(style)
      [
        style['border-color-top'] || '000000',
        style['border-color-right'] || '000000',
        style['border-color-bottom'] || '000000',
        style['border-color-left'] || '000000'
      ]
    end

    def opts_borders_width(style)
      [
        first_number_mm(style['border-width-top-mm'], 0.25),
        first_number_mm(style['border-width-right-mm'], 0.25),
        first_number_mm(style['border-width-bottom-mm'], 0.25),
        first_number_mm(style['border-width-left-mm'], 0.25)
      ]
    end

    def opts_borders(style)
      borders = []
      borders.push(:left) unless style['no-border-left']
      borders.push(:right) unless style['no-border-right']
      borders.push(:top) unless style['no-border-top']
      borders.push(:bottom) unless style['no-border-bottom']
      {
        border_colors: opts_borders_colors(style),
        border_widths: opts_borders_width(style),
        borders: borders
      }
    end

    def opts_font(style, opts)
      {
        font: style['font'] || opts[:font],
        character_spacing: first_number(style['character-spacing'], opts[:character_spacing]),
        leading: first_number(style['leading'], opts[:leading]),
        styles: (style['styles'] || opts[:styles] || []).map(&:to_sym),
        size: first_number(style['size'], opts[:size]),
        color: style['color'] || opts[:color]
      }.compact
    end

    def opts_page_numbers(style, opts, bounds_right)
      filter_page = style['filter-pages'] || []
      x = style['position-right'].nil? ? (style['position-left'] || 0) : (bounds_right - style['position-right'])
      merge_opts(
        {
          start_count_at: first_number(style['start-count-at'], 1),
          page_filter: lambda { |pg| !filter_page.include?(pg) },
          at: [x, style['position-bottom'] || 0],
          align: (style['align'] || 'right').to_sym
        },
        opts_font(style, opts)
      )
    end

    def list_point_alphabetically(int)
      name = 'a'
      (int - 1).times { name.succ! }
      name
    end

    def list_point(style, is_ordered, number)
      return ((style['sign'] || '•')).to_s unless is_ordered

      bullet = style['alphabetical'] ? list_point_alphabetically(number) : number.to_s
      template = style['template'] || '<number>.'
      template.gsub('<number>', bullet.to_s)
    end

    def filter_block_hash(opts)
      hash = {}
      %i[align valign mode final_gap leading fallback_fonts direction indent_paragraphs].each do |key|
        hash[key] = opts[key] if opts.key?(key)
      end
      hash
    end

    def filter_text_hash(opts)
      hash = {}
      %i[text styles size character_spacing font color link anchor draw_text_callback callback].each do |key|
        hash[key] = opts[key] if opts.key?(key)
      end
      hash
    end

    def add_font_style(opts, style)
      merge_opts(opts, { styles: (opts[:styles] || []) + [style] })
    end

    def remove_font_style(opts, style)
      merge_opts(opts, { styles: (opts[:styles] || []) - [style] })
    end

    def text_hash(text, opts, squeeze_whitespace = true)
      text = text.to_s.gsub(/\s+/, ' ') if squeeze_whitespace
      filter_text_hash(merge_opts({ text: text }, opts))
    end

    def html_tag_to_font_style(tag, opts)
      case tag.downcase
      when '<u>'
        add_font_style(opts, :underline)
      when '</u>'
        remove_font_style(opts, :underline)
      when '<b>'
        add_font_style(opts, :bold)
      when '</b>'
        remove_font_style(opts, :bold)
      when '<i>'
        add_font_style(opts, :italic)
      when '</i>'
        remove_font_style(opts, :italic)
      when '<sub>'
        add_font_style(opts, :sub)
      when '</sub>'
        remove_font_style(opts, :sub)
      when '<sup>'
        add_font_style(opts, :sup)
      when '</sup>'
        remove_font_style(opts, :sup)
      when '<strikethrough>'
        add_font_style(opts, :strikethrough)
      when '</strikethrough>'
        remove_font_style(opts, :strikethrough)
      end
    end

    # pdf settings

    def pdf_init_fonts(doc, fonts, fonts_path)
      fonts.each do |font|
        font_name = font['name']
        font_pathname = font['pathname']
        font_path = File.expand_path(File.join(fonts_path, font_pathname))
        doc.font_families.update(
          font_name => {
            bold: File.join(font_path, font['bold']),
            italic: File.join(font_path, font['italic']),
            normal: File.join(font_path, font['regular']),
            bold_italic: File.join(font_path, font['bold-italic'])
          }
        )
      end
    end

    def pdf_document_options(style)
      merge_opts(
        {
          page_size: style['page-size'] || 'A4',
          page_layout: (style['page-layout'] || 'portrait').to_sym,
          background: style['background-image'],
          info: {
            Creator: "md_to_pdf #{MarkdownToPDF::VERSION}",
            CreationDate: Time.now
          },
          compress: true,
          optimize_objects: true
        },
        opts_margin(style)
      )
    end

    def pdf_root_options(style)
      merge_opts(
        opts_font(style, {}),
        { leading: style['leading'] }
      )
    end
  end
end
