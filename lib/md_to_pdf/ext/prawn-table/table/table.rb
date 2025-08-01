# frozen_string_literal: true

# Monkey patch table column calculation, so that small columns don't get shrunk by percentage
# which leeds to ugly single character wrapping.
# Also prawn calculate the min-width of a column the width of the letter "M", not caring about words
#
#  ----------------------------------------------------------------
# | some very long text column that could be shrunk | bad-wrappin |
# | but instead a small column is shrunk, too       | g           |
#  ----------------------------------------------------------------
#
# Workaround:
# * determinate the min column widths _without_ breaking words by chars
# * if the table needs fitting at all:
#     - if smaller than page width: apply min column widths and then grow that with the most content
#     - if larger than page: apply min column widths and then shrink that with the most content

Prawn::Table.prepend(Module.new do
  def column_widths
    return @column_widths unless @column_widths.nil?

    super

    if width - natural_width < -Prawn::FLOAT_PRECISION
      @column_widths = if width - natural_split_column_width < Prawn::FLOAT_PRECISION
                         reduce_to_available_space(natural_split_column_width - width)
                       else
                         distribute_to_available_space(width - natural_split_column_width)
                       end
    end
    @column_widths
  end

  def distribute_to_available_space(available_space)
    cols = natural_split_column_widths.each_with_index
                                      .map { |w, index| { min: w, max: natural_column_widths[index], index: index } }
    done = []
    # first move out already fitting columns
    cols.dup.each do |col|
      if col[:max] - col[:min] < Prawn::FLOAT_PRECISION
        done.push(col)
        cols.delete(col)
      end
    end
    # distribute the available space to the columns, starting with those with the smallest difference
    while (available_space > Prawn::FLOAT_PRECISION) && !cols.empty?
      steps = available_space / cols.length
      cols.dup.sort_by { |e| e[:max] - e[:min] }.each do |col|
        diff = col[:max] - col[:min]
        grow = [diff, steps, available_space].min
        col[:min] += grow
        available_space -= grow
        if col[:max] - col[:min] < Prawn::FLOAT_PRECISION
          done.push(col)
          cols.delete(col)
        end
      end
    end
    list = cols.concat(done)
    # if there is still available space, distribute it equally to the columns
    if available_space > Prawn::FLOAT_PRECISION
      list.each do |c|
        c[:min] += available_space / cols.length
      end
    end

    list.sort_by { |e| e[:index] }.map { |e| e[:min] }
  end

  def reduce_to_available_space(needed)
    split_widths = natural_split_column_widths
    return [[20, split_widths[0] - needed].max] if split_widths.length == 1

    cols = split_widths.each_with_index
                       .map { |w, index| { min: w, max: natural_column_widths[index], index: index } }
    steps = needed / (split_widths.length * 2)

    col = cols.max_by { |e| e[:max] }
    while needed > Prawn::FLOAT_PRECISION
      reduce = [steps, needed].min
      col[:min] -= reduce
      col[:max] -= reduce
      needed -= reduce
      col = cols.max_by { |e| e[:min] }
    end

    cols.map { |e| e[:min] }
  end

  def recalculate_positions
    @natural_row_heights = nil
    position_cells
  end

  def natural_split_column_widths
    @natural_split_column_widths ||= ColumnSplitWidthCalculator.new(cells).natural_split_widths
  end

  def natural_split_column_width
    @natural_split_column_width ||= natural_split_column_widths.inject(0, &:+)
  end
end)
