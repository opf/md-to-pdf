require 'pdf_helpers'

describe MarkdownToPDF::Page do
  include_context 'with pdf'

  it 'creates page breaks' do
    generator.parse_file('page/breaks.md')
    expect_pdf([
                 { x: 36.0, y: 747.384, text: "Page 1" },
                 { x: 36.0, y: 747.384, text: "Page 2" },
                 { x: 36.0, y: 747.384, text: "Page 3" },
                 { x: 36.0, y: 747.384, text: "Page 4" },
                 { x: 36.0, y: 747.384, text: "Page 5" },
                 { x: 36.0, y: 747.384, text: "Page 6" },
                 { x: 36.0, y: 747.384, text: "Page 7" },
                 { x: 36.0, y: 747.384, text: "Page 8" },
                 { x: 36.0, y: 747.384, text: "Page 9" }])
  end
end
