require 'pdf_helpers'

describe MarkdownToPDF::Core do
  include_context 'with pdf'

  it 'does not show comments' do
    generator.parse_file('comments/comments.md')
    expect_pdf([
                 { x: 36.0, y: 747.384, text: "HTML comment tags" },
                 { x: 36.0, y: 733.512, text: "Here’s a paragraph that will be visible." },
                 { x: 36.0, y: 719.64, text: "And here’s another paragraph that’s visible." },
                 { x: 36.0, y: 705.768, text: "Markdown comments" },
                 { x: 36.0, y: 691.896, text: "Here’s a paragraph that will be visible." },
                 { x: 36.0, y: 678.024, text: "And here’s another paragraph that’s visible." },
                 { x: 36.0, y: 664.152, text: "Weird comments" },
                 { x: 36.0, y: 650.28, text: "Here’s a paragraph that will be visible." },
                 { x: 36.0, y: 636.408, text: "And here’s another paragraph that’s visible." }])
  end
end
