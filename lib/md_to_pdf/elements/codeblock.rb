module MarkdownToPDF
  module Codeblock
    def draw_codeblock(node, opts)
      cell_style_opts = codeblock_style(opts)
      cell = build_codeblock_cell(node, cell_style_opts)
      with_block_margin_all(codeblock_margin_style) do
        @pdf.table([[cell]], width: @pdf.bounds.right, cell_style: cell_style_opts)
      end
    end

    private

    def build_codeblock_cell(node, cell_style_opts)
      text = node.string_content.gsub(' ', Prawn::Text::NBSP)
      make_subtable_cell([cell_style_opts.merge({ text: text })], cell_style_opts)
    end

    def codeblock_style(opts)
      style = @styles.codeblock
      opts_table_cell(style, opts).merge({ border_width: 0 })
    end

    def codeblock_margin_style
      style = @styles.codeblock
      opts_margin(style)
    end
  end
end
