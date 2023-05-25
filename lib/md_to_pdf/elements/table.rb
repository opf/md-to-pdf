require 'prawn/table'

module MarkdownToPDF
  module Table
    def draw_table(node, opts)
      table_font_opts = build_table_font_opts(opts)
      data_rows, header_row_count = build_data_rows(node, table_font_opts, opts)
      table = build_table_settings(header_row_count, opts)
      draw_table_data(table, data_rows, node.table_alignments, opts)
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

    def draw_table_data(table, data_rows, column_alignments, opts)
      return if data_rows.empty?

      data = build_table_data(data_rows, column_alignments, opts)
      pdf_tables = try_build_table(table, data, column_alignments)
      pdf_tables.each do |pdf_table|
        optional_break_before_table(table, pdf_table)
        with_block_margin_all(table[:margins]) do
          pdf_table.draw
        end
      end
    end

    def build_table_font_opts(opts)
      cell_opts = opts_font(@styles.table_cell, opts)
      header_opts = opts_header_font(@styles.table_header, opts)
      { cell: cell_opts, header: header_opts }
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
      auto_column_width = opt_table_auto_column_width(table_style)

      {
        opts_cell: table_cell_style_opts,
        opts_header: opts_table_header(header_style),
        repeating_header: header_row_count == 0 || no_repeating_header ? false : header_row_count,
        margins: opts_margin(table_style),
        header_row_count: header_row_count,
        auto_column_width: auto_column_width
      }
    end

    private

    def build_split_tables(table, data, column_alignments)
      range = 4
      header_row_count = table[:header_row_count]
      pdf_tables = []
      (0..(column_alignments.length - 1)).step(range) do |start|
        new_rows = []
        data.each_with_index do |row, index|
          new_row = row.slice(start, range)
          text = index >= header_row_count ? (index - header_row_count + 1).to_s : ''
          new_row.unshift make_table_cell([{ text: text }], {})
          new_rows.push(new_row)
        end
        new_column_alignments = column_alignments.slice(start, range)
        new_column_alignments.unshift :left
        pdf_table = build_pdf_table(table, table[:opts_cell], new_rows, new_column_alignments)
        pdf_tables.push pdf_table
      end
      pdf_tables
    end

    def try_build_table(table, data, column_alignments)
      [build_pdf_table(table, table[:opts_cell], data, column_alignments)]
    rescue Prawn::Errors::CannotFit
      build_split_tables(table, data, column_alignments)
    end

    def merge_cell_data(cell_data)
      cell_data.map { |part| cell_inline_formatting(part) }.join
    end

    def optional_break_before_table(table, pdf_table)
      header_row_count = table[:header_row_count]
      if header_row_count > 0
        header_cells = pdf_table.cells.columns(0..-1).rows(0..header_row_count) # header AND the first row
        height = header_cells.height + table[:margins][:top_margin]
        threshold = option_table_page_break_threshold
        space_from_bottom = @pdf.y - @pdf.bounds.bottom - height
        if space_from_bottom < threshold
          @pdf.start_new_page
        end
      end
    end

    def build_pdf_table(table, cell_style, data, column_alignments)
      column_count = column_alignments.length
      column_widths = Array.new(column_count, @pdf.bounds.right / column_count)
      @pdf.make_table(
        data,
        width: @pdf.bounds.right,
        header: table[:repeating_header],
        cell_style: cell_style,
        column_widths: table[:auto_column_width] ? [] : column_widths
      ) do
        column_alignments.each_with_index do |alignment, index|
          columns(index).align = alignment unless alignment == nil
        end
        if table[:header_row_count] > 0
          opts_header = table[:opts_header]
          header_cells = cells.columns(0..-1).rows(0..(table[:header_row_count] - 1))
          header_cells.each do |cell|
            cell.background_color = opts_header[:background_color]
            cell.font_style = opts_header[:style]
            cell.text_color = opts_header[:color]
            cell.size = opts_header[:size] || table[:opts_cell][:size]
          end
        end
      end
    end

    def make_subtable(cell_data, opts, alignment)
      rows = []
      row = []
      cell_data.each do |elem|
        if elem.key?(:image)
          rows.push([make_subtable_cell(row, opts)]) unless row.empty?
          image_file = image_url_to_local_file(elem[:image])
          unless image_file.nil? || image_file.empty?
            rows.push([image_in_table_column(image_file, alignment).merge({ borders: [] })])
          end
          row = []
        else
          row.push(elem)
        end
      end
      rows.push([make_subtable_cell(row, opts)]) unless row.empty?
      @pdf.make_table(rows, { position: alignment }) do
        columns(0).align = alignment unless alignment == nil
      end
    end

    def image_in_table_column(image_file, alignment)
      { image: image_file, fit: [100, 100], position: alignment, vposition: :center }
    end

    def build_table_data(data_rows, column_alignments, opts)
      data = []
      data_rows.each do |data_row|
        cells_row = []
        data_row.each_with_index do |cell_data, index|
          cells_row.push(make_table_cell_or_subtable(cell_data, opts, column_alignments[index]))
        end
        data.push(cells_row)
      end
      data
    end

    def make_table_cell_or_subtable(cell_data, opts, alignment)
      image_data = cell_data.find { |elem| elem.key?(:image) }
      if image_data
        image_file = image_url_to_local_file(image_data[:image])
        return image_in_table_column(image_file, alignment) if !(image_file.nil? || image_file.empty?) && cell_data.length === 1

        return make_subtable(cell_data, opts, alignment)
      end
      make_table_cell(cell_data, opts)
    end

    def build_data_rows(node, table_font_opts, opts)
      data_rows = []
      header_row_count = 0
      header_opts = opts.merge(table_font_opts[:header])
      cell_opts = opts.merge(table_font_opts[:cell])
      node.each do |row|
        data_row = []
        row_opts = row.type == :table_header ? header_opts : cell_opts
        row.each do |cell|
          cell_data = data_node_list(cell, row_opts)
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
