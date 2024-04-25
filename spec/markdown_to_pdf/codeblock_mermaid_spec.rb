require 'pdf_helpers'

describe MarkdownToPDF::Codeblock do
  include_context 'with pdf'

  it 'keeps using the code block if mermaid cli is not available' do
    allow_any_instance_of(described_class)
      .to receive(:mermaid_cli_available?)
            .and_return(false)
    generator.parse_file('mermaid/mermaid.md')
    expect_images_in_pdf(0)
    expect_pdf([
                 { x: 36.0, y: 744.756, text: "gantt" },
                 { x: 36.0, y: 728.884, text: "    title A Gantt Diagram" },
                 { x: 36.0, y: 713.012, text: "    dateFormat YYYY-MM-DD" },
                 { x: 36.0, y: 697.14, text: "    section Section" },
                 { x: 36.0, y: 681.268, text: "        A task          :a1, 2014-01-01, 30d" },
                 { x: 36.0, y: 665.396, text: "        Another task    :after a1, 20d" },
                 { x: 36.0, y: 649.524, text: "    section Another" },
                 { x: 36.0, y: 633.652, text: "        Task in Another :2014-01-12, 12d" },
                 { x: 36.0, y: 617.78, text: "        another task    :24d" },
                 { x: 36.0, y: 603.908, text: "quadrantChart" },
                 { x: 36.0, y: 588.036, text: "    title Reach and engagement of campaigns" },
                 { x: 36.0, y: 572.164, text: "    x-axis Low Reach --> High Reach" },
                 { x: 36.0, y: 556.292, text: "    y-axis Low Engagement --> High Engagement" },
                 { x: 36.0, y: 540.42, text: "    quadrant-1 We should expand" },
                 { x: 36.0, y: 524.548, text: "    quadrant-2 Need to promote" },
                 { x: 36.0, y: 508.676, text: "    quadrant-3 Re-evaluate" },
                 { x: 36.0, y: 492.804, text: "    quadrant-4 May be improved" },
                 { x: 36.0, y: 476.932, text: "    Campaign A: [0.3, 0.6]" },
                 { x: 36.0, y: 461.06, text: "    Campaign B: [0.45, 0.23]" },
                 { x: 36.0, y: 445.188, text: "    Campaign C: [0.57, 0.69]" },
                 { x: 36.0, y: 429.316, text: "    Campaign D: [0.78, 0.34]" },
                 { x: 36.0, y: 413.444, text: "    Campaign E: [0.40, 0.34]" },
                 { x: 36.0, y: 397.572, text: "    Campaign F: [0.35, 0.78]" }])
  end

  it 'replaces mermaid diagram code block with images' do
    allow_any_instance_of(described_class)
      .to receive(:mermaid_cli_available?)
            .and_return(true)
    allow_any_instance_of(described_class)
      .to receive(:run_mermaid_cli) do |_caller, _mmdc, destination, _format, _options|
      png = Base64.decode64("iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAACklEQVR4nGMAAQAABQABDQottAAAAABJRU5ErkJggg==")
      File.write(destination, png)
      true
    end
    generator.parse_file('mermaid/mermaid.md')
    expect_images_in_pdf(2)
    expect_pdf([])
  end
end
