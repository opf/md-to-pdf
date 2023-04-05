module MarkdownToPDF
  module Footnotes
    def draw_footnote_definition(node, _opts)
      footnotes.push(node)
      nil
    end

    def draw_footnotes(opts)
      footnote_anchor_opts = build_footnote_anchor_opts(opts)
      footnotes.each_with_index do |node, index|
        footnote_anchor_width = measure_text_width((index + 1).to_s, footnote_anchor_opts)
        add_link_destination("ft_#{index + 1}")
        @pdf.float { @pdf.formatted_text([text_hash((index + 1).to_s, footnote_anchor_opts)]) }
        @pdf.indent(footnote_anchor_width) do
          draw_node(node, opts)
        end
      end
    end

    def data_footnote_reference(node, opts)
      style = @styles.footnote_reference
      link_opts = opts_font(style, opts)
      link_opts[:anchor] = "ft_#{node.string_content}"
      text_hash(node.string_content, link_opts)
    end

    def footnotes
      @footnotes ||= []
    end

    private

    def build_footnote_anchor_opts(opts)
      opts_font(@styles.footnote_definition_point, opts)
    end
  end
end
