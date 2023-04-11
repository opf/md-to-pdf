require 'pdf_helpers'

describe MarkdownToPDF::Paragraph do
  include_context 'pdf_helpers'

  it 'creates two paragraphs' do
    generator.parse_file('paragraph/paragraph.md')
    expect_pdf([
                 { x: 36.0, y: 747.384, text: "A markdown paragraph" },
                 { x: 160.356, y: 747.384, text: " " },
                 { x: 163.692, y: 747.384, text: "is marked with two line" },
                 { x: 284.208, y: 747.384, text: " " },
                 { x: 287.544, y: 747.384, text: "feeds" },
                 { x: 36.0, y: 733.512, text: "This is the second paragraph" }])
  end

  it 'creates a paragraphs by html' do
    generator.parse_file('paragraph/html.md')
    expect_pdf([
                 { x: 36.0, y: 747.384, text: "A html paragraph" },
                 { x: 36.0, y: 733.512, text: "A second paragraph" }])
  end
end
