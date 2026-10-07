require 'pdf_helpers'

describe MarkdownToPDF::Svg do
  include_context 'with pdf'

  let(:pdf_document) { generator.instance_variable_get(:@pdf) }

  def svg_source(body, attributes = 'width="100" height="50"')
    %(<svg xmlns="http://www.w3.org/2000/svg" #{attributes}>#{body}</svg>)
  end

  def rect_svg(attributes = 'width="100" height="50"')
    svg_source('<rect x="0" y="0" width="100" height="50" fill="#ff0000"/>', attributes)
  end

  def injected_image_svg(href = 'http://example.com/x.png')
    svg_source(%(<image href="#{href}" width="600" height="600"/><rect x="0" y="0" width="10" height="10" fill="#0f0"/>))
  end

  # Captures what reaches prawn-svg, so the hardening options stay asserted even
  # if the renderer itself changes.
  def captured_call(source, opts = {})
    captured = nil
    allow(pdf_document).to receive(:svg) { |svg, **options| captured = { svg: svg, options: options } }
    generator.draw_svg_string(source, opts)
    captured
  end

  describe 'drawing' do
    it 'reports success for a valid svg' do
      expect(generator.draw_svg_string(rect_svg)).to be(true)
    end

    it 'draws the shapes of a valid svg' do
      generator.draw_svg_string(rect_svg)
      expect(rectangles).not_to be_empty
    end

    it 'reports failure for an unparsable document' do
      expect(generator.draw_svg_string('<svg')).to be(false)
    end

    it 'draws nothing for an unparsable document' do
      generator.draw_svg_string('<svg')
      expect(rectangles).to be_empty
    end

    it 'reports failure for a document that is not svg' do
      expect(generator.draw_svg_string('<html><body>hi</body></html>')).to be(false)
    end

    it 'reports failure for a document left without anything to draw' do
      expect(generator.draw_svg_string(svg_source('<script>alert(1)</script>'))).to be(false)
    end

    it 'reports failure instead of raising when prawn-svg rejects the document' do
      allow(pdf_document).to receive(:svg).and_raise(Prawn::SVG::Document::InvalidSVGData, 'nope')
      expect(generator.draw_svg_string(rect_svg)).to be(false)
    end

    it 'reports failure instead of raising when the renderer raises a bare error' do
      allow(pdf_document).to receive(:svg).and_raise(RuntimeError, 'entity expansion has grown too large')
      expect(generator.draw_svg_string(rect_svg)).to be(false)
    end
  end

  describe 'external resources' do
    it 'disables web requests' do
      expect(captured_call(rect_svg)[:options]).to include(enable_web_requests: false)
    end

    it 'disables file requests' do
      expect(captured_call(rect_svg)[:options]).to include(enable_file_requests_with_root: nil)
    end

    it 'disables image caching' do
      expect(captured_call(rect_svg)[:options]).to include(cache_images: false)
    end

    it 'strips an injected image before it reaches the renderer' do
      expect(captured_call(injected_image_svg)[:svg]).not_to include('example.com')
    end

    it 'embeds no image when one is injected' do
      generator.draw_svg_string(injected_image_svg)
      expect(images).to eq([])
    end

    it 'makes no network connection while drawing' do
      allow(TCPSocket).to receive(:new).and_raise('network access attempted')
      expect(generator.draw_svg_string(injected_image_svg)).to be(true)
    end

    it 'never asks the renderer to resolve a url' do
      allow_any_instance_of(Prawn::SVG::UrlLoader).to receive(:load).and_raise('url resolution attempted')
      expect(generator.draw_svg_string(injected_image_svg)).to be(true)
    end

    ['text:/etc/passwd', 'file:///etc/passwd', '/etc/passwd', '../../../../etc/passwd'].each do |href|
      it "strips an image pointing at the local file #{href}" do
        expect(captured_call(injected_image_svg(href))[:svg]).not_to include('<image', 'passwd')
      end

      it "reads no local file for an image pointing at #{href}" do
        allow(File).to receive(:binread).and_raise('file access attempted')
        expect(generator.draw_svg_string(injected_image_svg(href))).to be(true)
      end
    end
  end

  describe 'sizing' do
    it 'keeps an svg that fits its intrinsic width' do
      expect(captured_call(rect_svg('width="100" height="50"'))[:options]).to include(width: 100.0)
    end

    it 'scales an svg wider than the page down to the available width' do
      expect(captured_call(rect_svg('width="2000" height="100"'))[:options])
        .to include(width: pdf_document.bounds.width)
    end

    it 'falls back to the view box when there are no width and height attributes' do
      expect(captured_call(rect_svg('viewBox="0 0 120 60"'))[:options]).to include(width: 120.0)
    end

    it 'uses the available width when the document has no size at all' do
      expect(captured_call(rect_svg(''))[:options]).to include(width: pdf_document.bounds.width)
    end
  end

  describe 'fonts' do
    let(:unknown_font_svg) { svg_source('<text x="1" y="1" font-family="Arial, Helvetica, sans-serif">a</text>') }

    it 'rewrites the font family to a font the document registered' do
      expect(captured_call(unknown_font_svg)[:svg]).to include(%(font-family="#{pdf_document.font.family}"))
    end

    it 'removes the font family the document does not know' do
      expect(captured_call(unknown_font_svg)[:svg]).not_to include('Arial')
    end

    it 'passes the same font as the renderer fallback' do
      expect(captured_call(unknown_font_svg)[:options]).to include(fallback_font_name: pdf_document.font.family)
    end

    it 'prefers the font of the surrounding style when it is registered' do
      captured = captured_call(svg_source('<text x="1" y="1" font-family="Arial">a</text>'), { font: 'Courier' })
      expect(captured[:svg]).to include('font-family="Courier"')
    end

    it 'ignores a surrounding style font the document does not know' do
      captured = captured_call(unknown_font_svg, { font: 'NotRegistered' })
      expect(captured[:options]).to include(fallback_font_name: pdf_document.font.family)
    end
  end
end
