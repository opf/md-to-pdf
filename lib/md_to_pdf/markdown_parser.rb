require 'commonmarker'
require 'front_matter_parser'

CM_EXTENSIONS = %i[
  autolink
  strikethrough
  table
  tagfilter
  tasklist
].freeze
CM_PARSE_OPTIONS = %i[
  FOOTNOTES
  SMART
  LIBERAL_HTML_TAG
  STRIKETHROUGH_DOUBLE_TILDE
  UNSAFE
  VALIDATE_UTF8
].freeze

module MarkdownToPDF
  class Parser
    def parse_markdown(markdown)
      parsed = FrontMatterParser::Parser.new(:md).call(markdown)
      content = parsed.content
      page_number_template = parsed['pdf_page_number_template'] || ''
      header_footer = {
        footer: parsed['pdf_footer'] || '',
        header: parsed['pdf_header'] || '',
        footer2: parsed['pdf_footer_2'] || '',
        footer3: parsed['pdf_footer_3'] || '',
        header2: parsed['pdf_header_2'] || '',
        header3: parsed['pdf_header_3'] || ''
      }
      fields = parsed['pdf_fields'] || {}
      fields.each_key do |key|
        content = content.gsub("%#{key}%", fields[key])
        header_footer.each_key do |part|
          header_footer[part] = header_footer[part].gsub("%#{key}%", fields[key])
        end
        page_number_template = page_number_template.gsub("%#{key}%", fields[key])
      end
      {
        root: CommonMarker.render_doc(content, CM_PARSE_OPTIONS, CM_EXTENSIONS),
        frontmatter: parsed.front_matter,
        fields: fields,
        logo: parsed['pdf_header_logo'],
        language: parsed['pdf_language'],
        hyphenation: parsed['pdf_hyphenation'] != false, # default: true
        page_number_template: page_number_template
      }.merge(header_footer)
    end
  end
end
