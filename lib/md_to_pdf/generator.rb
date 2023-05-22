require 'md_to_pdf/core'
require 'md_to_pdf/external'
require 'md_to_pdf/hyphen'
require 'md_to_pdf/markdown_parser'

module MarkdownToPDF
  class Generator
    include MarkdownToPDF::Core
    include MarkdownToPDF::External
    include MarkdownToPDF::Parser

    def initialize(fonts_path:, styling_image_path:, styling_yml_filename:)
      @fonts_path = fonts_path || '.'
      @styling_images_path = styling_image_path || '.'
      yml = styling_yml_filename ? YAML.load_file(styling_yml_filename) : {}
      symbol_yml = symbolize(yml)
      validate_styles!(symbol_yml)
      @styles = Styles.new(symbolize(yml))
    end

    def file_to_pdf(markdown_file, pdf_destination, images_path = nil)
      markdown = File.read(markdown_file)
      markdown_to_pdf(markdown, pdf_destination, images_path || File.dirname(markdown_file))
    end

    def file_to_pdf_bin(markdown_file, images_path = nil)
      markdown = File.read(markdown_file)
      markdown_to_pdf_bin(markdown, images_path || File.dirname(markdown_file))
    end

    def markdown_to_pdf(markdown_string, pdf_destination, images_path)
      FileUtils.mkdir_p File.dirname(pdf_destination)
      render_markdown(markdown_string, images_path)
      @pdf.render_file(pdf_destination)
    end

    def markdown_to_pdf_bin(markdown_string, images_path)
      render_markdown(markdown_string, images_path)
      @pdf.render
    end

    private

    def render_markdown(markdown_string, images_path)
      pdf_setup_document
      @images_path = images_path
      doc = parse_frontmatter_markdown(markdown_string, @styles.default_fields)
      @hyphens = Hyphen.new(doc[:language], doc[:hyphenation])
      render_doc(doc)
    end

    def render_doc(doc)
      style = @styles.page
      opts = pdf_root_options(style)
      root = doc[:root]
      draw_node(root, opts, true)
      draw_footnotes(opts)
      repeating_page_footer(doc, opts)
      repeating_page_header(doc, opts)
      repeating_page_logo(doc[:logo], root, opts)
    end

    def pdf_setup_document
      style = @styles.page
      @pdf = Prawn::Document.new(pdf_document_options(style))
      pdf_init_fonts(@pdf, @styles.fonts, @styles.fallback_font, @fonts_path)
    end
  end
end
