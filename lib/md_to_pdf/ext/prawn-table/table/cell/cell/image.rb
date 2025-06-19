Prawn::Table::Cell::Image.prepend(Module.new do
  def initialize(pdf, point, options = {})
    @image_options = {}
    custom_max_width = options.delete(:custom_max_width)
    super

    natural_width(custom_max_width) if custom_max_width && custom_max_width > 0 && custom_max_width < @natural_width
    natural_width(@pdf.bounds.width) if @natural_width > @pdf.bounds.width
  end

  def natural_width(new_width)
    @natural_height = @natural_height * (new_width / @natural_width)
    @natural_width = new_width
  end

  def width=(new_width)
    @width = [new_width, @natural_width].min
    @height = (@natural_height * (@width / @natural_width))
  end

  def natural_content_width
    @width || @natural_width
  end

  def natural_content_height
    [@height || @natural_height, @pdf.bounds.height].min
  end

  def draw_content
    fit_width = [@width, @natural_width].min - padding_left - padding_right
    space_from_bottom = @pdf.y - @pdf.bounds.bottom
    fit_height = [@height, @natural_height, space_from_bottom].min - padding_top - padding_bottom
    @pdf.embed_image(@pdf_object, @image_info, @image_options.merge({ fit: [fit_width, fit_height], vposition: :top }))
  end
end)
