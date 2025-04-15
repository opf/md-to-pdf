# frozen_string_literal: true

# Extended Prawn::Table::ColumnWidthCalculator
# which collects columns widths by cell split_width

# rubocop:disable Style/CombinableLoops
class ColumnSplitWidthCalculator < Prawn::Table::ColumnWidthCalculator
  def natural_split_widths
    # calculate natural column width for all rows that do not include a span dummy
    @cells.each do |cell|
      unless has_a_span_dummy?(cell.row)
        @widths_by_column[cell.column] =
          [@widths_by_column[cell.column], cell.split_width.to_f].max
      end
    end

    # integrate natural column widths for all rows that do include a span dummy
    @cells.each do |cell|
      next unless has_a_span_dummy?(cell.row)

      # the "mother" cell will calculate the width of a SpanDummy cell
      next if cell.is_a?(::Prawn::Table::Cell::SpanDummy)

      if cell.colspan == 1
        @widths_by_column[cell.column] =
          [@widths_by_column[cell.column], cell.split_width.to_f].max
      else
        # calculate the current with of all cells that will be spanned by the current cell
        current_width_of_spanned_cells =
          @widths_by_column.to_a[cell.column..(cell.column + cell.colspan - 1)]
                           .collect { |_key, value| value }.inject(0, :+)

        # update the Hash only if the new with is at least equal to the old one
        # due to arithmetic errors we need to ignore a small difference in the new and the old sum
        # the same had to be done in the column_widht_calculator#natural_width
        update_hash = ((cell.split_width.to_f - current_width_of_spanned_cells) >
          Prawn::FLOAT_PRECISION)

        if update_hash
          # Split the width of colspanned cells evenly by columns
          width_per_column = cell.split_width.to_f / cell.colspan
          # Update the Hash
          cell.colspan.times do |i|
            @widths_by_column[cell.column + i] = width_per_column
          end
        end
      end
    end

    @widths_by_column.sort_by { |col, _| col }.map { |_, w| w }
  end
end
# rubocop:enable Style/CombinableLoops
