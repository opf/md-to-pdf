require_relative '../../lib/md_to_pdf/style/schema'
require_relative '../../lib/md_to_pdf/style/schema_doc'
require "json"
require 'yaml'

desc "Generate styles documentation"
task :styles_doc do
  include MarkdownToPDF::StyleSchema

  generator = MarkdownToPDF::StyleSchemaDocsGenerator.new(styles_schema)
  markdown = generator.generate_markdown
  root = File.expand_path("../../", __dir__)
  styles_doc_file = File.join(root, 'docs', 'STYLES.md')
  File.write(styles_doc_file, markdown)
  puts "Done."
end
