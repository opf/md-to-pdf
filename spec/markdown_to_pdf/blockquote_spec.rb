require 'pdf_helpers'

describe MarkdownToPDF::Blockquote do
  include_context 'with pdf'

  it 'creates a blockquote' do
    generator.parse_file('blockquote/blockquote.md')
    expect_pdf([
                 { x: 36.0, y: 744.756, text: "Blockquotes can also be nested…" },
                 { x: 56.0, y: 730.884, text: "…by using additional greater-than signs right next to each other…" },
                 { x: 76.0, y: 717.012, text: "…or with spaces between arrows." }])
  end

  it 'creates a blockquote with image' do
    generator.parse_file('blockquote/image.md')
    expect_pdf([
                 { x: 36.0, y: 744.756, text: "Blockquotes can also contain images…" },
                 { x: 61.0, y: 725.884, text: "…before image" },
                 { x: 61.0, y: 290.822, text: "after image…" }])
  end

  it 'creates a blockquote with limited list support' do
    generator.parse_file('blockquote/list.md')
    expect_pdf([
                 { x: 36.0, y: 744.756, text: "Lists in Blockquotes are currently only partly supported" },
                 { x: 36.0, y: 730.884, text: "entry 1" },
                 { x: 36.0, y: 717.012, text: "entry 2" },
                 { x: 36.0, y: 703.14, text: "entry 3" }])
  end

  it 'creates a blockquote with formatting' do
    generator.parse_file('blockquote/formatting.md')
    expect_pdf([
                 { x: 36.0, y: 744.756, text: "Blockquotes can be f" },
                 { x: 147.156, y: 744.756, text: "or" },
                 { x: 159.156, y: 744.756, text: "m" },
                 { x: 169.152, y: 744.756, text: "att" },
                 { x: 182.496, y: 744.756, text: "ed " },
                 { x: 199.176, y: 744.756, text: "strikethrough" },
                 { x: 268.476, y: 744.756, text: " " },
                 { x: 271.812, y: 744.756, text: "underline" }])
  end
end
