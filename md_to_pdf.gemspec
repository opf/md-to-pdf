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
  s.required_ruby_version = '>= 3.0.3'

  s.add_runtime_dependency "commonmarker", ["~> 0.23.6"]
  s.add_runtime_dependency "front_matter_parser", ["~> 1.0"]
  s.add_runtime_dependency "matrix", ["~> 0.4.2"]
  s.add_runtime_dependency "nokogiri", ["~> 1.13.9"]
  s.add_runtime_dependency "prawn", ["~> 2.4"]
  s.add_runtime_dependency "prawn-table", ["~> 0.2.2"]
  s.add_runtime_dependency "text-hyphen", ["~> 1.4.1"]

  s.add_development_dependency "rake", "~> 13.0"
  s.add_development_dependency "rspec", "~> 3.2"
  s.add_development_dependency 'rubocop', '~> 1.37.1'
  s.add_development_dependency 'rubocop-rake', '~> 0.6.0'
  s.add_development_dependency 'rubocop-rspec', '~> 2.14.1'

  s.metadata['rubygems_mfa_required'] = 'true'
  s.metadata["homepage_uri"] = s.homepage
  s.metadata["source_code_uri"] = "https://github.com/opf/md-to-pdf"
  s.metadata["changelog_uri"] = "https://github.com/opf/md-to-pdf/CHANGELOG.md"

  s.bindir = "bin"
  s.executables << "md_to_pdf"
end
