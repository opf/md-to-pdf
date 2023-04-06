require 'pdf_helpers'

describe MarkdownToPDF::Image do
  include_context 'pdf_helpers'

  it 'creates image' do
    generator.parse_file('image/image.md')
    expect(text.strings).to eq(["Floating text above", "and below image"])
  end

  it 'creates image with classes' do
    generator.parse_file('image/classes.md')
    expect(text.strings).to eq([])
  end

  it 'creates image by html' do
    generator.parse_file('image/html.md')
    expect(text.strings).to eq([])
  end

  it 'creates image by footnote' do
    generator.parse_file('image/footnote.md')
    expect(text.strings).to eq([])
  end

end
