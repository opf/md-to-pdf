Prawn::Table::Cell::Image.prepend(Module.new do
  def initialize(pdf, point, options = {})
    @image_options = {}
    super

    @pdf_object, @image_info = @pdf.build_image_object(@file)
    @natural_width, @natural_height = @image_info.calc_image_dimensions(@image_options)
  end

  def width=(new_width)
    @width = new_width
    @height = (@natural_height * (new_width / @natural_width))
  end

  def natural_content_width
    @width || @natural_width
  end

  def natural_content_height
    @height || @natural_height
  end

  def draw_content
    fit_width = [@width, @natural_width].min - padding_left - padding_right
    fit_height = [@height, @natural_height].min - padding_top - padding_bottom
    @pdf.embed_image(@pdf_object, @image_info,
                     @image_options
                       .merge(fit: [fit_width, fit_height]))
  end
end)
