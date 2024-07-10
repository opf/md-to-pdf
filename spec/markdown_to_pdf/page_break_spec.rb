require 'pdf_helpers'

describe MarkdownToPDF::Text do
  include_context 'with pdf'

  it 'creates page breaks' do
    generator.parse_file('page/breaks.md')
    expect_pdf([
                 { x: 36.0, y: 747.384, text: "First page" },
                 { x: 36.0, y: 747.384, text: "Second page" },
                 { x: 36.0, y: 747.384, text: "Third page" },
                 { x: 36.0, y: 747.384, text: "Fourth page" },
                 { x: 36.0, y: 747.384, text: "Fifth page" },
                 { x: 36.0, y: 747.384, text: "Sixth page" }])
  end
end
