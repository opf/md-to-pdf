module MarkdownToPDF
  module Blockquote
    def data_blockquote(node, opts)
      result = []
      case node.type
      when :paragraph
        result.push(data_blockquote_paragraph(node, opts))
      when :blockquote
        result.push(data_blockquote_quote(node, opts))
      when :list
        cells = data_blockquote_list(node, opts)
        cells.each { |cell| result.push([cell]) }
      else
        warn("Unsupported node.type #{node.type} in data_blockquote()", node.type, node)
      end
      result
    end

    def draw_blockquote(node, opts)
      cell_style_opts = blockquote_opts(opts)
      margin_opts = blockquote_margins_opts(opts)
      data = blockquote_data_rows(node, cell_style_opts)
      return if data.empty?

      with_block_margin_all(margin_opts) do
        draw_blockquote_table(data, cell_style_opts)
      end
    end

    private

    def data_blockquote_paragraph(node, opts)
      cell_data = data_node_children(node, opts)
      [make_table_cell_or_subtable(cell_data, opts, :left)]
    end

    def data_blockquote_list(node, opts)
      result = []
      node.to_a.select { |sub| sub.type == :list_item }.each do |sub|
        sub.to_a.each do |paragraph|
          cell_data = data_node_children(paragraph, opts)
          unless cell_data.empty?
            cell = make_table_cell_or_subtable(cell_data, opts, :left)
            result.push(cell)
          end
        end
      end
      result
    end

    def data_blockquote_quote(node, opts)
      subtable_rows = []
      node.each do |child|
        subtable_data = data_blockquote(child, opts)
        subtable_rows.concat(subtable_data)
      end
      return [] if subtable_rows.empty?

      subtable = @pdf.make_table(subtable_rows, cell_style: opts) do
        (0..(row_length)).each do |i|
          rows(i).padding_left = 20
          rows(i).padding_top = 0
          rows(i).padding_bottom = 0
          rows(i).padding_right = 0
        end
      end
      [subtable]
    end

    def draw_blockquote_table(data, cell_style_opts)
      @pdf.table(data, width: @pdf.bounds.right, cell_style: cell_style_opts) do
        (0..(row_length - 2)).each do |i|
          rows(i).padding_bottom = cell_style_opts[:leading] || 0
        end
        (1..(row_length)).each do |i|
          rows(i).padding_top = cell_style_opts[:leading] || 0
        end
      end
    end

    def blockquote_data_rows(node, cell_style_opts)
      data_rows = []
      node.each do |row|
        data_rows.concat(data_blockquote(row, cell_style_opts))
      end
      data_rows
    end

    def blockquote_opts(opts)
      style = @styles.blockquote
      opts_table_cell(style, opts)
    end

    def blockquote_margins_opts(_opts)
      style = @styles.blockquote
      opts_margin(style)
    end
  end
end
