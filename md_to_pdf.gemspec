# frozen_string_literal: true

require_relative "lib/md_to_pdf/version"

Gem::Specification.new do |s|
  s.name = "md_to_pdf"
  s.version = MarkdownToPDF::VERSION
  s.summary = "markdown2pdf generator"
  s.description = "A markdown to pdf generator with styling by yml"
  s.authors = ["OpenProject"]
  s.email = ["info@openproject.org"]
  s.files = Dir.glob('{bin,spec,lib/**/**/*') + %w[md_to_pdf.gemspec LICENSE]
  s.licenses = ["GPL-3.0"]
  s.homepage = "https://github.com/opf/md-to-pdf"

  s.platform = Gem::Platform::RUBY
  s.require_paths = ['lib']
  s.required_ruby_version = '>= 3.4.0'

  s.add_dependency "base64", ["~> 0.2"]
  s.add_dependency "bigdecimal", ["~> 3.1"]
  s.add_dependency "color_conversion", ["~> 0.1"]
  s.add_dependency "front_matter_parser", ["~> 1.0"]
  s.add_dependency "json-schema", ["~> 4.3"]
  s.add_dependency "markly", ["~> 0.13"]
  s.add_dependency "matrix", ["~> 0.4"]
  s.add_dependency "nokogiri", ["~> 1.18"]
  s.add_dependency "prawn", ["~> 2.4"]
  s.add_dependency "prawn-table", ["~> 0.2"]
  s.add_dependency "text-hyphen", ["~> 1.5"]

  s.metadata['rubygems_mfa_required'] = 'true'
  s.metadata["homepage_uri"] = s.homepage
  s.metadata["source_code_uri"] = "https://github.com/opf/md-to-pdf"
  s.metadata["changelog_uri"] = "https://github.com/opf/md-to-pdf/CHANGELOG.md"

  s.bindir = "bin"
  s.executables << "md_to_pdf"
end
