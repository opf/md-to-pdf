require 'prawn'
require 'pdf/inspector'
require 'base64'
require 'md_to_pdf/core'
require 'md_to_pdf/external'
require 'md_to_pdf/markdown_parser'
require 'nokogiri'
require 'color_conversion'

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
    parse File.read("spec/fixtures/#{filepath}").to_s, styling
  end

  def parse(markdown, styling = {})
    @styles = MarkdownToPDF::Styles.new(styling)
    @images_path = 'demo/'
    @styling_images_path = 'demo/'
    root = parse_markdown(markdown)
    draw_node(root, {}, true)
    draw_footnotes({})
  end

  def warn(text, element, node)
    puts "WARNING: #{text}\nGot #{element} at #{node ? node.source_position.inspect : '?'}\n\n" unless text == 'Image file not found'
  end

  def render
    @pdf.render
  end

  def render_file(filename)
    @pdf.render_file(filename)
  end

  def hyphenate(text)
    text # @hyphens.hyphenate(text)
  end
end

RSpec.shared_context 'with pdf' do
  let(:generator) { TestGenerator.new }
  let(:pdf) { generator.render }

  def page
    inspect = PDF::Inspector::Text.analyze(pdf)
    positions = inspect.positions
    strings = inspect.strings
    result = []
    strings.each_with_index do |text, index|
      result.push({ x: positions[index][0], y: positions[index][1], text: text })
    end
    result
  end

  def out
    puts "expect_pdf(#{page.to_s
                           .gsub('{:x=>', "\n{x:")
                           .gsub(':y=>', 'y:')
                           .gsub(':text=>', 'text:')})"
  end

  def out_rectangles
    list = extract_graphic_states(generator.render).flatten
    result = []
    list.each_with_index do |s, i|
      if s.end_with?('re')
        color = list[i - 1].split.take(3).map { |e| format '%<value>02x', value: e.to_f * 256 }.join
        result.push [color, *s.split.take(4)].to_json
      end
    end
    puts "expect_pdf_color_rects(\n[\n#{result.join(",\n")}\n])"
  end

  def show
    file = Tempfile.new(%w[test .pdf])
    generator.render_file(file.path)
    cmd = "open #{file.path}"
    `#{cmd}`
  end

  def expect_pdf(data)
    expect(page).to eq(data)
  end

  def extract_graphic_states(content)
    content = (content.delete_prefix %(q\n)).delete_suffix %(\nQ)
    (content.scan %r/^q\n(.*?)\nQ$/m).map { |it| it[0].split ?\n }
  end

  def pdf_raw_color(color)
    "#{(color.upcase.scan %r/../).map { |it| ((it.to_i 16) / 255.0).round 5 }.join ' '} scn"
  end

  def expect_pdf_color_rects(cases)
    actual = extract_graphic_states(generator.render).flatten.join(' ')
    cases.each do |case_entry|
      color, x, y, w, h = case_entry
      c = pdf_raw_color(color)
      expect(actual).to include "#{c} #{x} #{y} #{w} #{h} re"
    end
  end
end
