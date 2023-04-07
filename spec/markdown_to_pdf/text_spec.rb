require 'pdf_helpers'

describe MarkdownToPDF::Text do
  include_context 'pdf_helpers'

  it 'creates formatting' do
    generator.parse_file('text/formatting.md')
    expect_pdf([
                 { x: 36.0, y: 747.384, text: "This is " },
                 { x: 74.004, y: 747.384, text: "bold" },
                 { x: 99.336, y: 747.384, text: " text with " },
                 { x: 149.664, y: 747.384, text: "**" },
                 { x: 36.0, y: 733.104, text: "This is " },
                 { x: 74.004, y: 733.104, text: "bold" },
                 { x: 99.336, y: 733.104, text: " text with " },
                 { x: 149.664, y: 733.104, text: "__" },
                 { x: 36.0, y: 718.824, text: "This is " },
                 { x: 74.004, y: 718.824, text: "italic" },
                 { x: 98.004, y: 718.824, text: " text with " },
                 { x: 148.332, y: 718.824, text: "*" },
                 { x: 36.0, y: 704.952, text: "This is " },
                 { x: 74.004, y: 704.952, text: "italic" },
                 { x: 98.004, y: 704.952, text: " text with " },
                 { x: 148.332, y: 704.952, text: "_" },
                 { x: 36.0, y: 691.08, text: "Strikethrough" },
                 { x: 107.304, y: 691.08, text: " with " },
                 { x: 135.312, y: 691.08, text: "~~" },
                 { x: 36.0, y: 677.208, text: "<s>...</s>" },
                 { x: 89.376, y: 677.208, text: " for " },
                 { x: 109.692, y: 677.208, text: "strikethrough" },
                 { x: 178.992, y: 677.208, text: " text" },
                 { x: 36.0, y: 663.336, text: "<strikethrough>...</strikethrough>" },
                 { x: 215.976, y: 663.336, text: " for " },
                 { x: 236.292, y: 663.336, text: "strikethrough" },
                 { x: 305.592, y: 663.336, text: " text" },
                 { x: 36.0, y: 649.464, text: "<strong>...</strong>" },
                 { x: 144.072, y: 649.464, text: " for " },
                 { x: 164.388, y: 649.464, text: "bold" },
                 { x: 189.72, y: 649.464, text: " text" },
                 { x: 36.0, y: 635.184, text: "<b>...</b>" },
                 { x: 90.72, y: 635.184, text: " for " },
                 { x: 111.036, y: 635.184, text: "bold" },
                 { x: 136.368, y: 635.184, text: " text" },
                 { x: 36.0, y: 620.904, text: "<strong>...</strong>" },
                 { x: 144.072, y: 620.904, text: " for " },
                 { x: 164.388, y: 620.904, text: "bold" },
                 { x: 189.72, y: 620.904, text: " text" },
                 { x: 36.0, y: 606.624, text: "<i>...</i>" },
                 { x: 82.704, y: 606.624, text: " for " },
                 { x: 103.02, y: 606.624, text: "italic" },
                 { x: 127.02, y: 606.624, text: " text" },
                 { x: 36.0, y: 592.752, text: "<sub>...</sub>" },
                 { x: 116.064, y: 592.752, text: " for " },
                 { x: 136.38, y: 591.30383, text: "subscript" },
                 { x: 164.47594, y: 592.752, text: " text" },
                 { x: 36.0, y: 578.88, text: "<sup>...</sup>" },
                 { x: 116.064, y: 578.88, text: " for " },
                 { x: 136.38, y: 583.14966, text: "superscript" },
                 { x: 170.69538, y: 578.88, text: " text" }])
  end

  it 'creates headings' do
    generator.parse_file('text/heading.md')
    expect_pdf([
                 { x: 36.0, y: 747.384, text: "h1 Heading" },
                 { x: 36.0, y: 733.512, text: "h2 Heading" },
                 { x: 36.0, y: 719.64, text: "h3 Heading" },
                 { x: 36.0, y: 705.768, text: "h4 Heading" },
                 { x: 36.0, y: 691.896, text: "h5 Heading" },
                 { x: 36.0, y: 678.024, text: "h6 Heading" }])
  end

  it 'creates footnotes' do
    generator.parse_file('text/footnote.md')
    expect_pdf([
                 { x: 36.0, y: 747.384, text: "Footnote 1 link" },
                 { x: 114.348, y: 747.384, text: "1" },
                 { x: 121.02, y: 747.384, text: "." },
                 { x: 36.0, y: 733.512, text: "Footnote 2 link" },
                 { x: 114.348, y: 733.512, text: "2" },
                 { x: 121.02, y: 733.512, text: "." },
                 { x: 36.0, y: 719.64, text: "Duplicated footnote reference" },
                 { x: 192.696, y: 719.64, text: "2" },
                 { x: 199.368, y: 719.64, text: "." },
                 { x: 36.0, y: 705.768, text: "1" },
                 { x: 42.672, y: 705.768, text: "Footnote " },
                 { x: 93.012, y: 705.768, text: "can have formatting" },
                 { x: 42.672, y: 691.488, text: "and multiple paragraphs." },
                 { x: 36.0, y: 677.616, text: "2" },
                 { x: 42.672, y: 677.616, text: "Footnote text." }])
  end

end
