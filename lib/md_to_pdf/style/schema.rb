module MarkdownToPDF
  module StyleSchema
    def styles_schema
      @styles_schema ||= load_schema('schema_styles.json')
    end

    def frontmatter_schema
      @frontmatter_schema ||= load_schema('schema_frontmatter.json')
    end

    def load_schema(filename)
      JSON::load_file(File.join(File.dirname(File.expand_path(__FILE__)), filename))
    end
  end
end
