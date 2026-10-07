require 'nokogiri'

module MarkdownToPDF
  # Rebuilds an SVG document from an allowlist of elements and attributes.
  #
  # The input is untrusted: diagram renderers interpolate document text into their
  # output without escaping it, so markup can be injected through a diagram label.
  # The result is therefore constructed from scratch instead of being patched in
  # place, which is what makes anything outside the allowlist unable to survive.
  module SvgSanitizer
    SVG_NAMESPACE = 'http://www.w3.org/2000/svg'.freeze

    MAX_BYTES = 2 * 1024 * 1024
    MAX_ELEMENTS = 20_000

    ELEMENTS = %w[
      svg g defs symbol title desc
      rect circle ellipse line polyline polygon path
      text tspan marker clipPath
      linearGradient radialGradient stop
    ].freeze

    # Elements whose character data is part of the drawing. Everywhere else text
    # nodes are dropped, so stray content cannot leak into the page.
    TEXT_ELEMENTS = %w[text tspan title desc].freeze

    GEOMETRY_ATTRIBUTES = %w[
      x y dx dy x1 y1 x2 y2 cx cy r rx ry fx fy width height d points
      transform viewBox preserveAspectRatio offset
      gradientUnits gradientTransform spreadMethod clipPathUnits
      markerWidth markerHeight markerUnits refX refY orient
    ].freeze

    PRESENTATION_ATTRIBUTES = %w[
      fill fill-opacity fill-rule
      stroke stroke-width stroke-opacity stroke-dasharray stroke-dashoffset
      stroke-linecap stroke-linejoin stroke-miterlimit
      opacity color display visibility overflow clip-path clip-rule
      marker-start marker-mid marker-end
      font-family font-size font-weight font-style
      text-anchor dominant-baseline alignment-baseline text-decoration
      letter-spacing word-spacing
      stop-color stop-opacity
    ].freeze

    ATTRIBUTES = (GEOMETRY_ATTRIBUTES + PRESENTATION_ATTRIBUTES + %w[id class]).freeze

    # Second gate, independent of the allowlists above. Everything here is already
    # excluded by not being allowlisted, but these are the names that would hand a
    # reference to prawn-svg's URL loaders, so widening the allowlist later must not
    # be enough on its own to reopen that path.
    FORBIDDEN_ELEMENTS = %w[
      image use script style a foreignObject iframe
      filter feImage pattern mask switch animate animateTransform set font-face
    ].freeze

    FORBIDDEN_ATTRIBUTES = %w[href src data].freeze

    # prawn-svg hands an <image href> straight to its loaders, which read a local
    # path for a file: URL or for no scheme at all, and fetch anything http(s).
    # An unknown scheme such as "text:/etc/passwd" finds no loader today, but that
    # is a property of the renderer, not a guarantee, so any scheme is refused.
    EXTERNAL_SCHEME = /\A\s*[a-z][a-z0-9+.-]*:/i

    # A scheme-less path is what prawn-svg's file loader resolves against its root,
    # so it is refused in the same way. No geometry or presentation value legitimately
    # starts with a path separator.
    PATH_REFERENCE = %r{\A\s*\.{0,2}/}

    # Free-form names that the renderer never dereferences, so a colon in them is
    # not a reference.
    OPAQUE_ATTRIBUTES = %w[id class].freeze

    # Only same document references survive. Anything else in a url() value would
    # make prawn-svg resolve an external resource.
    LOCAL_URL = /\Aurl\(\s*['"]?#[\w.:-]+['"]?\s*\)\z/

    module_function

    # Returns nil when the input cannot be made safe, otherwise a hash with the
    # rebuilt document and the raw viewport attributes needed to size it.
    def sanitize(svg, font_family: nil)
      source = svg.to_s
      return nil if source.empty? || source.bytesize > MAX_BYTES

      root = parse_root(source)
      return nil if root.nil?

      document = Nokogiri::XML::Document.new
      clean = copy_element(document, root, font_family, [MAX_ELEMENTS])
      return nil if clean.nil? || clean.element_children.empty?

      clean['xmlns'] = SVG_NAMESPACE
      document.root = clean
      {
        svg: document.to_xml(indent: 0, save_with: Nokogiri::XML::Node::SaveOptions::AS_XML),
        width: clean['width'],
        height: clean['height'],
        view_box: clean['viewBox']
      }
    rescue StandardError
      nil
    end

    def parse_root(source)
      document = Nokogiri::XML(source) do |config|
        # No NOENT and no DTDLOAD: entities are never substituted and no external
        # subset is fetched. RECOVER lets us normalise malformed markup instead of
        # dropping the whole diagram, which is safe because nothing from the parsed
        # tree reaches the renderer except through the allowlist below.
        config.options = Nokogiri::XML::ParseOptions::RECOVER |
                         Nokogiri::XML::ParseOptions::NONET |
                         Nokogiri::XML::ParseOptions::NOBLANKS
      end
      return nil if document.internal_subset

      root = document.root
      root if root&.name == 'svg'
    end

    def copy_element(document, node, font_family, budget)
      return nil if FORBIDDEN_ELEMENTS.include?(node.name)
      return nil unless ELEMENTS.include?(node.name)
      return nil unless svg_namespace?(node)
      return nil if budget[0] <= 0

      budget[0] -= 1
      clean = Nokogiri::XML::Node.new(node.name, document)
      copy_attributes(node, clean, font_family)
      copy_children(document, node, clean, font_family, budget)
      clean
    end

    def copy_children(document, node, clean, font_family, budget)
      keep_text = TEXT_ELEMENTS.include?(node.name)
      node.children.each do |child|
        if child.element?
          copied = copy_element(document, child, font_family, budget)
          clean << copied unless copied.nil?
        elsif keep_text && child.text?
          clean << Nokogiri::XML::Text.new(child.text, document)
        end
      end
    end

    def copy_attributes(node, clean, font_family)
      node.attribute_nodes.each do |attribute|
        name = attribute.name
        next unless attribute.namespace.nil?
        next if FORBIDDEN_ATTRIBUTES.include?(name)
        next unless ATTRIBUTES.include?(name)

        value = attribute.value.to_s
        next if value.include?('url(') && !value.match?(LOCAL_URL)
        next if !OPAQUE_ATTRIBUTES.include?(name) && reference?(value)

        value = font_family if font_family && name == 'font-family'
        clean[name] = value
      end
    end

    def reference?(value)
      value.match?(EXTERNAL_SCHEME) || value.match?(PATH_REFERENCE)
    end

    def svg_namespace?(node)
      namespace = node.namespace
      namespace.nil? || namespace.href == SVG_NAMESPACE
    end
  end
end
