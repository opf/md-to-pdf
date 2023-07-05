require 'pdf_helpers'

describe MarkdownToPDF::Paragraph do
  include_context 'with pdf'

  it 'creates two paragraphs' do
    generator.parse_file('paragraph/paragraph.md')
    expect_pdf([
                 { x: 36.0, y: 747.384, text: "A markdown paragraph" },
                 { x: 160.356, y: 747.384, text: " " },
                 { x: 163.692, y: 747.384, text: "is marked with two line" },
                 { x: 284.208, y: 747.384, text: " " },
                 { x: 287.544, y: 747.384, text: "feeds" },
                 { x: 36.0, y: 733.512, text: "This is the second paragraph" }])
  end

  it 'creates a paragraph by html' do
    generator.parse_file('paragraph/html.md')
    expect_pdf([
                 { x: 36.0, y: 747.384, text: "A html paragraph" },
                 { x: 36.0, y: 733.512, text: "A second paragraph" }])
  end

  it 'creates a justified paragraph' do
    generator.parse_file('paragraph/paragraph_justify.md', { paragraph: { align: :justify } })
    expect_pdf([
                 { x: 36.0, y: 747.384, text: "This is the first paragraph, justified. (If there is only one line, it is just left aligned)" },
                 { x: 36.0, y: 733.512, text: "Zombie ipsum reversus ab viral inferno, nam rick grimes malum cerebro. De carne lumbering animata" },
                 { x: 36.0, y: 719.64, text: "corpora quaeritis. Summus brains sit, morbo vel maleficia? De apocalypsi gorger omero undead" },
                 { x: 36.0, y: 705.768, text: "survivor dictum mauris." }])
  end

  it 'creates a centered paragraph' do
    generator.parse_file('paragraph/paragraph_center.md', { paragraph: { align: :center } })
    expect_pdf([
                 { x: 210.138, y: 747.384, text: "This is the first paragraph, centered." },
                 { x: 37.254, y: 733.512, text: "Zombie ipsum reversus ab viral inferno, nam rick grimes malum cerebro. De carne lumbering animata" },
                 { x: 51.726, y: 719.64, text: "corpora quaeritis. Summus brains sit, morbo vel maleficia? De apocalypsi gorger omero undead" },
                 { x: 244.296, y: 705.768, text: "survivor dictum mauris." }])
  end
end
