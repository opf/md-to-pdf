require 'prawn'
require 'pdf/inspector'
require 'base64'
require 'md_to_pdf/core'
require 'md_to_pdf/external'
require 'md_to_pdf/markdown_parser'
require 'nokogiri'
require 'color_conversion'
require 'pdf_calls_inspector'

Prawn::Font::AFM.hide_m17n_warning = true

class TestGenerator
  include MarkdownToPDF::Core
  include MarkdownToPDF::External
  include MarkdownToPDF::Parser

  def initialize
    @pdf = Prawn::Document.new({})
    init_options({ auto_generate_header_ids: false })
    pdf_init_md2pdf_fonts(@pdf)
  end

  def parse_file(filepath, styling = {}, smart_headers = true)
    parse File.read("spec/fixtures/#{filepath}").to_s, styling, smart_headers
  end

  def parse(markdown, styling = {}, smart_headers = true)
    @styles = MarkdownToPDF::Styles.new(styling)
    @images_path = 'demo/'
    @styling_images_path = 'demo/'
    root = parse_markdown(markdown)
    draw_node(root, {}, smart_headers)
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

  def mermaid_cli_enabled?
    true
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

  def xobjects
    PDF::Inspector::XObject.analyze(pdf)
  end

  def rectangles
    PDF::Inspector::Graphics::Rectangle.analyze(pdf).rectangles
  end

  def calls
    PDF::Inspector::Calls.analyze(pdf).calls
  end

  def out
    puts "expect_pdf(#{page.to_s
                           .gsub('{:x=>', "\n{x:")
                           .gsub(':y=>', 'y:')
                           .gsub(':text=>', 'text:')})"
  end

  def out_calls
    puts calls.inspect
  end

  def images
    all_calls = calls
    image_calls = calls.each_index.select { |i| all_calls[i][0] == :invoke_xobject } # .find_index { |call| call[0] == :invoke_xobject }
    image_calls.map do |call_index|
      call = all_calls[call_index - 1]
      { x: call[5], y: call[6], width: call[1], height: call[4] }
    end
  end

  def out_images
    puts "expect_pdf_images(#{images.to_s
                                    .gsub('{:x=>', "\n{x:")
                                    .gsub(':width=>', 'width:')
                                    .gsub(':height=>', 'height:')
                                    .gsub(':y=>', 'y:')})"
  end

  def rectangles
    rects = []
    calls.each_with_index do |call, i|
      if call[0] == :append_rectangle
        color = calls[i - 1].slice(1, 3).map { |e| format '%<value>02x', value: e.to_f * 256 }.join
        rects.push [color, call[1], call[2], call[3], call[4]]
      end
    end
    rects
  end

  def borders
    border_calls = []
    calls.each do |call|
      if call[0] == :set_line_width
        border_calls.push(call[1])
      elsif call[0] == :set_color_for_stroking_and_special
        border_calls.push(call.slice(1, 3))
      end
    end
    border_calls
  end

  def out_borders
    puts "expect_pdf_border_rects(\n[\n#{borders.map(&:to_json).join(",\n")}\n])".gsub(",\n[", ', [')
  end

  def out_rectangles
    puts "expect_pdf_color_rects(\n[\n#{rectangles.map(&:to_json).join(",\n")}\n])"
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

  def expect_pdf_images(data)
    expect(images).to eq(data)
  end

  def pdf_raw_color(color)
    "#{(color.upcase.scan %r/../).map { |it| ((it.to_i 16) / 255.0).round 5 }.join ' '} scn"
  end

  def expect_pdf_color_rects(cases)
    actual = rectangles
    expect(actual.length).to eq cases.length
    cases.each_with_index do |case_entry, index|
      expect(case_entry).to eq actual[index]
    end
  end

  def expect_pdf_border_rects(cases)
    actual = borders
    expect(actual.length).to eq cases.length
    cases.each_with_index do |case_entry, index|
      expect(case_entry).to eq actual[index]
    end
  end
end
