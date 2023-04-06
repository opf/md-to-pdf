require 'pdf_helpers'

describe MarkdownToPDF::Paragraph do
  include_context 'pdf_helpers'

  it 'creates two paragraphs' do
    generator.parse_file('paragraph/paragraph.md')
    expect(text.strings).to eq(["A markdown paragraph", " ", "is marked with two line", " ", "feeds", "This is the second paragraph"])
  end

  it 'creates a paragraphs by html' do
    generator.parse_file('paragraph/html.md')
    expect(text.strings).to eq(["A html paragraph"])
  end

end
