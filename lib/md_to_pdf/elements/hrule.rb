module MarkdownToPDF
  module HRule
    def draw_hrule(_node, _opts)
      opts = hrule_opts
      line_width_before = @pdf.line_width
      with_block_margin(opts) do
        draw_hrule_line(opts)
      end
      @pdf.line_width = line_width_before
    end

    private

    def draw_hrule_line(opts)
      @pdf.line_width = opts[:line_width]
      @pdf.stroke_horizontal_line(
        @pdf.bounds.left + (opts[:left_margin] || 0),
        @pdf.bounds.right - (opts[:right_margin] || 0)
      )
    end

    def hrule_opts
      style = @styles.hrule
      opts_margin(style).merge(opts_hrule_line_width(style))
    end
  end
end
