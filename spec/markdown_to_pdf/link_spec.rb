require 'pdf_helpers'

describe MarkdownToPDF::Link do
  include_context 'with pdf'

  it 'creates a link by markdown' do
    generator.parse_file('link/link.md')
    expect_pdf([
                 { x: 36.0, y: 747.384, text: "link text" }])
  end

  it 'creates an automatic link' do
    generator.parse_file('link/auto.md')
    expect_pdf([
                 { x: 36.0, y: 747.384, text: "Auto-converted link " },
                 { x: 141.624, y: 747.384, text: "https://www.openproject.com" }])
  end

  it 'creates a link by html tag' do
    generator.parse_file('link/html.md', { link: { styles: [:bold] } })
    expect_pdf([
                 { x: 36.0, y: 747.384, text: "Inline " },
                 { x: 68.016, y: 747.384, text: "link text" },
                 { x: 113.184, y: 747.384, text: " HTML tag" }])
  end

  it 'creates an anchor link' do
    generator.parse_file('link/anchor.md')
    expect_pdf([
                 { x: 36.0, y: 747.384, text: "Anchor" },
                 { x: 36.0, y: 733.512, text: "Anchor links in document" }])
  end
end
