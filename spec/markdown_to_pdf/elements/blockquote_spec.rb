require 'pdf_helpers'

describe MarkdownToPDF::Blockquote do
  include_context 'pdf_helpers'

  it 'creates a blockquote' do
    generator.parse_file('blockquote/blockquote.md')
    expect(text.strings).to eq(["Blockquotes can also be nested…", "…by using additional greater-than signs right next to each other…", "…or with spaces between arrows."])
  end

  it 'creates a blockquote with image' do
    generator.parse_file('blockquote/image.md')
    expect(text.strings).to eq(["Blockquotes can also contain images…", "…before image", "after image…"])
  end

  it 'creates a blockquote with limited list support' do
    generator.parse_file('blockquote/list.md')
    expect(text.strings).to eq(["Lists in Blockquotes are currently only partly supported", "entry 1", "entry 2", "entry 3"])
  end

  it 'creates a blockquote with formatting' do
    generator.parse_file('blockquote/formatting.md')
    expect(text.strings).to eq(["Blockquotes can be f", "or", "m", "att", "ed ", "strikethrough", " ", "underline"])
  end

end
