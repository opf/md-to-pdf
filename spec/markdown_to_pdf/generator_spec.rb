require 'md_to_pdf'
require 'prawn'

Prawn::Fonts::AFM.hide_m17n_warning = true

demo_dir = File.expand_path(File.join(__dir__, '..', '..', 'demo'))

styling_filename = File.join(demo_dir, 'demo.yml')
source_filename = File.join(demo_dir, 'demo.md')
dest_filename = File.join(demo_dir, 'generated', 'demo.pdf')

describe MarkdownToPDF::Generator do
  it "generate the demo via module" do
    File.delete(dest_filename) if File.exist?(dest_filename)
    MarkdownToPDF.generate_markdown_pdf(styling_filename, source_filename, dest_filename)
    expect(File.exist?(dest_filename)).to be(true)
  end

  it "generate the demo via cmdline" do
    File.delete(dest_filename) if File.exist?(dest_filename)
    system("bundle exec md_to_pdf #{styling_filename} #{source_filename} #{dest_filename} >/dev/null 2>&1")
    expect(File.exist?(dest_filename)).to be(true)
  end
end
