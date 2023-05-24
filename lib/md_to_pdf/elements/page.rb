module MarkdownToPDF
  module Page
    def repeating_page_footer(doc, opts)
      render_page_footer(doc[:footer], @styles.page_footer, opts)
      render_page_footer(doc[:footer2], @styles.page_footer2, opts)
      render_page_footer(doc[:footer3], @styles.page_footer3, opts)
    end

    def repeating_page_header(doc, opts)
      render_page_header(doc[:header], @styles.page_header, opts)
      render_page_header(doc[:header2], @styles.page_header2, opts)
      render_page_header(doc[:header3], @styles.page_header3, opts)
    end

    def repeating_page_logo(logo, node, opts)
      image_file = image_url_to_local_file(logo, node)
      return if image_file.nil? || image_file.empty?

      image_obj, image_info = @pdf.build_image_object(image_file)

      logo_opts, filter_pages = build_logo_settings(opts, image_info)
      return if logo_opts.nil?

      @pdf.repeat(lambda { |pg| !filter_pages.include?(pg) }) do
        @pdf.embed_image(image_obj, image_info, logo_opts)
      end
    end

    private

    def alignment_to_x(align, width)
      x = 0
      unless align == :left
        x = if align == :right
              @pdf.bounds.width - width
            else
              (@pdf.bounds.width - width) / 2
            end
      end
      x
    end

    def render_page_footer(footer, style, opts)
      return if footer.nil? || footer.empty?

      top = @pdf.bounds.bottom + opt_header_footer_offset(style)
      render_page_repeat_multiline(footer, top, style, opts)
    end

    # page header
    def render_page_header(header, style, opts)
      return if header.nil? || header.empty?

      top = @pdf.bounds.top - opt_header_footer_offset(style)
      render_page_repeat_multiline(header, top, style, opts)
    end

    def build_logo_settings(opts, image_info)
      style = @styles.page_logo
      return [] if opt_header_footer_disabled?(style)

      logo_opts = opts.dup
      top = @pdf.bounds.top - opt_header_footer_offset(style)
      width = @pdf.bounds.width
      logo_height = opt_logo_height(style)
      if logo_height.nil?
        max_width = opt_logo_max_width(style)
        width = [max_width, width].min unless max_width.nil?
        scale = [width / image_info.width.to_f, 1].min
      else
        scale = [logo_height / image_info.height.to_f, 1].min
        width = image_info.width.to_f * scale
      end
      logo_opts[:scale] = scale
      left = alignment_to_x(opt_header_footer_align(style), width)
      logo_opts[:at] = [left, top]
      [logo_opts, opt_header_footer_filter_pages(style)]
    end

    def render_page_repeat_multiline(text, top, style, opts)
      return if opt_header_footer_disabled?(style)

      font_opts = opts_font(style, opts)

      filter_pages = opt_header_footer_filter_pages(style)
      @pdf.repeat(lambda { |pg| !filter_pages.include?(pg) }, dynamic: true) do
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
            width: measure_text_width(line, font_opts)
          }
        end
        lines.each do |line|
          left = alignment_to_x(opt_header_footer_align(style), line[:width])
          @pdf.draw_text(line[:text], font_opts.merge({ at: [left, page_top] }))
          page_top -= line[:height] + (font_opts[:leading] || 0)
        end
      end
    end
  end
end
