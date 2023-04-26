require 'pdf_helpers'

# TODO: test image objects in pdf

describe MarkdownToPDF::Image do
  include_context 'with pdf'

  it 'creates image by markdown' do
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
                 { x: 36.0, y: 320.379, text: "An image in the middle of" },
                 { x: 36.0, y: 320.379, text: "a headline" },
                 { x: 36.0, y: 306.507, text: "•" },
                 { x: 43.536, y: 306.507, text: "List 1" },
                 { x: 36.0, y: 292.635, text: "•" },
                 { x: 43.536, y: 292.635, text: "An image in the middle of" },
                 { x: 43.536, y: 326.33809, text: "a list" },
                 { x: 36.0, y: 312.46609, text: "•" },
                 { x: 43.536, y: 312.46609, text: "List 3" },
                 { x: 41.0, y: 290.96609, text: "Quote 1 An image in the middle of" },
                 { x: 41.0, y: 277.09409, text: "" },
                 { x: 41.0, y: 164.14709, text: "a quote Quote 2" }])
  end

  it 'creates image by footnote' do
    generator.parse_file('image/footnote.md')
    expect_pdf([])
  end
end
