require 'pdf_helpers'

describe MarkdownToPDF::Code do
  include_context 'with pdf'

  it 'creates inlined code' do
    generator.parse_file('code/inline.md')
    expect_pdf([
                 { x: 36.0, y: 747.384, text: "Inline " },
                 { x: 68.016, y: 747.384, text: "code fragment" }])
  end

  it 'creates code block by indenting' do
    generator.parse_file('code/indented.md')
    expect_pdf([
                 { x: 36.0, y: 744.756, text: "// Some comments" },
                 { x: 36.0, y: 728.884, text: "line 1 of code" },
                 { x: 36.0, y: 713.012, text: "line 2 of code" },
                 { x: 36.0, y: 697.14, text: "line 3 of code" }])
  end

  it 'creates code block by fences without language tag' do
    generator.parse_file('code/fences.md')
    expect_pdf([{ x: 36.0, y: 744.756, text: "Sample text here..." }])
  end

  it 'creates code block by fences with language tag' do
    generator.parse_file('code/fences_js.md')
    expect_pdf([
                 { x: 36.0, y: 744.756, text: "var foo = function (bar) {" },
                 { x: 36.0, y: 728.884, text: "  return bar++;" },
                 { x: 36.0, y: 713.012, text: "};" }])
  end

  it 'creates ignores empty code block by fences' do
    generator.parse_file('code/fences_empty.md')
    expect_pdf([])
  end
end
