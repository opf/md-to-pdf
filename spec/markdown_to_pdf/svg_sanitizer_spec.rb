require 'pdf_helpers'

SVG_KEEP = '<rect width="1" height="1"/>'.freeze

# prawn-svg hands an <image href> to its URL loaders, which read a local path for a
# file: URL or for no scheme at all, and fetch anything http(s).
SVG_REFERENCES = [
  'text:/etc/passwd',
  'file:///etc/passwd',
  '/etc/passwd',
  '../../../../etc/passwd',
  'http://example.com/x.png',
  'https://example.com/x.png',
  'data:image/png;base64,iVBORw0KGgo=',
  'javascript:alert(1)'
].freeze

describe MarkdownToPDF::SvgSanitizer do
  def sanitize(svg, font_family: nil)
    described_class.sanitize(svg, font_family: font_family)
  end

  def sanitized_svg(svg, font_family: nil)
    sanitize(svg, font_family: font_family)&.fetch(:svg)
  end

  def wrap(body, attributes = 'width="100" height="50"')
    %(<svg xmlns="http://www.w3.org/2000/svg" #{attributes}>#{body}</svg>)
  end

  describe 'rejected input' do
    it 'rejects nil' do
      expect(sanitize(nil)).to be_nil
    end

    it 'rejects an empty string' do
      expect(sanitize('')).to be_nil
    end

    it 'rejects a document that is not svg' do
      expect(sanitize('<html><body>hello</body></html>')).to be_nil
    end

    it 'rejects a document carrying a doctype' do
      svg = %(<!DOCTYPE svg [<!ENTITY a "b">]>#{wrap('<rect width="1" height="1"/>')})
      expect(sanitize(svg)).to be_nil
    end

    it 'rejects input above the byte limit' do
      expect(sanitize(wrap("<desc>#{'x' * described_class::MAX_BYTES}</desc>"))).to be_nil
    end

    it 'rejects a billion laughs document without raising' do
      entities = (1..6).map { |i| %(<!ENTITY e#{i} "#{"&e#{i - 1};" * 10}">) }.join
      svg = %(<!DOCTYPE svg [<!ENTITY e0 "aaaaaaaaaa">#{entities}]>#{wrap('<text x="1" y="1">&e6;</text>')})
      expect(sanitize(svg)).to be_nil
    end
  end

  describe 'element allowlist' do
    it 'drops script elements' do
      expect(sanitized_svg(wrap('<script>alert(1)</script><rect width="1" height="1"/>')))
        .not_to include('script', 'alert')
    end

    it 'drops image elements' do
      expect(sanitized_svg(wrap(%(<image href="http://example.com/x.png" width="9" height="9"/><rect width="1" height="1"/>))))
        .not_to include('image', 'example.com')
    end

    it 'drops foreignObject elements' do
      expect(sanitized_svg(wrap('<foreignObject><div>hi</div></foreignObject><rect width="1" height="1"/>')))
        .not_to include('foreignObject', 'div')
    end

    it 'drops style elements' do
      expect(sanitized_svg(wrap(%(<style>@import url("http://example.com/x.css");</style><rect width="1" height="1"/>))))
        .not_to include('style', 'import', 'example.com')
    end

    it 'drops anchor elements together with their content' do
      expect(sanitized_svg(wrap(%(<a href="http://example.com"><rect width="1" height="1"/></a><circle r="1"/>))))
        .not_to include('<a ', 'example.com', '<rect')
    end

    it 'drops use elements' do
      expect(sanitized_svg(wrap(%(<defs><rect id="r" width="1" height="1"/></defs><use href="#r"/>))))
        .not_to include('<use')
    end

    it 'keeps drawing elements' do
      svg = sanitized_svg(wrap('<g><rect width="1" height="1"/><circle cx="1" cy="1" r="1"/><path d="M 0 0 L 1 1"/></g>'))
      expect(svg).to include('<g>', '<rect', '<circle', '<path')
    end

    it 'drops comments' do
      expect(sanitized_svg(wrap('<!-- secret --><rect width="1" height="1"/>'))).not_to include('secret')
    end

    it 'rejects a document left without anything to draw' do
      expect(sanitize(wrap('<script>alert(1)</script>'))).to be_nil
    end

    it 'rejects an empty document' do
      expect(sanitize(wrap(''))).to be_nil
    end

    it 'rejects a document above the element limit' do
      body = '<rect width="1" height="1"/>' * (described_class::MAX_ELEMENTS + 1)
      expect(sanitized_svg(wrap(body)).scan('<rect').length).to be < described_class::MAX_ELEMENTS
    end
  end

  describe 'external references' do
    SVG_REFERENCES.each do |reference|
      it "drops an image element referencing #{reference}" do
        svg = sanitized_svg(wrap(%(<image href="#{reference}" width="600" height="600"/>#{SVG_KEEP})))
        expect(svg).not_to include('<image', reference)
      end

      it "drops an href attribute referencing #{reference} from an allowed element" do
        svg = sanitized_svg(wrap(%(<rect width="1" height="1" href="#{reference}"/>)))
        expect(svg).not_to include('href', reference)
      end

      it "drops an allowed attribute whose value references #{reference}" do
        svg = sanitized_svg(wrap(%(<rect width="1" height="1" fill="#{reference}"/>)))
        expect(svg).not_to include('fill=', reference)
      end
    end

    it 'keeps a local fragment reference' do
      expect(sanitized_svg(wrap(%(<rect width="1" height="1" fill="url(#grad)"/>))))
        .to include('fill="url(#grad)"')
    end

    it 'drops an element from a foreign namespace' do
      svg = %(<svg xmlns="http://www.w3.org/2000/svg" xmlns:h="http://www.w3.org/1999/xhtml">) \
            "<h:rect width=\"1\" height=\"1\"/>#{SVG_KEEP}</svg>"
      expect(sanitized_svg(svg).scan('<rect').length).to eq(1)
    end
  end

  describe 'attribute allowlist' do
    it 'drops event handler attributes' do
      expect(sanitized_svg(wrap(%(<rect width="1" height="1" onload="alert(1)"/>))))
        .not_to include('onload', 'alert')
    end

    it 'drops style attributes' do
      expect(sanitized_svg(wrap(%(<rect width="1" height="1" style="fill:url(http://example.com/g)"/>))))
        .not_to include('style', 'example.com')
    end

    it 'drops namespaced attributes' do
      svg = %(<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">) +
            %(<rect width="1" height="1" xlink:href="http://example.com/x"/></svg>)
      expect(sanitized_svg(svg)).not_to include('xlink:href', 'example.com')
    end

    it 'drops url() values pointing outside the document' do
      expect(sanitized_svg(wrap(%(<rect width="1" height="1" fill="url(http://example.com/g)"/>))))
        .not_to include('fill', 'example.com')
    end

    it 'keeps url() values referencing the same document' do
      expect(sanitized_svg(wrap(%(<rect width="1" height="1" fill="url(#grad)"/>))))
        .to include('fill="url(#grad)"')
    end

    it 'keeps marker references pointing at the same document' do
      expect(sanitized_svg(wrap(%(<path d="M 0 0 L 1 1" marker-end="url(#arrow)"/>))))
        .to include('marker-end="url(#arrow)"')
    end

    it 'drops marker references pointing outside the document' do
      expect(sanitized_svg(wrap(%(<path d="M 0 0 L 1 1" marker-end="url(http://example.com/a)"/>))))
        .not_to include('marker-end', 'example.com')
    end

    it 'keeps presentation attributes' do
      svg = sanitized_svg(wrap(%(<rect width="1" height="1" fill="#ff0000" stroke-width="2" opacity="0.5"/>)))
      expect(svg).to include('fill="#ff0000"', 'stroke-width="2"', 'opacity="0.5"')
    end
  end

  describe 'text handling' do
    it 'neutralises markup injected through text content' do
      injected = '</text><image href=\'http://example.com/x.png\' width="9" height="9"/><text>'
      svg = sanitized_svg(wrap(%(<text x="1" y="1">#{injected}</text>)))
      expect(svg).not_to include('<image', 'example.com')
    end

    it 'escapes characters that would close an element' do
      svg = sanitized_svg(wrap('<text x="1" y="1">a &lt;/text&gt; b</text>'))
      expect(svg).to include('a &lt;/text&gt; b')
    end

    it 'keeps the literal text of a label' do
      expect(sanitized_svg(wrap('<text x="1" y="1">a &amp; b</text>'))).to include('a &amp; b')
    end

    it 'drops text outside of text elements' do
      expect(sanitized_svg(wrap('<g>leaked<rect width="1" height="1"/></g>'))).not_to include('leaked')
    end
  end

  describe 'font normalisation' do
    let(:normalised) do
      sanitized_svg(wrap('<text x="1" y="1" font-family="Arial, Helvetica, sans-serif">a</text>'),
                    font_family: 'TestFont')
    end

    it 'applies the given font family' do
      expect(normalised).to include('font-family="TestFont"')
    end

    it 'removes the original font family' do
      expect(normalised).not_to include('Arial')
    end

    it 'keeps the original font family when none is given' do
      expect(sanitized_svg(wrap('<text x="1" y="1" font-family="Arial">a</text>'))).to include('font-family="Arial"')
    end
  end

  describe 'repairs' do
    let(:repaired) { sanitized_svg(wrap('<rect width="1" height="1" fill-opacity="0.3" fill-opacity="0.9"/>')) }

    it 'keeps a duplicated attribute only once' do
      expect(repaired.scan('fill-opacity').length).to eq(1)
    end

    it 'produces a document that parses strictly' do
      expect { Nokogiri::XML(repaired, &:strict) }.not_to raise_error
    end
  end

  describe 'viewport' do
    it 'reports the width attribute' do
      expect(sanitize(wrap('<rect width="1" height="1"/>'))[:width]).to eq('100')
    end

    it 'reports the height attribute' do
      expect(sanitize(wrap('<rect width="1" height="1"/>'))[:height]).to eq('50')
    end

    it 'reports the view box' do
      result = sanitize(wrap('<rect width="1" height="1"/>', 'viewBox="0 0 10 20"'))
      expect(result[:view_box]).to eq('0 0 10 20')
    end
  end
end
