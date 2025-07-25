require 'pdf_helpers'

describe MarkdownToPDF::Table do
  include_context 'with pdf'

  it 'creates a table by markdown' do
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

  it 'creates formatting in a html table' do
    generator.parse_file('table/html_formatting.html')
    expect_pdf([
                 { x: 36.0, y: 744.756, text: "Strikeout" },
                 { x: 83.292, y: 744.756, text: " " },
                 { x: 86.628, y: 744.756, text: "Strikethough" },
                 { x: 306.0, y: 744.756, text: "Bold" },
                 { x: 332.664, y: 744.756, text: " " },
                 { x: 336.0, y: 744.756, text: "Strong" },
                 { x: 36.0, y: 730.476, text: "Italic" },
                 { x: 60.672, y: 730.476, text: " " },
                 { x: 64.008, y: 730.476, text: "Emphasis" },
                 { x: 306.0, y: 730.476, text: "Underline" },
                 { x: 357.528, y: 730.476, text: " " },
                 { x: 360.864, y: 734.74566, text: "sup" },
                 { x: 372.14155, y: 730.476, text: " " },
                 { x: 375.47755, y: 729.02783, text: "sub" }])
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

  it 'creates a html table with cell align' do
    generator.parse_file('table/alignment.html',
                         {
                           html_table: {
                             cell: {
                               border_width: 0.25,
                               border_color: "000000"
                             }
                           }
                         })
    expect_pdf([
                 { x: 36.0, y: 744.756, text: "Left" },
                 { x: 396.0, y: 744.756, text: "Lorem ipsum dolor sit amet," },
                 { x: 396.0, y: 730.884, text: "consetetur sadipscing elitr, sed" },
                 { x: 396.0, y: 717.012, text: "diam nonumy eirmod tempor" },
                 { x: 288.494, y: 703.14, text: "Center" },
                 { x: 548.992, y: 689.268, text: "Right" }
               ])
  end

  it 'creates a html table with vertical cell align' do
    generator.parse_file('table/valignment.html',
                         {
                           html_table: {
                             cell: {
                               border_width: 0.25,
                               border_color: "000000",
                               valign: 'center'
                             }
                           }
                         })
    expect_pdf([
                 { x: 306.0, y: 744.756, text: "Top" },
                 { x: 306.0, y: 582.1, text: "Center" },
                 { x: 306.0, y: 421.928, text: "Bottom" },
                 { x: 306.0, y: 380.956, text: "Default (center)" }
               ])
  end

  it 'creates a table with images' do
    generator.parse_file('table/images.md')
    expect_pdf([
                 { x: 160.16, y: 744.756, text: "One" },
                 { x: 306.0, y: 744.756, text: "Two" },
                 { x: 151.49, y: 725.884, text: "Image1" },
                 { x: 151.49, y: 488.5095, text: "Image2" },
                 { x: 311.0, y: 725.884, text: "Image3" }])
  end

  it 'creates a table with an invalid images' do
    generator.parse_file('table/invalid_images.md')
    expect_pdf([
                 { x: 160.16, y: 744.756, text: "One" },
                 { x: 306.0, y: 744.756, text: "Two" },
                 { x: 311.0, y: 725.884, text: "Image2" }])
  end

  it 'creates a html table with checkboxes' do
    generator.parse_file('table/html_checklist.html')
    expect_pdf([
                 { x: 113.14286, y: 744.756, text: "Header 1" },
                 { x: 190.28571, y: 744.756, text: "Header 2" },
                 { x: 267.42857, y: 744.756, text: "Header 3" },
                 { x: 344.57143, y: 744.756, text: "Header 4" },
                 { x: 421.71429, y: 744.756, text: "Header 5" },
                 { x: 498.85714, y: 744.756, text: "Header 6" },
                 { x: 36.0, y: 730.884, text: "Entry 1" },
                 { x: 344.57143, y: 730.884, text: "[x]" },
                 { x: 498.85714, y: 730.884, text: "[x]" },
                 { x: 36.0, y: 717.012, text: "Entry 2" },
                 { x: 344.57143, y: 717.012, text: "[x]" },
                 { x: 421.71429, y: 717.012, text: "[x]" },
                 { x: 36.0, y: 703.14, text: "Entry 3" },
                 { x: 36.0, y: 689.268, text: "Entry 4" },
                 { x: 113.14286, y: 689.268, text: "[x]" }])
  end

  it 'creates a table without bad wrapping with doc font style' do
    generator.parse_file('table/wrapping.md', { table: { auto_width: true, cell: { padding: 6 } } })
    expect_pdf([
                 { x: 42.0, y: 738.756, text: "A cell with long “unbreakble“ text" },
                 { x: 464.628, y: 738.756, text: "Status" },
                 { x: 536.64, y: 738.756, text: "ID" },
                 { x: 42.0, y: 712.884, text: "https://example.com/example/example/blob/main/lib/md_to_pdf/elements/tabl" },
                 { x: 42.0, y: 699.012, text: "e.rb#L3" },
                 { x: 464.628, y: 712.884, text: "clarification" }, # clarification is not broken by char
                 { x: 536.64, y: 712.884, text: "42958" }]) # 42958 is not broken by char
  end

  it 'creates a table without bad wrapping with cell style' do
    generator.parse_file('table/wrapping.md', { table: { auto_width: true, header: { styles: ['bold'] }, cell: { padding: 6, size: 20 } } })
    expect_pdf([
                 { x: 42.0, y: 733.012, text: "A cell with long “unbreakble“ text" },
                 { x: 402.38, y: 733.012, text: "Status" },
                 { x: 514.4, y: 733.012, text: "ID" },
                 { x: 42.0, y: 697.212, text: "https://example.com/example/example/" },
                 { x: 42.0, y: 674.092, text: "blob/main/lib/md_to_pdf/elements/table" },
                 { x: 42.0, y: 650.972, text: ".rb#L3" },
                 { x: 402.38, y: 697.212, text: "clarification" }, # clarification is not broken by char
                 { x: 514.4, y: 697.212, text: "42958" }]) # 42958 is not broken by char
  end

  it 'creates a html table with header column' do
    generator.parse_file('table/html_figure.html',
                         { table: { header: { styles: ['bold'] } } })
    expect_pdf([
                 { x: 36.0, y: 744.756, text: "Header 1" },
                 { x: 306.0, y: 744.756, text: "Text 1" },
                 { x: 36.0, y: 730.476, text: "Header 2" },
                 { x: 306.0, y: 730.476, text: "Text 2" },
                 { x: 36.0, y: 716.196, text: "Header 3" },
                 { x: 306.0, y: 716.196, text: "Text 3" }])
  end

  it 'creates a table with html linefeed inside' do
    generator.parse_file('table/linefeed_in_cell.md')
    expect_pdf([
                 { x: 36.0, y: 744.756, text: "Description Column 1" },
                 { x: 36.0, y: 730.884, text: "Lorem ipsum dolor" },
                 { x: 36.0, y: 717.012, text: "sit amet" },
                 { x: 36.0, y: 703.14, text: "Consectetur" },
                 { x: 36.0, y: 689.268, text: "adipiscing elit" }])
  end

  it 'creates a html table with lists inside' do
    generator.parse_file('table/list_in_cell.html')
    expect_pdf([
                 { x: 36.0, y: 744.756, text: "• test1" },
                 { x: 36.0, y: 730.884, text: "• test2" },
                 { x: 36.0, y: 717.012, text: "  test2cont" },
                 { x: 36.0, y: 703.14, text: "• test3" },
                 { x: 36.0, y: 689.268, text: "  • test3.1" },
                 { x: 36.0, y: 675.396, text: "  • test3.2" },
                 { x: 36.0, y: 661.524, text: "    test3.2cont" },
                 { x: 36.0, y: 647.652, text: "  • test3.3" },
                 { x: 216.0, y: 744.756, text: "[ ] aha" },
                 { x: 216.0, y: 730.884, text: "[x] oho" },
                 { x: 216.0, y: 717.012, text: "[ ] ehe" },
                 { x: 396.0, y: 744.756, text: "1. wooo" },
                 { x: 396.0, y: 730.884, text: "2. waaa" },
                 { x: 396.0, y: 717.012, text: "3. wiiiii" }])
  end

  it 'creates a html table with lists with paragraphs inside' do
    generator.parse_file('table/lists_in_cell.html')
    expect_pdf([
                 { x: 36.0, y: 744.756, text: "He is making a list" },
                 { x: 36.0, y: 730.884, text: "1. checking it" },
                 { x: 36.0, y: 717.012, text: "2. twice" },
                 { x: 36.0, y: 703.14, text: "    1. gonna find out" },
                 { x: 36.0, y: 689.268, text: "    2. who's been naughty or" },
                 { x: 36.0, y: 675.396, text: "        1. nice" }])
  end

  it 'creates a html table with subtable in a header row' do
    generator.parse_file('table/subtable_in_header_row.html')
    expect_pdf([
                 { x: 221.0, y: 739.756, text: "Header 1" },
                 { x: 396.0, y: 744.756, text: "Header 2" },
                 { x: 36.0, y: 578.549, text: "Entry 1" },
                 { x: 36.0, y: 564.677, text: "Entry 2" }])
  end

  it 'creates a html table with paragraphs in a cell' do
    generator.parse_file('table/paragraphs_in_cell.md')
    expect_pdf([
                 { x: 36.0, y: 744.756, text: "1" },
                 { x: 36.0, y: 730.884, text: "2" },
                 { x: 36.0, y: 717.012, text: "3" }])
  end

  it 'creates a html table with empty lines in a cell' do
    generator.parse_file('table/linebreaks_in_cell.md')
    expect_pdf([
                 { x: 36.0, y: 747.384, text: "With paragraphs:" },
                 { x: 36.0, y: 730.884, text: "First" },
                 { x: 36.0, y: 689.268, text: "Fourth" },
                 { x: 306.0, y: 730.884, text: "First" },
                 { x: 306.0, y: 717.012, text: "Second" },
                 { x: 36.0, y: 664.152, text: "With breaks:" },
                 { x: 36.0, y: 647.652, text: "First" },
                 { x: 36.0, y: 606.036, text: "Fourth" },
                 { x: 306.0, y: 647.652, text: "First" },
                 { x: 306.0, y: 633.78, text: "Second" }])
  end

  it 'creates a html table with cell colors' do
    generator.parse_file('table/html_cellcolor.html', { table: { header: { background_color: "F0F0F0" } } })
    expect_pdf_color_rects([
                             ["99e64d", 36.0, 728.256, 135.0, 27.744],
                             ["f0f0f0", 171.0, 728.256, 135.0, 27.744],
                             ["f0f0f0", 306.0, 728.256, 135.0, 27.744],
                             ["f0f0f0", 441.0, 728.256, 135.0, 27.744],
                             ["99e64d", 36.0, 700.512, 135.0, 27.744],
                             ["4ce6e6", 171.0, 700.512, 135.0, 27.744],
                             ["1b8ed7", 306.0, 700.512, 135.0, 27.744],
                             ["e64da4", 441.0, 700.512, 135.0, 27.744],
                             ["4ce6e6", 171.0, 672.768, 135.0, 27.744],
                             ["1b8ed7", 306.0, 672.768, 135.0, 27.744],
                             ["e64da4", 441.0, 672.768, 135.0, 27.744]
                           ])
    expect_pdf([
                 { x: 36.0, y: 744.756, text: "Header with custom cell" },
                 { x: 36.0, y: 730.884, text: "color" },
                 { x: 36.0, y: 717.012, text: "With multiple colors, last" },
                 { x: 36.0, y: 703.14, text: "is selected" },
                 { x: 171.0, y: 717.012, text: "HSL color support" },
                 { x: 306.0, y: 717.012, text: "RGB color support" },
                 { x: 441.0, y: 717.012, text: "Partial RGBA support" },
                 { x: 36.0, y: 689.268, text: "Color empty cells to the" },
                 { x: 36.0, y: 675.396, text: "right" }])
  end

  it 'creates a html table without cell borders' do
    generator.parse_file('table/html_no_borders.html', { html_table: { cell: { no_border: true } } })
    expect_pdf_borders([])
    expect_pdf([
                 { x: 36.0, y: 744.756, text: "No" },
                 { x: 306.0, y: 744.756, text: "Borders!" }])
  end

  it 'creates a html table with styled cell borders' do
    generator.parse_file(
      'table/html_style_borders.html', {
        html_table: {
          header: {
            border_width: 0.25,
            border_color: "000000",
            background_color: "F0F0F0"
          },
          cell: {
            border_width: 0.25,
            border_color: "F000FF"
          }
        }
      }
    )
    expect_pdf_borders(
      [
        [0.25, 0.0, 36.0, 36.0],
        [[], 0.25, 0.0, 306.0, 306.0],
        [[], 0.25, 0.0, 36.0, 306.0],
        [[], 0.25, 0.0, 36.0, 306.0],
        [0.25, 0.0, 306.0, 306.0],
        [[], 0.25, 0.0, 576.0, 576.0],
        [[], 0.25, 0.0, 306.0, 576.0],
        [[], 0.25, 0.0, 306.0, 576.0],
        [0.25, 0.94118, 36.0, 36.0],
        [[], 0.25, 0.94118, 306.0, 306.0],
        [[], 0.25, 0.94118, 36.0, 306.0],
        [[], 0.25, 0.94118, 36.0, 306.0],
        [0.25, 0.94118, 306.0, 306.0],
        [[], 0.25, 0.94118, 576.0, 576.0],
        [[], 0.25, 0.94118, 306.0, 576.0],
        [[], 0.25, 0.94118, 306.0, 576.0]
      ]
    )
    expect_pdf([
                 { x: 36.0, y: 744.756, text: "Header" },
                 { x: 306.0, y: 744.756, text: "Borders!" },
                 { x: 36.0, y: 730.884, text: "Cell" },
                 { x: 306.0, y: 730.884, text: "Borders!" }])
  end

  it 'creates a html table with outer table borders' do
    generator.parse_file('table/html_outer_borders.html', { html_table: { cell: { no_border: true } } })
    expect_pdf_borders(
      [
        [1.5, 0.6, 36.0, 306.0],
        [[], 1.5, 0.6, 36.0, 306.0],
        [[], 1.5, 0.6, 36.0, 36.0],
        [1.5, 0.6, 306.0, 576.0],
        [[], 1.5, 0.6, 306.0, 576.0],
        [[], 1.5, 0.6, 576.0, 576.0]
      ]
    )
    expect_pdf([
                 { x: 36.0, y: 744.756, text: "Outer" },
                 { x: 306.0, y: 744.756, text: "Borders!" }])
  end

  it 'creates a html table with cell borders' do
    generator.parse_file('table/html_borders.html', { html_table: { cell: { no_border: true } } })
    expect_pdf_borders(
      [
        [1.5, 0.6, 36.0, 36.0],
        [[], [7.5, 15.0], 7.5, 0.0, 144.0, 144.0],
        [[], 1.5, 0.6, 36.0, 144.0],
        [[], [7.5, 15.0], 7.5, 0.0, 36.0, 144.0],
        [[], 1.5, 0.6, 36.0, 144.0],
        [[], 1.5, 0.6, 36.0, 36.0],
        [0.25, 0.0, 144.0, 144.0],
        [[], 0.25, 0.0, 252.0, 252.0],
        [[], 1.5, 0.6, 144.0, 252.0],
        [[], 0.25, 0.0, 144.0, 252.0],
        [[], 1.5, 0.6, 144.0, 252.0],
        [0.25, 0.0, 252.0, 252.0],
        [[], 0.25, 0.0, 360.0, 360.0],
        [[], 1.5, 0.6, 252.0, 360.0],
        [[], 0.25, 0.0, 252.0, 360.0],
        [[], 1.5, 0.6, 252.0, 360.0],
        [0.25, 0.0, 360.0, 360.0],
        [[], 0.25, 0.0, 468.0, 468.0],
        [[], 1.5, 0.6, 360.0, 468.0],
        [[], 0.25, 0.0, 360.0, 468.0],
        [[], 1.5, 0.6, 360.0, 468.0],
        [0.25, 0.0, 468.0, 468.0],
        [[], 1.5, 0.6, 576.0, 576.0],
        [[], 1.5, 0.6, 468.0, 576.0],
        [[], 0.25, 0.0, 468.0, 576.0],
        [[], 1.5, 0.6, 468.0, 576.0],
        [[], 1.5, 0.6, 576.0, 576.0],
        [1.5, 0.6, 36.0, 36.0],
        [[], 0.25, 0.0, 144.0, 144.0],
        [[], 0.25, 0.0, 36.0, 144.0],
        [[], 0.25, 0.0, 36.0, 144.0],
        [[], 1.5, 0.6, 36.0, 36.0],
        [1.5, 0.0, 144.0, 144.0],
        [[], 1.5, 0.0, 252.0, 252.0],
        [[], 1.5, 0.0, 144.0, 252.0],
        [[], 1.5, 0.0, 144.0, 252.0],
        [0.25, 0.0, 252.0, 252.0],
        [[], 0.25, 0.0, 360.0, 360.0],
        [[], 0.25, 0.0, 252.0, 360.0],
        [[], 0.25, 0.0, 252.0, 360.0],
        [0.25, 0.0, 360.0, 360.0],
        [[], 0.25, 0.0, 468.0, 468.0],
        [[], 0.25, 0.0, 360.0, 468.0],
        [[], 0.25, 0.0, 360.0, 468.0],
        [2.25, 0.0, 468.0, 468.0],
        [[], 1.5, 0.6, 576.0, 576.0],
        [[], 2.25, 0.0, 468.0, 576.0],
        [[], 2.25, 0.0, 468.0, 576.0],
        [[], 1.5, 0.6, 576.0, 576.0],
        [1.5, 0.6, 36.0, 36.0],
        [[], 0.25, 0.0, 144.0, 144.0],
        [[], 0.25, 0.0, 36.0, 144.0],
        [[], 0.25, 0.0, 36.0, 144.0],
        [[], 1.5, 0.6, 36.0, 36.0],
        [0.25, 0.0, 144.0, 144.0],
        [[], 0.25, 0.0, 252.0, 252.0],
        [[], 0.25, 0.0, 144.0, 252.0],
        [[], 0.25, 0.0, 144.0, 252.0],
        [[6.0, 6.0], 1.5, 0.90196, 252.0, 252.0],
        [[], [6.0, 6.0], 1.5, 0.90196, 360.0, 360.0],
        [[], [6.0, 6.0], 1.5, 0.90196, 252.0, 360.0],
        [[], [6.0, 6.0], 1.5, 0.90196, 252.0, 360.0],
        [0.25, 1.0, 360.0, 360.0],
        [[], 0.25, 1.0, 468.0, 468.0],
        [[], 0.25, 1.0, 360.0, 468.0],
        [[], 0.25, 1.0, 360.0, 468.0],
        [3.0, 0.0, 468.0, 468.0],
        [[], 1.5, 0.6, 576.0, 576.0],
        [[], 3.0, 0.0, 468.0, 576.0],
        [[], 3.0, 0.0, 468.0, 576.0],
        [[], 1.5, 0.6, 576.0, 576.0],
        [1.5, 0.6, 36.0, 144.0],
        [[], 1.5, 0.6, 36.0, 36.0],
        [1.5, 0.6, 144.0, 252.0],
        [1.5, 0.6, 252.0, 360.0],
        [1.5, 0.6, 360.0, 468.0],
        [1.5, 0.6, 468.0, 576.0],
        [[], 1.5, 0.6, 576.0, 576.0]
      ]
    )
    expect_pdf([
                 { x: 36.0, y: 744.756, text: "dotted" },
                 { x: 144.0, y: 744.756, text: "column1" },
                 { x: 252.0, y: 744.756, text: "column2" },
                 { x: 360.0, y: 744.756, text: "column3" },
                 { x: 468.0, y: 744.756, text: "column4" },
                 { x: 36.0, y: 730.884, text: "line1" },
                 { x: 144.0, y: 730.884, text: "width: 2px" },
                 { x: 252.0, y: 730.884, text: "default" },
                 { x: 360.0, y: 730.884, text: "default" },
                 { x: 468.0, y: 730.884, text: "blue" },
                 { x: 36.0, y: 717.012, text: "line3" },
                 { x: 144.0, y: 717.012, text: "default" },
                 { x: 252.0, y: 717.012, text: "dashed" },
                 { x: 360.0, y: 717.012, text: "red" },
                 { x: 468.0, y: 717.012, text: "width: 4px" },
                 { x: 36.0, y: 703.14, text: "line4" },
                 { x: 144.0, y: 703.14, text: "none" },
                 { x: 252.0, y: 703.14, text: "none" },
                 { x: 360.0, y: 703.14, text: "none" },
                 { x: 468.0, y: 703.14, text: "none" }])
  end

  it 'html table with a html link in a cell' do
    generator.parse_file('table/html_link.html')
    expect_pdf([
                 { x: 36.0, y: 744.756, text: "Test" },
                 { x: 306.0, y: 744.756, text: "https://example.com" }
               ])
  end

  it 'html table with sane auto width columns' do
    generator.parse_file('table/columns.html', { html_table: { auto_width: true } })
    expect_pdf(
      [{ x: 36.0, y: 747.384, text: "" },
       { x: 36.0, y: 730.884, text: "Person" },
       { x: 187.368, y: 730.884, text: "Role" },
       { x: 344.748, y: 730.884, text: "Organisation" },
       { x: 36.0, y: 717.012, text: "Bumbleworth Fizzlebottom" },
       { x: 187.368, y: 717.012, text: "Grand Wizard" },
       { x: 344.748, y: 717.012, text: "Council of Sparkleshire" },
       { x: 36.0, y: 703.14, text: "Dr. Pickle Pumpernickel" },
       { x: 187.368, y: 703.14, text: "Whimsy Master" },
       { x: 344.748, y: 703.14, text: "Academy of Giggleton" },
       { x: 36.0, y: 689.268, text: "Wobble Butterscotch" },
       { x: 187.368, y: 689.268, text: "Assistant to Dr. Pumpernickel" },
       { x: 344.748, y: 689.268, text: "Giggleton" },
       { x: 36.0, y: 675.396, text: "Twinkletoes Muffintop" },
       { x: 187.368, y: 675.396, text: "Assistant to Fizzlebottom" },
       { x: 344.748, y: 675.396, text: "Sparkleshire" },
       { x: 36.0, y: 661.524, text: "Crumple Snickerdoodle" },
       { x: 187.368, y: 661.524, text: "Assistant to Fizzlebottom" },
       { x: 344.748, y: 661.524, text: "Sparkleshire" },
       { x: 36.0, y: 647.652, text: "Dr. Waffle Wimbleton" },
       { x: 187.368, y: 647.652, text: "Member" },
       { x: 344.748, y: 647.652, text: "Doodleshire" },
       { x: 36.0, y: 633.78, text: "Dr. Pudding Poppyseed" },
       { x: 187.368, y: 633.78, text: "Member" },
       { x: 344.748, y: 633.78, text: "Noodleton" },
       { x: 36.0, y: 619.908, text: "Dr. Dibble Dribbleworth" },
       { x: 187.368, y: 619.908, text: "Member" },
       { x: 344.748, y: 619.908, text: "Tiddlywinks" },
       { x: 36.0, y: 606.036, text: "Bubble Bobbington" },
       { x: 187.368, y: 606.036, text: "Member" },
       { x: 344.748, y: 606.036, text: "Whiff" },
       { x: 36.0, y: 592.164, text: "Wiffle Womp" },
       { x: 187.368, y: 592.164, text: "Guest (Standby)" },
       { x: 344.748, y: 592.164, text: "Whiff" },
       { x: 36.0, y: 578.292, text: "Crinkle Snazzleberry" },
       { x: 187.368, y: 578.292, text: "Member" },
       { x: 344.748, y: 578.292, text: "Whimsical District" },
       { x: 36.0, y: 564.42, text: "Zigzag Zookeeper" },
       { x: 187.368, y: 564.42, text: "Member" },
       { x: 344.748, y: 564.42, text: "Gigglebox Ltd." },
       { x: 36.0, y: 550.548, text: "Doodle Dandyworth" },
       { x: 187.368, y: 550.548, text: "Guest (Standby)" },
       { x: 344.748, y: 550.548, text: "Gigglebox Ltd." },
       { x: 36.0, y: 536.676, text: "Fidget Fandango" },
       { x: 187.368, y: 536.676, text: "Guest" },
       { x: 344.748, y: 536.676, text: "Gigglebox Ltd." },
       { x: 36.0, y: 522.804, text: "Quibble Quirkworth" },
       { x: 187.368, y: 522.804, text: "Member" },
       { x: 344.748, y: 522.804, text: "Chucklenet Inc." },
       { x: 36.0, y: 508.932, text: "Squiggle McWiggle" },
       { x: 187.368, y: 508.932, text: "Member" },
       { x: 344.748, y: 508.932, text: "Fun Co." },
       { x: 36.0, y: 495.06, text: "Pickle Prankster" },
       { x: 187.368, y: 495.06, text: "Member" },
       { x: 344.748, y: 495.06, text: "JOSIT" },
       { x: 36.0, y: 481.188, text: "Prof. Dr. Wobble Wackworth" },
       { x: 187.368, y: 481.188, text: "Member" },
       { x: 344.748, y: 481.188, text: "Sillyton School of Whimsy (SSW)" },
       { x: 36.0, y: 467.316, text: "Topsy Teacup" },
       { x: 187.368, y: 467.316, text: "Member" },
       { x: 344.748, y: 467.316, text: "National Fun-Government" },
       { x: 344.748, y: 453.444, text: "Consortium (NFGC) Ltd." },
       { x: 36.0, y: 439.572, text: "Jingle Jamboree" },
       { x: 187.368, y: 439.572, text: "Member" },
       { x: 344.748, y: 439.572, text: "WIBBLE" },
       { x: 36.0, y: 425.7, text: "Tumble Teakettle" },
       { x: 187.368, y: 425.7, text: "Chief Mischief Maker" },
       { x: 344.748, y: 425.7, text: "WIBBLE" },
       { x: 36.0, y: 411.828, text: "Giggle Gumdrop" },
       { x: 187.368, y: 411.828, text: "Guest" },
       { x: 344.748, y: 411.828, text: "WIBBLE (Silliness)" },
       { x: 36.0, y: 397.956, text: "Bubble Bobkins" },
       { x: 187.368, y: 397.956, text: "Guest" },
       { x: 344.748, y: 397.956, text: "BVA (Silliness)" },
       { x: 36.0, y: 384.084, text: "Twinkle Teaspoon" },
       { x: 187.368, y: 384.084, text: "Guest (sometimes)" },
       { x: 344.748, y: 384.084, text: "FMI" },
       { x: 36.0, y: 370.212, text: "Wobble Whimsy" },
       { x: 187.368, y: 370.212, text: "Guest (sometimes)" },
       { x: 344.748, y: 370.212, text: "FMI" },
       { x: 36.0, y: 356.34, text: "Dribble Dreamworth" },
       { x: 187.368, y: 356.34, text: "Guest (sometimes)" },
       { x: 344.748, y: 356.34, text: "FMI" }]
    )
  end

  it 'html table settings are applied' do
    generator.parse_file('table/table.html', {
                           table: { header: { size: 10 }, cell: { size: 10 } },
                           html_table: { header: { size: 20 }, cell: { size: 20 } }
                         })
    expect_pdf(
      [
        { x: 36.0, y: 747.384, text: "" },
        { x: 36.0, y: 725.14, text: "Person" },
        { x: 216.0, y: 725.14, text: "Role" },
        { x: 396.0, y: 725.14, text: "Organisation" },
        { x: 36.0, y: 702.02, text: "Bumbleworth" },
        { x: 36.0, y: 678.9, text: "Fizzlebottom" },
        { x: 216.0, y: 702.02, text: "Grand Wizard" },
        { x: 396.0, y: 702.02, text: "Council of" },
        { x: 396.0, y: 678.9, text: "Sparkleshire" }
      ]
    )
  end
end
