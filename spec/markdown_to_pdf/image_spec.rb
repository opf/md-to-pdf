require 'pdf_helpers'

# TODO: test image objects in pdf

describe MarkdownToPDF::Image do
  include_context 'with pdf'

  it 'creates image' do
    generator.parse_file('image/image.md')
    expect_pdf([
                 { x: 36.0, y: 747.384, text: "Floating text above" },
                 { x: 36.0, y: 306.507, text: "and below image" }])
  end

  it 'creates image with classes' do
    generator.parse_file('image/classes.md')
    expect_pdf([])
  end

  it 'creates image by html' do
    generator.parse_file('image/html.md')
    expect_pdf([
                 { x: 36.0, y: 320.379, text: "An image in the middle of " },
                 { x: 174.732, y: 320.379, text: " a headline" },
                 { x: 36.0, y: 320.379, text: "•" },
                 { x: 43.536, y: 320.379, text: "List 1" },
                 { x: 36.0, y: 306.507, text: "•" },
                 { x: 43.536, y: 306.507, text: "An image in the middle of " },
                 { x: 182.268, y: 306.507, text: " a list" },
                 { x: 36.0, y: 326.33809, text: "•" },
                 { x: 43.536, y: 326.33809, text: "List 3" },
                 { x: 41.0, y: 304.83809, text: "Quote 1 An image in the middle of" },
                 { x: 41.0, y: 290.96609, text: "" },
                 { x: 41.0, y: 178.01909, text: "a quote Quote 2" }])
  end

  it 'creates image by footnote' do
    generator.parse_file('image/footnote.md')
    expect_pdf([])
  end
end
