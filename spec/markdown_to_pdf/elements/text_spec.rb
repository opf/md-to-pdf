require 'pdf_helpers'

describe MarkdownToPDF::Text do
  include_context 'pdf_helpers'

  it 'creates formatting' do
    generator.parse_file('text/formatting.md')
    expect(text.strings).to eq([
                                 "This is ", "bold", " text with ", "**",
                                 "This is ", "bold", " text with ", "__",
                                 "This is ", "italic", " text with ", "*",
                                 "This is ", "italic", " text with ", "_",
                                 "Strikethrough", " with ", "~~",
                                 "<s>...</s>", " for ", "strikethrough", " text",
                                 "<strikethrough>...</strikethrough>", " for ", "strikethrough", " text",
                                 "<strong>...</strong>", " for ", "bold", " text",
                                 "<b>...</b>", " for ", "bold", " text",
                                 "<strong>...</strong>", " for ", "bold", " text",
                                 "<i>...</i>", " for ", "italic", " text",
                                 "<sub>...</sub>", " for ", "subscript", " text",
                                 "<sup>...</sup>", " for ", "superscript", " text"
                               ])
  end

  it 'creates headings' do
    generator.parse_file('text/heading.md')
    expect(text.strings).to eq(["h1 Heading", "h2 Heading", "h3 Heading", "h4 Heading", "h5 Heading", "h6 Heading"])
  end

  it 'creates footnotes' do
    generator.parse_file('text/footnote.md')
    expect(text.strings).to eq([
                                 "Footnote 1 link", "1", ".",
                                 "Footnote 2 link", "2", ".",
                                 "Duplicated footnote reference", "2", ".",
                                 "1", "Footnote ", "can have formatting", "and multiple paragraphs.",
                                 "2", "Footnote text."
                               ]
                            )
  end

end
