require 'commonmarker'
require 'front_matter_parser'

module MarkdownToPDF
  module Parser
    def parse_frontmatter_markdown(markdown, default_fields)
      parsed = FrontMatterParser::Parser.new(:md).call(markdown)
      content = parsed.content
      matter = (default_fields || {}).merge(parsed.front_matter)
      fields = matter['pdf_fields'] || matter[:pdf_fields] || {}
      matter = symbolize(matter)
      header_footer = parse_header_footer(matter)
      fields.each_key do |key|
        content = content.gsub("%#{key}%", fields[key].to_s)
        header_footer.each_key do |part|
          header_footer[part] = header_footer[part].gsub("%#{key}%", fields[key].to_s)
        end
      end
      {
        root: parse_markdown(content),
        logo: matter[:pdf_header_logo],
        language: matter[:pdf_language],
        hyphenation: matter[:pdf_hyphenation] != false # default: true
      }.merge(header_footer)
    end

    def parse_markdown(markdown)
      cm_extensions = %i[autolink strikethrough table tagfilter tasklist]
      cm_parse_options = %i[FOOTNOTES SMART LIBERAL_HTML_TAG STRIKETHROUGH_DOUBLE_TILDE UNSAFE VALIDATE_UTF8]
      CommonMarker.render_doc(markdown, cm_parse_options, cm_extensions)
    end

    private

    def parse_header_footer(parsed)
      {
        footer: parsed[:pdf_footer] || '',
        header: parsed[:pdf_header] || '',
        footer2: parsed[:pdf_footer_2] || '',
        footer3: parsed[:pdf_footer_3] || '',
        header2: parsed[:pdf_header_2] || '',
        header3: parsed[:pdf_header_3] || ''
      }
    end
  end
end
