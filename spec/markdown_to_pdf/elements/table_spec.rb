require 'pdf_helpers'

describe MarkdownToPDF::Table do
  include_context 'pdf_helpers'

  it 'creates a table' do
    generator.parse_file('table/table.md')
    expect(text.strings).to eq([
                                 "Description Column 1", "Description Column 2",
                                 "Lorem ipsum dolor sit amet", "Lorem ipsum dolor sit amet",
                                 "Consectetur adipiscing elit", "Consectetur adipiscing elit",
                                 "Integer molestie lorem at massa", "Integer molestie lorem at massa"
                               ])
  end

  it 'creates formatting in a table' do
    generator.parse_file('table/formatting.md')
    expect(text.strings).to eq(["One", "Two",
                                "f", "or", "m", "at", "ting ", "strikethrough", "Multiple lines", "in cell",
                                "underline", "Links ", "ipsum"])
  end

  it 'creates a headerless table' do
    generator.parse_file('table/headerless.md')
    expect(text.strings).to eq(["Leave the header cells empty", "to create a headerless table", "which can be styled", "differently"])
  end

  it 'creates a table with column align' do
    generator.parse_file('table/alignment.md')
    expect(text.strings).to eq(["Left", "Center", "Right", "1a", "1b", "1c", "2a", "2b", "2c", "3a", "3b", "3c"])
  end

  it 'creates a table with images' do
    generator.parse_file('table/images.md')
    expect(text.strings).to eq(["One", "Two", "Image1", "Image2", "Image3"])
  end

end
