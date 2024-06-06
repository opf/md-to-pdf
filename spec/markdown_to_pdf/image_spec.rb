require 'pdf_helpers'

# TODO: test image objects in pdf

describe MarkdownToPDF::Image do
  include_context 'with pdf'

  it 'creates image by markdown' do
    generator.parse_file('image/image.md')
    expect_pdf([
                 { x: 36.0, y: 747.384, text: "Floating text above" },
                 { x: 36.0, y: 306.507, text: "and below image" }])
    expect_images_in_pdf(1)
  end

  it 'creates image with classes' do
    generator.parse_file('image/classes.md')
    expect_pdf([])
    expect_images_in_pdf(3)
  end

  it 'creates image by html' do
    generator.parse_file('image/html.md')
    expect_pdf([
                 { x: 36.0, y: 320.379, text: "An image in the middle of" },
                 { x: 36.0, y: 320.379, text: "a headline" },
                 { x: 36.0, y: 306.507, text: "•" },
                 { x: 43.536, y: 306.507, text: "List 1" },
                 { x: 36.0, y: 292.635, text: "•" },
                 { x: 43.536, y: 292.635, text: "An image in the middle of" },
                 { x: 43.536, y: 326.33809, text: "a list" },
                 { x: 36.0, y: 312.46609, text: "•" },
                 { x: 43.536, y: 312.46609, text: "List 3" },
                 { x: 41.0, y: 739.756, text: "Quote 1 An image in the middle of" },
                 { x: 41.0, y: 288.879, text: "a quote Quote 2" }])
    expect_images_in_pdf(4)
  end

  it 'creates image by footnote' do
    generator.parse_file('image/footnote.md')
    expect_pdf([{ x: 36.0, y: 320.379, text: "The demo image" }])
    expect_images_in_pdf(1)
  end

  it 'creates image with caption' do
    generator.parse_file('image/caption.md', { image: { caption: { align: :center, size: 10 } } })
    expect_pdf([{ x: 264.315, y: 321.815, text: "Image with caption" }])
    expect_images_in_pdf(1)
  end

  it 'creates image with figure and caption' do
    generator.parse_file('image/figure.md', { image: { margin_bottom: 100, caption: { align: :center, size: 10 } } })
    expect_pdf([{ x: 273.85, y: 321.815, text: "Dummy image" }])
    expect_images_in_pdf(1)
  end

  it 'creates image in table' do
    generator.parse_file('image/in_table.md', { image: { margin_bottom: 100, caption: { align: :center, size: 10 } } })
    expect_pdf([
                 { x: 41.0, y: 739.756, text: "Lorem ipsum dolor sit amet, consetetur" },
                 { x: 41.0, y: 725.884, text: "sadipscing elitr, sed diam nonumy eirmod tempor" },
                 { x: 41.0, y: 712.012, text: "" },
                 { x: 41.0, y: 474.6375, text: "Lorem ipsum dolor sit amet, consetetur" },
                 { x: 41.0, y: 460.7655, text: "sadipscing elitr, sed diam nonumy eirmod" },
                 { x: 41.0, y: 446.8935, text: "tempor " },
                 { x: 306.0, y: 744.756, text: "Lorem ipsum dolor sit amet, consetetur sadipscing" },
                 { x: 306.0, y: 730.884, text: "elitr, sed diam nonumy eirmod tempor invidunt ut" },
                 { x: 306.0, y: 717.012, text: "labore et dolore magna aliquyam erat, sed diam" },
                 { x: 306.0, y: 703.14, text: "voluptua. At vero eos et accusam et justo duo" },
                 { x: 306.0, y: 689.268, text: "dolores et ea rebum. Stet clita kasd gubergren, no" },
                 { x: 306.0, y: 675.396, text: "sea takimata sanctus est L" },
                 { x: 36.0, y: 744.756, text: "Lorem ipsum dolor sit amet, consetetur sadipscing" },
                 { x: 36.0, y: 730.884, text: "elitr, sed diam nonumy" },
                 { x: 311.0, y: 739.756, text: "Lorem ipsum dolor sit amet, consetetur" },
                 { x: 311.0, y: 725.884, text: "sadipscing elitr, sed diam nonumy eirmod tempor" },
                 { x: 311.0, y: 712.012, text: "" },
                 { x: 311.0, y: 474.6375, text: "Lorem ipsum dolor sit amet, consetetur" },
                 { x: 311.0, y: 460.7655, text: "sadipscing elitr, sed diam nonumy eirmod" },
                 { x: 311.0, y: 446.8935, text: "tempor " },
                 { x: 311.0, y: 209.519, text: "Lorem ipsum dolor sit amet, consetetur" },
                 { x: 311.0, y: 195.647, text: "sadipscing elitr, sed diam nonumy eirmod tempor" },
                 { x: 311.0, y: 181.775, text: "" },
                 { x: 36.0, y: 744.756, text: "Lorem ipsum dolor sit amet," },
                 { x: 36.0, y: 730.884, text: "consetetur sadipscing elitr, sed" },
                 { x: 36.0, y: 717.012, text: "diam nonumy" },
                 { x: 216.0, y: 744.756, text: "Lorem ipsum dolor sit amet," },
                 { x: 216.0, y: 730.884, text: "consetetur sadipscing elitr, sed" },
                 { x: 216.0, y: 717.012, text: "diam nonumy" },
                 { x: 401.0, y: 739.756, text: "Lorem ipsum dolor sit amet," },
                 { x: 401.0, y: 725.884, text: "consetetur sadipscing elitr, sed" },
                 { x: 401.0, y: 712.012, text: "diam nonumy eirmod tempor" },
                 { x: 401.0, y: 698.14, text: "invidunt ut labore et dolore" },
                 { x: 401.0, y: 684.268, text: "magna aliquyam erat, " },
                 { x: 401.0, y: 670.396, text: "" },
                 { x: 401.0, y: 504.189, text: "Lorem ipsum dolor sit amet," },
                 { x: 401.0, y: 490.317, text: "consetetur sadipscing elitr, sed" },
                 { x: 401.0, y: 476.445, text: "diam nonumy eirmod tempor " },
                 { x: 41.0, y: 452.573, text: "" },
                 { x: 41.0, y: 265.17987, text: "" }])
    expect_images_in_pdf(5)
  end
end
