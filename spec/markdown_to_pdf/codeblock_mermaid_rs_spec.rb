require 'pdf_helpers'

PNG_1X1 = "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAACklEQVR4nGMAAQAABQABDQottAAAAABJRU5ErkJggg==".freeze
SVG_HEADER = '<svg xmlns="http://www.w3.org/2000/svg" width="100" height="50" viewBox="0 0 100 50"></svg>'.freeze

describe MarkdownToPDF::Codeblock do
  include_context 'with pdf'

  let(:flowchart) { "```mermaid\ngraph TD\n  A[Start] --> B[Ende]\n```" }

  before do
    allow_any_instance_of(described_class).to receive(:mermaid_cli_available?).and_return(false)
    allow_any_instance_of(described_class).to receive(:mermaid_rs_cli_available?).and_return(true)
  end

  # Code block cells render spaces as non breaking spaces.
  def texts
    page.map { |entry| entry[:text].gsub(Prawn::Text::NBSP, ' ') }
  end

  def renders_png
    allow_any_instance_of(described_class).to receive(:run_mermaid_rs_cli) do |_caller, _source, destination|
      File.write(destination, Base64.decode64(PNG_1X1))
      true
    end
  end

  def succeeds(stdout = SVG_HEADER)
    allow(Open3).to receive(:capture3).and_return([stdout, '', instance_double(Process::Status, success?: true)])
  end

  describe 'with the rust renderer' do
    before do
      renders_png
      generator.parse_file('mermaid/mermaid.md')
    end

    it 'replaces the diagram code blocks with images' do
      expect(images).to eq([{ x: 36.0, y: 755.0, width: 1.0, height: 1.0 },
                            { x: 36.0, y: 754.0, width: 1.0, height: 1.0 }])
    end

    it 'does not draw the source of the diagram' do
      expect(texts).to be_empty
    end
  end

  describe 'calling the renderer' do
    before { succeeds }

    it 'asks for a png at the given destination' do
      generator.parse(flowchart)
      expect(Open3).to have_received(:capture3)
        .with('mmdr', '-i', anything, '-e', 'png', '-o', anything, '-c', anything, '-w', '200', '-H', '100')
    end

    it 'measures the diagram from the svg before rendering it' do
      generator.parse(flowchart)
      expect(Open3).to have_received(:capture3).with('mmdr', '-i', anything, '-c', anything)
    end

    # homebrew ships 0.2.2, where --theme and --size do not exist yet
    it 'uses no flag that mmdr gained after 0.2' do
      calls = []
      allow(Open3).to receive(:capture3) do |*args|
        calls << args
        [SVG_HEADER, '', instance_double(Process::Status, success?: true)]
      end
      generator.parse(flowchart)
      expect(calls.flatten).not_to include('-t', '--theme', '--size')
    end

    it 'writes the diagram source to the input file' do
      sources = []
      allow(Open3).to receive(:capture3) do |*args|
        sources << File.read(args[2]) if args[1] == '-i'
        [SVG_HEADER, '', instance_double(Process::Status, success?: true)]
      end
      generator.parse(flowchart)
      expect(sources.first).to eq("graph TD\n  A[Start] --> B[Ende]\n")
    end

    it 'asks for a transparent background' do
      configs = []
      allow(Open3).to receive(:capture3) do |*args|
        index = args.index('-c')
        configs << File.read(args[index + 1]) if index
        [SVG_HEADER, '', instance_double(Process::Status, success?: true)]
      end
      generator.parse(flowchart)
      expect(configs.first).to include('"background":"transparent"')
    end

    it 'asks for the neutral theme through the config file' do
      configs = []
      allow(Open3).to receive(:capture3) do |*args|
        index = args.index('-c')
        configs << File.read(args[index + 1]) if index
        [SVG_HEADER, '', instance_double(Process::Status, success?: true)]
      end
      generator.parse(flowchart)
      expect(configs.first).to include('"theme":"neutral"')
    end

    it 'renders at the natural size when the svg carries no size' do
      succeeds('<svg xmlns="http://www.w3.org/2000/svg"></svg>')
      generator.parse(flowchart)
      expect(Open3).to have_received(:capture3).with('mmdr', '-i', anything, '-e', 'png', '-o', anything, '-c', anything)
    end

    it 'renders at the natural size when measuring fails' do
      allow(Open3).to receive(:capture3) do |*args|
        failed = instance_double(Process::Status, success?: false)
        ok = instance_double(Process::Status, success?: true)
        args.include?('-e') ? ['', '', ok] : ['', 'boom', failed]
      end
      generator.parse(flowchart)
      expect(Open3).to have_received(:capture3).with('mmdr', '-i', anything, '-e', 'png', '-o', anything, '-c', anything)
    end
  end

  describe 'falling back to the code block' do
    it 'keeps the source when the renderer exits with a failure' do
      allow(Open3).to receive(:capture3).and_return(['', 'error', instance_double(Process::Status, success?: false)])
      generator.parse(flowchart)
      expect(texts).to include('graph TD')
    end

    it 'keeps the source when the renderer cannot be run' do
      allow(Open3).to receive(:capture3).and_raise(Errno::ENOENT)
      generator.parse(flowchart)
      expect(texts).to include('graph TD')
    end

    it 'does not leak the renderer messages into the document' do
      allow(Open3).to receive(:capture3).and_return(['', 'unknown diagram header', instance_double(Process::Status, success?: false)])
      generator.parse(flowchart)
      expect(texts).not_to include('unknown diagram header')
    end

    it 'keeps the source when the renderer is disabled' do
      allow(generator).to receive(:mermaid_rs_cli_enabled?).and_return(false)
      generator.parse(flowchart)
      expect(texts).to include('graph TD')
    end

    it 'keeps the source when the renderer is not installed' do
      allow_any_instance_of(described_class).to receive(:mermaid_rs_cli_available?).and_return(false)
      generator.parse(flowchart)
      expect(texts).to include('graph TD')
    end

    it 'keeps the source above the size limit' do
      succeeds
      generator.parse("```mermaid\ngraph TD\n#{"  A[x] --> B[y]\n" * 10_000}```")
      expect(texts).to include('graph TD')
    end

    it 'does not call the renderer above the size limit' do
      allow(Open3).to receive(:capture3)
      generator.parse("```mermaid\ngraph TD\n#{"  A[x] --> B[y]\n" * 10_000}```")
      expect(Open3).not_to have_received(:capture3)
    end
  end

  describe 'renderer switches' do
    it 'enables the mermaid cli by default' do
      expect(generator.mermaid_cli_enabled?).to be(true)
    end

    it 'enables the rust renderer by default' do
      expect(generator.mermaid_rs_cli_enabled?).to be(true)
    end

    it 'falls through to the rust renderer when the mermaid cli is switched off' do
      allow(generator).to receive_messages(mermaid_cli_enabled?: false, mermaid_cli_available?: true,
                                           mermaid_rs_cli_available?: true)
      allow(generator).to receive(:run_mermaid_rs_cli) do |_source, destination|
        File.write(destination, Base64.decode64(PNG_1X1))
        true
      end
      generator.parse(flowchart)
      expect(images.length).to eq(1)
    end

    it 'keeps the source when both renderers are switched off' do
      allow(generator).to receive_messages(mermaid_cli_enabled?: false, mermaid_rs_cli_enabled?: false)
      generator.parse(flowchart)
      expect(texts).to include('graph TD')
    end
  end

  describe 'without the External module' do
    # What the respond_to? guards are for: none of the four hooks exist here.
    let(:bare) do
      Class.new do
        include MarkdownToPDF::Core
        include MarkdownToPDF::Parser

        undef_method :mermaid_cli_available?, :mermaid_rs_cli_available?

        def initialize
          @pdf = Prawn::Document.new({})
          @styles = MarkdownToPDF::Styles.new({})
          init_options({})
          pdf_init_md2pdf_fonts(@pdf)
        end

        def render(markdown)
          draw_node(parse_markdown(markdown), {}, true)
          @pdf.render
        end
      end.new
    end

    it 'renders the diagram source instead of raising' do
      text = PDF::Inspector::Text.analyze(bare.render(flowchart)).strings.map { |t| t.gsub(Prawn::Text::NBSP, ' ') }
      expect(text).to include('graph TD')
    end
  end

  describe 'priority' do
    it 'prefers the mermaid cli over the rust renderer' do
      allow_any_instance_of(described_class).to receive(:mermaid_cli_available?).and_return(true)
      allow_any_instance_of(described_class).to receive(:run_mermaid_cli) do |_caller, _mmdc, destination, _format, _opts|
        File.write(destination, Base64.decode64(PNG_1X1))
        true
      end
      allow(generator).to receive(:run_mermaid_rs_cli)
      generator.parse(flowchart)
      expect(generator).not_to have_received(:run_mermaid_rs_cli)
    end
  end
end
