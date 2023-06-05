module MarkdownToPDF
  module Codeblock
    def draw_codeblock(node, opts)
      cell_style_opts = codeblock_style(opts)
      table_rows = build_codeblock_cell_rows(node, cell_style_opts)
      with_block_margin_all(codeblock_margin_style) do
        @pdf.table(table_rows, width: @pdf.bounds.right, cell_style: cell_style_opts) do
          if table_rows.length > 1
            cells.columns(0).rows(0..0).each { |cell| cell.padding_bottom = 1 }
            cells.columns(0).rows(-1..-1).each { |cell| cell.padding_top = 1 }
            value_cells = cells.columns(0).rows(1..-2)
            value_cells.each do |cell|
              cell.padding_top = 1
              cell.padding_bottom = 1
            end
          end
        end
      end
    end

    private

    def build_codeblock_cell_rows(node, cell_style_opts)
      lines = node.string_content.gsub(' ', Prawn::Text::NBSP).split("\n")
      lines.map do |line|
        [build_codeblock_cell(line, cell_style_opts)]
      end
    end

    def build_codeblock_cell(text, cell_style_opts)
      Prawn::Table::Cell::Text.new(
        @pdf, [0, 0],
        content: text,
        font: cell_style_opts[:font],
        size: cell_style_opts[:size],
        text_color: cell_style_opts[:color]
      )
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
