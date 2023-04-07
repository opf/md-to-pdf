require 'pdf_helpers'

# TODO: test image objects in pdf

describe MarkdownToPDF::Image do
  include_context 'pdf_helpers'

  it 'creates image' do
    generator.parse_file('image/image.md')
    expect_pdf([
                 {x:36.0, y:747.384, text:"Floating text above"},
                 {x:36.0, y:306.507, text:"and below image"}])
  end

  it 'creates image with classes' do
    generator.parse_file('image/classes.md')
    expect_pdf([])
  end

  it 'creates image by html' do
    generator.parse_file('image/html.md')
    expect_pdf([])
  end

  it 'creates image by footnote' do
    generator.parse_file('image/footnote.md')
    expect_pdf([])
  end
end
