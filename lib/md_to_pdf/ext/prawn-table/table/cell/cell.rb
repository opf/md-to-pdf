# frozen_string_literal: true

# Monkey patch table cell
# * introduce width calculations by longest word in cell (text cells only)

Prawn::Table::Cell.prepend(Module.new do
  def split_content_width
    if respond_to?(:natural_split_content_width)
      natural_split_content_width
    else
      natural_content_width
    end
  end

  def split_width_ignoring_span
    split_content_width + padding_left + padding_right
  end

  def split_width
    return split_width_ignoring_span if @colspan == 1 && @rowspan == 1

    # We're in a span group; get the maximum width per column (including
    # the master cell) and sum each column.
    column_widths = Hash.new(0)
    dummy_cells.each do |cell|
      column_widths[cell.column] =
        [column_widths[cell.column], cell.width].max
    end
    column_widths[column] = [column_widths[column], split_width_ignoring_span].max
    column_widths.values.inject(0, &:+)
  end

  def width=(new_width)
    @min_width = new_width unless defined?(@min_width)
    @max_width = new_width unless defined?(@max_width)
    @width = new_width
  end
end)
