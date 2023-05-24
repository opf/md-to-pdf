require "json-schema"
require "json"

module MarkdownToPDF
  module StyleValidation
    class StyleValidationError < StandardError
    end

    def validate_schema!(yml, schema)
      errors = JSON::Validator.fully_validate(strict_schema(schema), yml, validate_schema: true)
      raise StyleValidationError.new(errors.join("\n")) unless errors.empty?

      yml
    end

    private

    def strict_schema(schema)
      # JSON schema does not properly support additionalProperties in combination with allOf[..],
      # merge all references "inline" to be able to set additionalProperties=true
      defs = schema["$defs"]
      {
        type: schema["type"],
        required: schema["required"] || [],
        additionalProperties: schema["additionalProperties"],
        properties: resolve_strict_properties(schema["properties"], defs),
        patternProperties: resolve_strict_properties(schema["patternProperties"], defs)
      }.compact
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
                 definition = defs[def_name]
                 raise StyleValidationError.new("Invalid Schema, missing $ref=#{ref}") if definition.nil?

                 resolve_strict_properties(definition, defs)
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

    def resolve_strict_property(value, defs)
      if value.is_a?(Array)
        value.map { |n| resolve_strict_property(n, defs) }
      elsif value.is_a?(Hash)
        resolve_strict_properties(value, defs)
      else
        value
      end
    end
  end
end
