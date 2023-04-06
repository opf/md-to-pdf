require 'pdf_helpers'

describe MarkdownToPDF::List do
  include_context 'pdf_helpers'

  it 'creates an unordered list' do
    generator.parse_file('list/unordered.md')
    expect(text.strings).to eq(['•', 'first', '•', 'second', '•', 'third'])
  end

  it 'creates an ordered list' do
    generator.parse_file('list/ordered.md')
    expect(text.strings).to eq(["1.", "one", "2.", "two", "3.", "three", "4.", "four", "5.", "five",
                                "6.", "six", "7.", "seven", "8.", "eight", "9.", "nine", "10.", "ten"])
  end

  it 'creates an ordered list with correct numbers' do
    generator.parse_file('list/ordered_mixed.md')
    expect(text.strings).to eq(["1.", "one", "2.", "two", "3.", "three", "4.", "four", "5.", "five",
                                "6.", "six", "7.", "seven", "8.", "eight", "9.", "nine", "10.", "ten"])
  end

  it 'creates an ordered list starting with specified number' do
    generator.parse_file('list/ordered_starting.md')
    expect(text.strings).to eq(["11.", "eleven", "12.", "twelve", "13.", "thirteen", "14.", "fourteen"])
  end

  it 'creates a ordered list with custom bullets' do
    styling = {
      ordered_list_point_3: { template: '<number>)', alphabetical: true },
      ordered_list_point_4: { template: '(<number>)' }
    }
    generator.parse_file('list/ordered_custom.md', styling)
    expect(text.strings).to eq([
                                 "1.", "Level 1",
                                 "1.", "Level 2",
                                 "2.", "Level 2",
                                 "a)", "Level 3 uses alphabetical points",
                                 "b)", "Level 3",
                                 "c)", "Level 3",
                                 "(1)", "Level 4 uses a brackets template",
                                 "(2)", "Level 4",
                                 "(3)", "Level 4"
                               ]
                            )
  end

  it 'creates a tasklist' do
    generator.parse_file('list/tasklist.md')
    expect(text.strings).to eq(["[ ]", "unchecked", "[x]", "checked", "[ ]", "unchecked", "[ ]", "unchecked"])
  end

end
