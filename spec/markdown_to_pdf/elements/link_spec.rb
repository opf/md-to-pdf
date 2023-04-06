require 'pdf_helpers'

describe MarkdownToPDF::Link do
  include_context 'pdf_helpers'

  it 'creates a link' do
    generator.parse_file('link/link.md')
    expect(text.strings).to eq(["link text"])
  end

  it 'creates an automatic link' do
    generator.parse_file('link/auto.md')
    expect(text.strings).to eq(["Auto-converted link ", "https://www.openproject.com"])
  end

  it 'creates a link by html tag' do
    generator.parse_file('link/html.md')
    expect(text.strings).to eq(["Inline ", "link text", " HTML tag"])
  end

  it 'creates an anchor link' do
    generator.parse_file('link/anchor.md')
    expect(text.strings).to eq(["Anchor", "Anchor links in document"])
  end

end
