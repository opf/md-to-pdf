require 'prawn/table'

module MarkdownToPDF
  module Table
    def draw_table(node, opts)
      data_rows, header_row_count = build_data_rows(node, opts)
      return if data_rows.empty?

      column_widths = Array.new(node.table_alignments.length, @pdf.bounds.right / node.table_alignments.length)
      table = build_table_settings(header_row_count, opts)
      data = build_table_data(table, column_widths, data_rows, node, opts)
      pdf_table = build_pdf_table(column_widths, data, node, table)

      optional_break_before_table(table, pdf_table)
      with_block_margin_all(table[:margins]) do
        pdf_table.draw
      end
    end

    def make_subtable_cell(cell_data, opts)
      Prawn::Table::Cell::Text.new(
        @pdf, [0, 0],
        content: merge_cell_data(cell_data),
        font: opts[:font],
        size: opts[:size],
        borders: [],
        inline_format: true
      )
    end

    def make_table_cell(cell_data, opts)
      Prawn::Table::Cell::Text.new(
        @pdf, [0, 0],
        content: merge_cell_data(cell_data),
        font: opts[:font],
        size: opts[:size],
        padding: opts[:cell_padding],
        inline_format: true
      )
    end

    private

    def merge_cell_data(cell_data)
      cell_data.map { |part| cell_inline_formatting(part) }.join
    end

    def optional_break_before_table(table, pdf_table)
      header_row_count = table[:header_row_count]
      if header_row_count > 0
        header_cells = pdf_table.cells.columns(0..-1).rows(0..header_row_count) # header AND the first row
        height = header_cells.height + table[:margins][:top_margin]
        threshold = 80
        space_from_bottom = @pdf.y - @pdf.bounds.bottom - height
        if space_from_bottom < threshold
          @pdf.start_new_page
        end
      end
    end

    def build_pdf_table(column_widths, data, node, table)
      @pdf.make_table(
        data,
        width: @pdf.bounds.right,
        header: table[:repeating_header],
        cell_style: table[:table_cell_style_opts],
        column_widths: column_widths
      ) do
        node.table_alignments.each_with_index do |alignment, index|
          columns(index).align = alignment unless alignment == nil
        end
        if table[:header_row_count] > 0
          opts_header = table[:opts_header]
          header_cells = cells.columns(0..-1).rows(0..(table[:header_row_count] - 1))
          header_cells.each do |cell|
            cell.background_color = opts_header[:background_color]
            cell.font_style = opts_header[:style]
            cell.text_color = opts_header[:color]
            cell.size = opts_header[:size] || table[:table_cell_style_opts][:size]
          end
        end
      end
    end

    def make_subtable(cell_data, opts, alignment, width)
      rows = []
      row = []
      cell_data.each do |elem|
        if elem[:image]
          rows.push([make_subtable_cell(row, opts)]) unless row.empty?
          rows.push([image_in_table_column(elem, width).merge({ borders: [] })])
          row = []
        else
          row.push(elem)
        end
      end
      rows.push([make_subtable_cell(row, opts)]) unless row.empty?
      @pdf.make_table(rows, width: width) do
        columns(0).align = alignment unless alignment == nil
      end
    end

    def image_in_table_column(image_data, width)
      image_data.merge({ fit: [width, 200], position: :center, vposition: :center })
    end

    def build_table_data(table, column_widths, data_rows, node, opts)
      data = []
      data_rows.each do |data_row|
        cells_row = []
        padding_left = table[:table_cell_style_opts][:padding_left] || 0
        padding_right = table[:table_cell_style_opts][:padding_right] || 0
        data_row.each_with_index do |cell_data, index|
          cell_width = column_widths[index] - padding_left - padding_right
          cells_row.push(make_table_cell_or_subtable(cell_data, opts, node.table_alignments[index], cell_width))
        end
        data.push(cells_row)
      end
      data
    end

    def make_table_cell_or_subtable(cell_data, opts, alignment, width)
      image_data = cell_data.find { |elem| elem[:image] }
      if image_data
        return image_in_table_column(image_data, width) if cell_data.length === 1

        return make_subtable(cell_data, opts, alignment, width)
      end
      make_table_cell(cell_data, opts)
    end

    def build_table_settings(header_row_count, opts)
      table_style = @styles.table
      cell_style = @styles.table_cell
      header_style = @styles.table_header

      if header_row_count == 0
        table_style = @styles.headless_table
        cell_style = @styles.headless_table_cell
        header_style = @styles.headless_table_header
      end

      table_cell_style_opts = opts_table_cell(cell_style, opts)
      no_repeating_header = opt_table_header_no_repeating(header_style)

      {
        table_cell_style_opts: table_cell_style_opts,
        repeating_header: header_row_count == 0 || no_repeating_header ? false : header_row_count,
        opts_header: opts_table_header(header_style),
        margins: opts_margin(table_style),
        header_row_count: header_row_count
      }
    end

    def build_data_rows(node, opts)
      data_rows = []
      header_row_count = 0
      node.each do |row|
        data_row = []
        row.each do |cell|
          cell_data = data_node_list(cell, opts)
          data_row.push(cell_data)
        end
        if row.type == :table_header
          non_empty = data_row.find { |cell_data| !cell_data.empty? }
          next if non_empty.nil?

          header_row_count += 1
        end
        data_rows.push(data_row)
      end
      [data_rows, header_row_count]
    end
  end
end
