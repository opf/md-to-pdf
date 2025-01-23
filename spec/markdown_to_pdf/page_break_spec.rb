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

  it 'does not allow dangling headers at the end of page' do
    generator.parse_file('page/smart_header.md', {})
    expect_pdf([
                 { x: 36.0, y: 109.272, text: "Content up until here" },
                 { x: 36.0, y: 95.4, text: "Header 1" },
                 { x: 36.0, y: 81.528, text: "Header 2" },
                 { x: 36.0, y: 67.656, text: "Lorem Ipsum fits on page" },
                 { x: 36.0, y: 95.4, text: "Content up until here" },
                 { x: 36.0, y: 747.384, text: "Header 1" },
                 { x: 36.0, y: 733.512, text: "Header 2" },
                 { x: 36.0, y: 719.64, text: "Lorem Ipsum would be on next page of headers" },
                 { x: 36.0, y: 81.528, text: "Content up until here" },
                 { x: 36.0, y: 747.384, text: "Header 1" },
                 { x: 36.0, y: 733.512, text: "Header 2 would be on the next page of Header 1" },
                 { x: 36.0, y: 719.64, text: "Lorem Ipsum" },
                 { x: 36.0, y: 109.272, text: "Content up until here" },
                 { x: 36.0, y: 747.384, text: "Header 1" },
                 { x: 36.0, y: 730.884, text: "Table would" },
                 { x: 36.0, y: 717.012, text: "be on the next" },
                 { x: 36.0, y: 703.14, text: "page" },
                 { x: 113.14286, y: 730.884, text: "Col 1" },
                 { x: 190.28571, y: 730.884, text: "Col 2" },
                 { x: 267.42857, y: 730.884, text: "Col 3" },
                 { x: 344.57143, y: 730.884, text: "Col 4" },
                 { x: 421.71429, y: 730.884, text: "Col 5" },
                 { x: 498.85714, y: 730.884, text: "Col 6" },
                 { x: 36.0, y: 689.268, text: "Entry 1" },
                 { x: 344.57143, y: 689.268, text: "[x]" },
                 { x: 498.85714, y: 689.268, text: "[x]" },
                 { x: 36.0, y: 675.396, text: "Entry 2" },
                 { x: 344.57143, y: 675.396, text: "[x]" },
                 { x: 421.71429, y: 675.396, text: "[x]" },
                 { x: 36.0, y: 661.524, text: "Entry 3" },
                 { x: 36.0, y: 647.652, text: "Entry 4" },
                 { x: 113.14286, y: 647.652, text: "[x]" },
                 { x: 36.0, y: 137.016, text: "Content up until here" },
                 { x: 36.0, y: 123.144, text: "Header 1" },
                 { x: 36.0, y: 747.384, text: "But does not not create a page break if the next item is already a page break (Header 1 must be at" },
                 { x: 36.0, y: 733.512, text: "the same page as the upper content)" }])
  end

  it 'does not allow page breaks in a just started alert box' do
    generator.parse_file('page/alert_box.md')
    expect_pdf([
                 { x: 36.0, y: 743.172, text: "" },
                 { x: 48.0, y: 743.172, text: " Note" },
                 { x: 36.0, y: 715.428, text: "This is a note that should not be split across pages. It should be displayed in full on the same page." }])
  end
end
