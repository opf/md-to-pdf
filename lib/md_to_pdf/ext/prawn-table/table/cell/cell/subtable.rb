Prawn::Table::Cell::Subtable.prepend(Module.new do
  def width=(new_width)
    @width = @min_width = @max_width = new_width
    @height = nil
    @subtable.cells.width = new_width - padding_left
    @subtable.recalculate_positions
    @width
  end

  def font_style=(style)
    @subtable.cells.font_style = style
  end

  def size=(font_size)
    @subtable.cells.size = font_size
  end
end)
