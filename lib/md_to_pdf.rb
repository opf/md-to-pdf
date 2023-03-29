# -*- frozen_string_literal: true -*-

require 'yaml'
require 'nokogiri'
require 'fileutils'
require 'md_to_pdf/generator'
require 'md_to_pdf/prawn_fix'

module MarkdownToPDF
  def self.init_generator(styling_yml_filename)
    MarkdownToPDF::Generator.new(
      styling_yml_filename: styling_yml_filename,
      styling_image_path: File.join(File.dirname(styling_yml_filename), 'images'),
      fonts_path: File.join(File.dirname(styling_yml_filename), 'fonts')
    )
  end

  def self.generate_markdown_pdf(markdown_file, styling_yml_filename, destination_filename)
    renderer = init_generator(styling_yml_filename)
    renderer.file_to_pdf(markdown_file, destination_filename)
  end

  def self.render_markdown(markdown_file, styling_yml_filename)
    renderer = init_generator(styling_yml_filename)
    renderer.file_to_pdf_bin(markdown_file)
  end

  def self.generate_markdown_string_pdf(markdown_string, styling_yml_filename, images_path, destination_filename)
    renderer = init_generator(styling_yml_filename)
    renderer.markdown_to_pdf(markdown_string, destination_filename, images_path)
  end

  def self.render_markdown_string(markdown_string, styling_yml_filename, images_path)
    renderer = init_generator(styling_yml_filename)
    renderer.markdown_to_pdf_bin(markdown_string, images_path)
  end
end
