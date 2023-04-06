require 'pdf_helpers'

describe MarkdownToPDF::Code do
  include_context 'pdf_helpers'

  it 'creates inlined code' do
    generator.parse_file('code/inline.md')
    expect(text.strings).to eq(["Inline ", "code fragment"])
  end

  it 'creates code block by indenting' do
    generator.parse_file('code/indented.md')
    expect(text.strings).to eq(["// Some comments", "line 1 of code", "line 2 of code", "line 3 of code"])
  end

  it 'creates code block by fences' do
    generator.parse_file('code/fences.md')
    expect(text.strings).to eq(["Sample text here..."])
  end

  it 'creates code block by fences with language tag' do
    generator.parse_file('code/fences_js.md')
    expect(text.strings).to eq(["var foo = function (bar) {", "  return bar++;", "};"])
  end

end
