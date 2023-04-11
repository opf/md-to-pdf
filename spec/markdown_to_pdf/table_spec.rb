require 'pdf_helpers'

describe MarkdownToPDF::Table do
  include_context 'with pdf'

  it 'creates a table' do
    generator.parse_file('table/table.md')
    expect_pdf([
                 { x: 36.0, y: 744.756, text: "Description Column 1" },
                 { x: 306.0, y: 744.756, text: "Description Column 2" },
                 { x: 36.0, y: 730.884, text: "Lorem ipsum dolor sit amet" },
                 { x: 306.0, y: 730.884, text: "Lorem ipsum dolor sit amet" },
                 { x: 36.0, y: 717.012, text: "Consectetur adipiscing elit" },
                 { x: 306.0, y: 717.012, text: "Consectetur adipiscing elit" },
                 { x: 36.0, y: 703.14, text: "Integer molestie lorem at massa" },
                 { x: 306.0, y: 703.14, text: "Integer molestie lorem at massa" }])
  end

  it 'creates formatting in a table' do
    generator.parse_file('table/formatting.md')
    expect_pdf([
                 { x: 160.16, y: 744.756, text: "One" },
                 { x: 306.0, y: 744.756, text: "Two" },
                 { x: 107.84, y: 730.884, text: "f" },
                 { x: 111.176, y: 730.884, text: "or" },
                 { x: 123.176, y: 730.884, text: "m" },
                 { x: 133.172, y: 730.884, text: "at" },
                 { x: 143.18, y: 730.884, text: "ting " },
                 { x: 165.86, y: 730.884, text: "strikethrough" },
                 { x: 306.0, y: 730.884, text: "Multiple lines" },
                 { x: 306.0, y: 717.012, text: "in cell" },
                 { x: 146.732, y: 703.14, text: "underline" },
                 { x: 306.0, y: 703.14, text: "Links " },
                 { x: 337.344, y: 703.14, text: "ipsum" }])
  end

  it 'creates a headerless table' do
    generator.parse_file('table/headerless.md')
    expect_pdf([
                 { x: 36.0, y: 744.756, text: "Leave the header cells empty" },
                 { x: 367.49, y: 744.756, text: "to create a headerless table" },
                 { x: 36.0, y: 730.884, text: "which can be styled" },
                 { x: 415.67, y: 730.884, text: "differently" }])
  end

  it 'creates a table with column align' do
    generator.parse_file('table/alignment.md')
    expect_pdf([
                 { x: 36.0, y: 744.756, text: "Left" },
                 { x: 288.494, y: 744.756, text: "Center" },
                 { x: 548.992, y: 744.756, text: "Right" },
                 { x: 36.0, y: 730.884, text: "1a" },
                 { x: 299.828, y: 730.884, text: "1b" },
                 { x: 564.328, y: 730.884, text: "1c" },
                 { x: 36.0, y: 717.012, text: "2a" },
                 { x: 299.828, y: 717.012, text: "2b" },
                 { x: 564.328, y: 717.012, text: "2c" },
                 { x: 36.0, y: 703.14, text: "3a" },
                 { x: 299.828, y: 703.14, text: "3b" },
                 { x: 564.328, y: 703.14, text: "3c" }])
  end

  it 'creates a table with images' do
    generator.parse_file('table/images.md')
    expect_pdf([
                 { x: 160.16, y: 744.756, text: "One" },
                 { x: 306.0, y: 744.756, text: "Two" },
                 { x: 151.99, y: 725.884, text: "Image1" },
                 { x: 151.99, y: 612.937, text: "Image2" },
                 { x: 311.0, y: 725.884, text: "Image3" }])
  end
end