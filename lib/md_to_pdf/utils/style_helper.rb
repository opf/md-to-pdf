module MarkdownToPDF
  module StyleHelper
    def opts_font(style, opts)
      {
        font: style[:font] || opts[:font],
        character_spacing: first_number(style[:character_spacing], opts[:character_spacing]),
        leading: first_number(style[:leading], opts[:leading]),
        styles: (style[:styles] || opts[:styles] || []).map(&:to_sym),
        size: first_number(style[:size], opts[:size]),
        color: style[:color] || opts[:color]
      }.compact
    end

    def opts_margin(style)
      margin = parse_pt(style[:margin])
      {
        left_margin: first_number(parse_pt(style[:margin_left]), margin, 0),
        right_margin: first_number(parse_pt(style[:margin_right]), margin, 0),
        bottom_margin: first_number(parse_pt(style[:margin_bottom]), margin, 0),
        top_margin: first_number(parse_pt(style[:margin_top]), margin, 0)
      }
    end

    def opts_padding(style)
      padding = parse_pt(style[:padding])
      {
        left_padding: first_number(parse_pt(style[:padding_left]), padding, 0),
        right_padding: first_number(parse_pt(style[:padding_right]), padding, 0),
        bottom_padding: first_number(parse_pt(style[:padding_bottom]), padding, 0),
        top_padding: first_number(parse_pt(style[:padding_top]), padding, 0)
      }
    end

    def opts_borders(style)
      borders = []
      no_borders = style[:no_border] == true
      unless no_borders
        borders.push(:left) unless style[:no_border_left]
        borders.push(:right) unless style[:no_border_right]
        borders.push(:top) unless style[:no_border_top]
        borders.push(:bottom) unless style[:no_border_bottom]
      end
      {
        border_colors: opts_borders_colors(style),
        border_widths: opts_borders_width(style),
        borders: borders
      }
    end

    def opts_table_cell(style, opts)
      # :overflow => :shrink_to_fit, :min_font_size => 8,
      merge_opts(
        { background_color: style[:background_color] },
        opts_borders(style),
        opts_font(style, opts),
        opts_table_cell_padding(style)
      )
    end

    def opts_image(style)
      align = (style[:align] || 'center').to_sym
      { position: align }
    end

    def opt_list_point_inline?(style)
      style[:point_inline] == true
    end

    def opt_list_point_spacing(style)
      style[:spacing].nil? ? 0 : parse_pt(style[:spacing])
    end

    def opt_list_point_spanning?(style)
      style[:spanning] == true
    end

    def opt_list_point_sign(style)
      ((style[:sign] || '•')).to_s
    end

    def opt_list_point_alphabetical?(style)
      style[:alphabetical] == true
    end

    def opt_table_header_no_repeating(style)
      style[:no_repeating] == true
    end

    def opts_table_header(style)
      {
        background_color: style[:background_color],
        style: style[:style]&.to_sym,
        size: style[:size],
        color: style[:color]
      }
    end

    def opt_list_point_template(style)
      style[:template] || '<number>.'
    end

    def opt_image_max_width(style)
      parse_pt(style[:max_width])
    end

    def opts_hrule_line_width(style)
      { line_width: first_number(style[:line_width], 1) }
    end

    def opts_paragraph_align(style)
      { align: (style[:align] || 'justify').to_sym }
    end

    def pdf_document_options(style)
      merge_opts(
        {
          page_size: style[:page_size] || 'A4',
          page_layout: (style[:page_layout] || 'portrait').to_sym,
          background: style[:background_image],
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

    def opt_header_footer_offset(style)
      style[:offset] || 0
    end

    def opt_header_footer_align(style)
      (style[:align] || 'left').to_sym
    end

    def opt_header_footer_disabled?(style)
      style[:disabled] == true
    end

    def opt_header_footer_filter_pages(style)
      style[:filter_pages] || []
    end

    def opt_logo_max_width(style)
      parse_pt(style[:max_width])
    end

    def pdf_root_options(style)
      merge_opts(
        opts_font(style, {}),
        { leading: style[:leading] }
      )
    end

    private

    def opts_borders_colors(style)
      color = style[:border_color]
      [
        style[:border_color_top] || color || '000000',
        style[:border_color_right] || color || '000000',
        style[:border_color_bottom] || color || '000000',
        style[:border_color_left] || color || '000000'
      ]
    end

    def opts_table_cell_padding(style)
      padding = parse_pt(style[:padding])
      {
        padding_left: first_number(parse_pt(style[:padding_left]), padding, 0),
        padding_right: first_number(parse_pt(style[:padding_right]), padding, 0),
        padding_bottom: first_number(parse_pt(style[:padding_bottom]), padding, 0),
        padding_top: first_number(parse_pt(style[:padding_top]), padding, 0)
      }
    end

    def opts_borders_width(style)
      border = parse_pt(style[:border_width])
      [
        first_number(parse_pt(style[:border_width_top]), border, 0.25),
        first_number(parse_pt(style[:border_width_right]), border, 0.25),
        first_number(parse_pt(style[:border_width_bottom]), border, 0.25),
        first_number(parse_pt(style[:border_width_left]), border, 0.25)
      ]
    end
  end
end
