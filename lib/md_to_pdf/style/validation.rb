require "json-schema"
require "json"

module MarkdownToPDF
  module StyleValidation
    class StyleValidationError < StandardError
    end

    def styles_schema
      @styles_schema ||= load_schema('schema_styles.json')
    end

    def frontmatter_schema
      @frontmatter_schema ||= load_schema('schema_frontmatter.json')
    end

    def validate_styles!(yml)
      validate_schema!(yml, styles_schema)
    end

    def validate_frontmatter!(yml)
      validate_schema!(yml, frontmatter_schema)
    end

    def validate_schema!(yml, schema)
      errors = JSON::Validator.fully_validate(schema, yml, validate_schema: true)
      raise StyleValidationError.new(errors.join("\n")) unless errors.empty?
    end

    private

    def resolve_strict_property(value, defs)
      if value.is_a?(Array)
        value.map { |n| resolve_strict_property(n, defs) }
      elsif value.is_a?(Hash)
        resolve_strict_properties(value, defs)
      else
        value
      end
    end

    def resolve_strict_properties(node, defs)
      return nil if node.nil?

      ref = node['$ref']
      result = if ref.nil?
                 clone = {}
                 node.each_key { |key| clone[key] = resolve_strict_property(node[key], defs) }
                 clone
               else
                 def_name = ref.sub('#/$defs/', '')
                 resolve_strict_properties(defs[def_name], defs)
               end
      if result['type'] == 'object'
        result['additionalProperties'] = false
        if result['allOf']
          properties = result['properties'] || {}
          result['allOf'].each do |n|
            sub = resolve_strict_property(n, defs)
            properties = properties.merge(sub['properties'])
          end
          result.delete('allOf')
          result['properties'] = properties
        end
      end
      result
    end

    def load_schema(filename)
      schema = JSON::load_file(File.join(File.dirname(File.expand_path(__FILE__)), filename))
      strict_schema(schema)
    end

    def strict_schema(schema)
      defs = schema["$defs"]
      {
        type: schema["type"],
        required: schema["required"] || [],
        additionalProperties: schema["additionalProperties"],
        properties: resolve_strict_properties(schema["properties"], defs),
        patternProperties: resolve_strict_properties(schema["patternProperties"], defs)
      }.compact
    end
  end
end
