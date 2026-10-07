require 'prawn-svg'

module MarkdownToPDF
  module Svg
    # prawn-svg resolves external references unless told not to: :enable_web_requests
    # defaults to true and only warns. These are passed on every call, which is why
    # @pdf.svg must never be called anywhere but in draw_svg_string.
    SVG_RENDER_OPTIONS = {
      enable_web_requests: false,
      enable_file_requests_with_root: nil,
      cache_images: false,
      log_warnings: false
    }.freeze

    def draw_svg_string(svg, opts = {})
      font_name = svg_font_name(opts)
      clean = SvgSanitizer.sanitize(svg, font_family: font_name)
      return false if clean.nil?

      @pdf.svg(clean[:svg], **SVG_RENDER_OPTIONS, width: svg_draw_width(clean), fallback_font_name: font_name)
      true
    rescue StandardError
      false
    end

    private

    # Keeps the diagram on fonts the document registered itself. Without this
    # prawn-svg falls back to whatever it finds in the host system font paths,
    # so the same markdown would render differently on a developer machine
    # and on CI.
    def svg_font_name(opts)
      name = opts[:font]
      return name if name && @pdf.font_families.key?(name)

      @pdf.font.family
    end

    def svg_draw_width(clean)
      available = @pdf.bounds.width
      width, height = svg_intrinsic_size(clean)
      return available if width.nil? || width <= 0

      scale = [available / width, 1].min
      scale = [scale, @pdf.bounds.height / height].min if height && height > 0
      width * scale
    end

    def svg_intrinsic_size(clean)
      width = svg_length(clean[:width])
      height = svg_length(clean[:height])
      return [width, height] if width && height

      box = clean[:view_box].to_s.strip.split(/[\s,]+/)
      return [width, height] unless box.length == 4

      [width || box[2].to_f, height || box[3].to_f]
    end

    def svg_length(value)
      return nil if value.nil? || value.to_s.strip.end_with?('%')

      parse_pt(value)
    end
  end
end
