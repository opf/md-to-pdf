require 'pdf_helpers'

describe MarkdownToPDF::List do
  include_context 'with pdf'

  it 'creates an unordered list' do
    generator.parse_file('list/unordered.md')
    expect_pdf([
                 { x: 36.0, y: 747.384, text: "•" },
                 { x: 43.536, y: 747.384, text: "first" },
                 { x: 36.0, y: 733.512, text: "•" },
                 { x: 43.536, y: 733.512, text: "second" },
                 { x: 43.536, y: 719.64, text: "•" },
                 { x: 51.072, y: 719.64, text: "third" }])
  end

  it 'creates an ordered list' do
    generator.parse_file('list/ordered.md')
    expect_pdf([
                 { x: 36.0, y: 747.384, text: "1." },
                 { x: 49.344, y: 747.384, text: "one" },
                 { x: 36.0, y: 733.512, text: "2." },
                 { x: 49.344, y: 733.512, text: "two" },
                 { x: 36.0, y: 719.64, text: "3." },
                 { x: 49.344, y: 719.64, text: "three" },
                 { x: 36.0, y: 705.768, text: "4." },
                 { x: 49.344, y: 705.768, text: "four" },
                 { x: 36.0, y: 691.896, text: "5." },
                 { x: 49.344, y: 691.896, text: "five" },
                 { x: 36.0, y: 678.024, text: "6." },
                 { x: 49.344, y: 678.024, text: "six" },
                 { x: 36.0, y: 664.152, text: "7." },
                 { x: 49.344, y: 664.152, text: "seven" },
                 { x: 36.0, y: 650.28, text: "8." },
                 { x: 49.344, y: 650.28, text: "eight" },
                 { x: 36.0, y: 636.408, text: "9." },
                 { x: 49.344, y: 636.408, text: "nine" },
                 { x: 36.0, y: 622.536, text: "10." },
                 { x: 56.016, y: 622.536, text: "ten" }])
  end

  it 'creates an ordered list with correct numbers' do
    generator.parse_file('list/ordered_mixed.md', { ordered_list_point: { spanning: true } })
    expect_pdf([
                 { x: 36.0, y: 747.384, text: "1." },
                 { x: 56.016, y: 747.384, text: "one" },
                 { x: 36.0, y: 733.512, text: "2." },
                 { x: 56.016, y: 733.512, text: "two" },
                 { x: 36.0, y: 719.64, text: "3." },
                 { x: 56.016, y: 719.64, text: "three" },
                 { x: 36.0, y: 705.768, text: "4." },
                 { x: 56.016, y: 705.768, text: "four" },
                 { x: 36.0, y: 691.896, text: "5." },
                 { x: 56.016, y: 691.896, text: "five" },
                 { x: 36.0, y: 678.024, text: "6." },
                 { x: 56.016, y: 678.024, text: "six" },
                 { x: 36.0, y: 664.152, text: "7." },
                 { x: 56.016, y: 664.152, text: "seven" },
                 { x: 36.0, y: 650.28, text: "8." },
                 { x: 56.016, y: 650.28, text: "eight" },
                 { x: 36.0, y: 636.408, text: "9." },
                 { x: 56.016, y: 636.408, text: "nine" },
                 { x: 36.0, y: 622.536, text: "10." },
                 { x: 56.016, y: 622.536, text: "ten" }])
  end

  it 'creates an ordered list starting with specified number' do
    generator.parse_file('list/ordered_starting.md')
    expect_pdf([
                 { x: 36.0, y: 747.384, text: "11." },
                 { x: 56.016, y: 747.384, text: "eleven" },
                 { x: 36.0, y: 733.512, text: "12." },
                 { x: 56.016, y: 733.512, text: "twelve" },
                 { x: 36.0, y: 719.64, text: "13." },
                 { x: 56.016, y: 719.64, text: "thirteen" },
                 { x: 36.0, y: 705.768, text: "14." },
                 { x: 56.016, y: 705.768, text: "fourteen" }])
  end

  it 'creates a ordered list with custom bullets' do
    styling = {
      ordered_list_point_3: { template: '<number>)', alphabetical: true },
      ordered_list_point_4: { template: '(<number>)' }
    }
    generator.parse_file('list/ordered_custom.md', styling)
    expect_pdf([
                 { x: 36.0, y: 747.384, text: "1." },
                 { x: 49.344, y: 747.384, text: "Level 1" },
                 { x: 49.344, y: 733.512, text: "1." },
                 { x: 62.688, y: 733.512, text: "Level 2" },
                 { x: 49.344, y: 719.64, text: "2." },
                 { x: 62.688, y: 719.64, text: "Level 2" },
                 { x: 62.688, y: 705.768, text: "a)" },
                 { x: 76.692, y: 705.768, text: "Level 3 uses alphabetical points" },
                 { x: 62.688, y: 691.896, text: "b)" },
                 { x: 76.692, y: 691.896, text: "Level 3" },
                 { x: 62.688, y: 678.024, text: "c)" },
                 { x: 76.02, y: 678.024, text: "Level 3" },
                 { x: 76.02, y: 664.152, text: "(1)" },
                 { x: 94.02, y: 664.152, text: "Level 4 uses a brackets template" },
                 { x: 76.02, y: 650.28, text: "(2)" },
                 { x: 94.02, y: 650.28, text: "Level 4" },
                 { x: 76.02, y: 636.408, text: "(3)" },
                 { x: 94.02, y: 636.408, text: "Level 4" }])
  end

  it 'creates a tasklist' do
    generator.parse_file('list/tasklist.md', { task_list_point: { spanning: true } })
    expect_pdf([
                 { x: 36.0, y: 747.384, text: "[ ]" },
                 { x: 52.008, y: 747.384, text: "unchecked" },
                 { x: 36.0, y: 733.512, text: "[x]" },
                 { x: 52.008, y: 733.512, text: "checked" },
                 { x: 36.0, y: 719.64, text: "[ ]" },
                 { x: 52.008, y: 719.64, text: "unchecked" },
                 { x: 36.0, y: 705.768, text: "[ ]" },
                 { x: 52.008, y: 705.768, text: "unchecked" }])
  end

  it 'creates lists by html' do
    generator.parse_file('list/html.md')
    expect_pdf([
                 { x: 36.0, y: 747.384, text: "•" },
                 { x: 43.536, y: 747.384, text: "one" },
                 { x: 36.0, y: 733.512, text: "•" },
                 { x: 43.536, y: 733.512, text: "two" },
                 { x: 36.0, y: 719.64, text: "•" },
                 { x: 43.536, y: 719.64, text: "three" },
                 { x: 36.0, y: 705.768, text: "1." },
                 { x: 49.344, y: 705.768, text: "one" },
                 { x: 36.0, y: 691.896, text: "2." },
                 { x: 49.344, y: 691.896, text: "two" },
                 { x: 36.0, y: 678.024, text: "3." },
                 { x: 49.344, y: 678.024, text: "three" },
                 { x: 36.0, y: 664.152, text: "1." },
                 { x: 49.344, y: 664.152, text: "one" },
                 { x: 36.0, y: 650.28, text: "2." },
                 { x: 49.344, y: 650.28, text: "two" },
                 { x: 36.0, y: 636.408, text: "3." },
                 { x: 49.344, y: 636.408, text: "three" },
                 { x: 49.344, y: 622.536, text: "1." },
                 { x: 62.688, y: 622.536, text: "one" },
                 { x: 49.344, y: 608.664, text: "2." },
                 { x: 62.688, y: 608.664, text: "two" },
                 { x: 49.344, y: 594.792, text: "3." },
                 { x: 62.688, y: 594.792, text: "three" },
                 { x: 62.688, y: 580.92, text: "1." },
                 { x: 76.032, y: 580.92, text: "one" },
                 { x: 62.688, y: 567.048, text: "2." },
                 { x: 76.032, y: 567.048, text: "two" },
                 { x: 62.688, y: 553.176, text: "3." },
                 { x: 76.032, y: 553.176, text: "three" }])
  end

  it 'creates an ordered list with correct numbers inline' do
    generator.parse_file('list/inline.md', { ordered_list: { point_inline: true } })
    expect_pdf([
                 { x: 36.0, y: 747.384, text: "1. " },
                 { x: 50.10429, y: 747.384, text: "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt" },
                 { x: 36.0, y: 733.512, text: "ut labore et dolore magna aliquyam erat, sed diam voluptua." },
                 { x: 36.0, y: 719.64, text: "2. " },
                 { x: 51.81067, y: 719.64, text: "At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea" },
                 { x: 36.0, y: 705.768, text: "takimata sanctus est Lorem ipsum dolor sit amet." },
                 { x: 36.0, y: 691.896, text: "3. " },
                 { x: 50.10429, y: 691.896, text: "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt" },
                 { x: 36.0, y: 678.024, text: "ut labore et dolore magna aliquyam erat, sed diam voluptua." },
                 { x: 36.0, y: 664.152, text: "4. " },
                 { x: 51.81067, y: 664.152, text: "At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea" },
                 { x: 36.0, y: 650.28, text: "takimata sanctus est Lorem ipsum dolor sit amet." }])
  end
end
