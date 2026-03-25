require 'md_to_pdf'
require 'prawn'

Prawn::Fonts::AFM.hide_m17n_warning = true

describe MarkdownToPDF::Generator do
  let(:demo_dir) { File.expand_path(File.join(__dir__, '..', '..', 'demo')) }
  let(:styling_filename) { File.join(demo_dir, 'demo.yml') }
  let(:source_filename) { File.join(demo_dir, 'demo.md') }
  let(:dest_filename) { File.join(demo_dir, 'generated', 'demo.pdf') }

  it "generate the demo file via module" do
    FileUtils.rm_f(dest_filename)
    MarkdownToPDF.generate_markdown_pdf(source_filename, styling_filename, dest_filename)
    expect(File.exist?(dest_filename)).to be(true)
  end

  it "generate the demo binary via module" do
    content = MarkdownToPDF.render_markdown(source_filename, styling_filename)
    expect(content).to start_with "%PDF-1"
  end

  it "generate the demo via cmdline" do
    FileUtils.rm_f(dest_filename)
    system("bundle exec md_to_pdf #{styling_filename} #{source_filename} #{dest_filename} >/dev/null 2>&1")
    expect(File.exist?(dest_filename)).to be(true)
  end
end
