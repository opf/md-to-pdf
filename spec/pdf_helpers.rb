require 'prawn'
require 'pdf/inspector'
require 'base64'
require 'md_to_pdf/core'
require 'md_to_pdf/external'
require 'md_to_pdf/markdown_parser'
require 'nokogiri'

Prawn::Font::AFM.hide_m17n_warning = true

class TestGenerator
  include MarkdownToPDF::Core
  include MarkdownToPDF::External
  include MarkdownToPDF::Parser

  def initialize
    @pdf = Prawn::Document.new({})
    init_options({ auto_generate_header_ids: false })
  end

  def parse_file(filepath, styling = {})
    parse File.read('spec/fixtures/' + filepath).to_s, styling
  end

  def parse(markdown, styling = {})
    @styles = MarkdownToPDF::Styles.new(styling)
    @images_path = 'demo/'
    root = parse_markdown(markdown)
    draw_node(root, {}, true)
    draw_footnotes({})
  end

  def render
    @pdf.render
  end

  def hyphenate(text)
    text # @hyphens.hyphenate(text)
  end
end

# use an own context for Prawn::Markup, as this might be extracted at some point
RSpec.shared_context 'pdf_helpers' do
  let(:generator) { TestGenerator.new }
  let(:pdf) { generator.render }
  let(:text) { PDF::Inspector::Text.analyze(pdf) }

end
