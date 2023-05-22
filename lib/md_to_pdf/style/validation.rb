require "json-schema"
require "json"

module MarkdownToPDF
  module StyleValidation
    STYLES_SCHEMA = {
      "type": "object",
      "properties": {
        "fonts": { "$ref": "#/$defs/font_specs" },
        "fallback_font": { "$ref": "#/$defs/fallback_font_spec" },
        "fields_default": { "$ref": "#/$defs/fields_default" },
        "page": { "$ref": "#/$defs/page" },
        "page_header": { "$ref": "#/$defs/page_header_footer" },
        "page_footer": { "$ref": "#/$defs/page_header_footer" },
        "page_logo": { "$ref": "#/$defs/page_logo" },
        "paragraph": { "$ref": "#/$defs/paragraph" },
        "table": { "$ref": "#/$defs/table" },
        "headless_table": { "$ref": "#/$defs/headless_table" },
        "code": { "$ref": "#/$defs/code" },
        "codeblock": { "$ref": "#/$defs/codeblock" },
        "link": { "$ref": "#/$defs/link" },
        "image": { "$ref": "#/$defs/image" },
        "image_classes": { "$ref": "#/$defs/image_classes" },
        "hrule": { "$ref": "#/$defs/hrule" },
        "footnote_reference": { "$ref": "#/$defs/footnote_reference" },
        "footnote_definition": { "$ref": "#/$defs/footnote_definition" },
        "header": { "$ref": "#/$defs/header" },
        "blockquote": { "$ref": "#/$defs/blockquote" },
        "unordered_list": { "$ref": "#/$defs/unordered_list" },
        "unordered_list_point": { "$ref": "#/$defs/unordered_list_point" },
        "task_list": { "$ref": "#/$defs/unordered_list" },
        "task_list_point": { "$ref": "#/$defs/task_list_point" },
        "ordered_list": { "$ref": "#/$defs/ordered_list" },
        "ordered_list_point": { "$ref": "#/$defs/ordered_list_point" },
      },
      "patternProperties": {
        "page_header_.*": { "$ref": "#/$defs/page_header_footer" },
        "page_footer_.*": { "$ref": "#/$defs/page_header_footer" },
        "ordered_list_point_.*": { "$ref": "#/$defs/ordered_list_point" },
        "ordered_list_.*": { "$ref": "#/$defs/ordered_list" },
        "unordered_list_.*": { "$ref": "#/$defs/unordered_list" },
        "unordered_list_point_.*": { "$ref": "#/$defs/unordered_list_point" },
        "header_.*": { "$ref": "#/$defs/header" },
      },
      "required": [],
      "$defs": {
        "font_specs": {
          "type": "array",
          "items": { "$ref": "#/$defs/font_spec" }
        },
        "font_spec": {
          "type": "object",
          "properties": {
            "name": { "type": "string" },
            "pathname": { "type": "string" },
            "regular": { "type": "string" },
            "bold": { "type": "string" },
            "italic": { "type": "string" },
            "bold_italic": { "type": "string" }
          },
          "required": ["name", "pathname", "regular", "bold", "italic", "bold_italic"]
        },
        "fallback_font_spec": {
          "type": "object",
          "properties": {
            "name": { "type": "string" },
            "pathname": { "type": "string" },
            "filename": { "type": "string" }
          },
          "required": ["name", "pathname", "filename"]
        },
        "color": {
          "type": "string",
          "pattern": "^(?:[0-9a-fA-F]{3}){1,2}$"
        },
        "font": {
          "type": "object",
          "properties": {
            "font": { "type": "string" },
            "size": { "type": "number" },
            "character-spacing": { "type": "number" },
            "leading": { "type": "number" },
            "color": { "$ref": "#/$defs/color" },
            "styles": {
              "type": "array",
              "items": { "$ref": "#/$defs/font_style" }
            }
          },
        },
        "font_style": {
          "type": "string",
          "enum": ["bold", "italic", "underline", "superscript", "subscript"]
        },
        "cell_font": {
          "type": "object",
          "properties": {
            "font": { "type": "string" },
            "size": { "type": "number" },
            "character-spacing": { "type": "number" },
            "leading": { "type": "number" },
            "color": { "$ref": "#/$defs/color" },
            "style": { "$ref": "#/$defs/font_style" }
          },
        },
        "page": {
          "type": "object",
          "properties": {
            "page_layout": {
              "type": "string",
              "enum": ["portrait", "landscape"]
            }
          },
          "allOf": [
            { "$ref": "#/$defs/font" },
            { "$ref": "#/$defs/margin" }
          ]
        },
        "page_header_footer": {
          "type": "object",
          "properties": {
            "filter_pages": {
              "type": "array",
              "items": { "type": "number" }
            },
            "align": { "$ref": "#/$defs/alignment" },
            "offset": { "type": "number" },
          },
          "allOf": [
            { "$ref": "#/$defs/font" }
          ]
        },
        "page_logo": {
          "type": "object",
          "properties": {
            "filter_pages": {
              "type": "array",
              "items": { "type": "number" }
            },
            "align": { "$ref": "#/$defs/alignment" },
            "max_width": { "$ref": "#/$defs/measurement" },
            "offset": { "type": "number" },
            "disabled": { "type": "boolean" }
          }
        },
        "margin": {
          "type": "object",
          "properties": {
            "margin": { "$ref": "#/$defs/measurement" },
            "margin_left": { "$ref": "#/$defs/measurement" },
            "margin_right": { "$ref": "#/$defs/measurement" },
            "margin_top": { "$ref": "#/$defs/measurement" },
            "margin_bottom": { "$ref": "#/$defs/measurement" }
          }
        },
        "padding": {
          "type": "object",
          "properties": {
            "padding": { "$ref": "#/$defs/measurement" },
            "padding_left": { "$ref": "#/$defs/measurement" },
            "padding_right": { "$ref": "#/$defs/measurement" },
            "padding_top": { "$ref": "#/$defs/measurement" },
            "padding_bottom": { "$ref": "#/$defs/measurement" }
          }
        },
        "measurement": {
          "type": ["integer", "string"],
          "pattern": "^([0-9\\.]+)(mm|cm|dm|m|in|ft|yr|pt)$"
        },
        "alignment": {
          "type": "string",
          "enum": ["left", "center", "right"]
        },
        "unordered_list": {
          "type": "object",
          "properties": {
            "spacing": { "$ref": "#/$defs/measurement" }
          },
          "allOf": [
            { "$ref": "#/$defs/font" },
            { "$ref": "#/$defs/margin" }
          ]
        },
        "hrule": {
          "type": "object",
          "properties": {
            "line_width": { "$ref": "#/$defs/measurement" }
          },
          "allOf": [
            { "$ref": "#/$defs/margin" }
          ]
        },
        "unordered_list_point": {
          "type": "object",
          "properties": {
            "spacing": { "$ref": "#/$defs/measurement" }
          },
          "allOf": [
            { "$ref": "#/$defs/font" }
          ]
        },
        "task_list_point": {
          "type": "object",
          "properties": {
            "checked": { "type": "string" },
            "unchecked": { "type": "string" },
            "spacing": { "$ref": "#/$defs/measurement" }
          },
          "allOf": [
            { "$ref": "#/$defs/font" }
          ]
        },
        "ordered_list": {
          "type": "object",
          "properties": {
            "spacing": { "$ref": "#/$defs/measurement" },
            "point_inline": { "type": "boolean" }
          },
          "allOf": [
            { "$ref": "#/$defs/font" },
            { "$ref": "#/$defs/margin" }
          ]
        },
        "ordered_list_point": {
          "type": "object",
          "properties": {
            "spacing": { "$ref": "#/$defs/measurement" },
            "alphabetical": { "type": "boolean" },
            "spanning": { "type": "boolean" },
            "template": { "type": "string" }
          },
          "allOf": [
            { "$ref": "#/$defs/font" }
          ]
        },
        "footnote_reference": {
          "type": "object",
          "allOf": [
            { "$ref": "#/$defs/font" },
          ],
        },
        "footnote_definition": {
          "type": "object",
          "properties": {
            "point": {
              "type": "object",
              "allOf": [
                { "$ref": "#/$defs/font" },
              ],
            },
          },
        },
        "link": {
          "type": "object",
          "allOf": [
            { "$ref": "#/$defs/font" },
          ],
        },
        "code": {
          "type": "object",
          "allOf": [
            { "$ref": "#/$defs/font" },
          ],
        },
        "header": {
          "type": "object",
          "allOf": [
            { "$ref": "#/$defs/font" },
            { "$ref": "#/$defs/margin" }
          ]
        },
        "blockquote": {
          "type": "object",
          "allOf": [
            { "$ref": "#/$defs/font" },
            { "$ref": "#/$defs/border" },
            { "$ref": "#/$defs/margin" }
          ]
        },
        "codeblock": {
          "type": "object",
          "properties": {
            "background_color": { "$ref": "#/$defs/color" }
          },
          "allOf": [
            { "$ref": "#/$defs/font" },
            { "$ref": "#/$defs/padding" },
            { "$ref": "#/$defs/margin" }
          ]
        },
        "table": {
          "type": "object",
          "properties": {
            "auto_width": { "type": "boolean" },
            "header": { "$ref": "#/$defs/table_header" },
            "cell": { "$ref": "#/$defs/table_cell" },
          },
          "allOf": [
            { "$ref": "#/$defs/margin" },
            { "$ref": "#/$defs/border" }
          ]
        },
        "headless_table": {
          "type": "object",
          "properties": {
            "auto_width": { "type": "boolean" },
            "cell": { "$ref": "#/$defs/table_cell" },
          },
          "allOf": [
            { "$ref": "#/$defs/margin" },
            { "$ref": "#/$defs/border" }
          ]
        },
        "table_cell": {
          "type": "object",
          "properties": {
            "border-width": {
              "type": "string"
            },
            "padding-left": {
              "type": "string"
            },
            "padding-right": {
              "type": "string"
            },
            "padding-top": {
              "type": "string"
            },
            "padding-bottom": {
              "type": "string"
            },
            "size": {
              "type": "number"
            }
          },
          "allOf": [
            { "$ref": "#/$defs/cell_font" }
          ]
        },
        "table_header": {
          "type": "object",
          "properties": {
            "background-color": { "$ref": "#/$defs/color" },
            "no_repeating": { "type": "boolean" }
          },
          "allOf": [
            { "$ref": "#/$defs/cell_font" }
          ]
        },
        "paragraph": {
          "type": "object",
          "properties": {
            "align": {
              "type": "string",
              "enum": ["left", "center", "right", "justify"]
            }
          },
          "allOf": [
            { "$ref": "#/$defs/font" },
            { "$ref": "#/$defs/margin" }
          ]
        },
        "image": {
          "type": "object",
          "properties": {
            "max_width": { "$ref": "#/$defs/measurement" },
            "align": { "$ref": "#/$defs/alignment" }
          },
          "allOf": [
            { "$ref": "#/$defs/margin" }
          ]
        },
        "border": {
          "type": "object",
          "properties": {
            "border_width": { "$ref": "#/$defs/measurement" },
            "border_width_left": { "$ref": "#/$defs/measurement" },
            "border_width_top": { "$ref": "#/$defs/measurement" },
            "border_width_right": { "$ref": "#/$defs/measurement" },
            "border_width_bottom": { "$ref": "#/$defs/measurement" },
            "border_color": { "$ref": "#/$defs/color" },
            "border_color_left": { "$ref": "#/$defs/color" },
            "border_color_top": { "$ref": "#/$defs/color" },
            "border_color_right": { "$ref": "#/$defs/color" },
            "border_color_bottom": { "$ref": "#/$defs/color" },
            "no_border": { "type": "boolean" },
            "no_border_left": { "type": "boolean" },
            "no_border_top": { "type": "boolean" },
            "no_border_right": { "type": "boolean" },
            "no_border_bottom": { "type": "boolean" }
          },
          "allOf": [
            { "$ref": "#/$defs/margin" }
          ]
        },
        "image_classes": {
          "type": "object",
          "patternProperties": {
            ".*": { "$ref": "#/$defs/image" }
          }
        },
        "fields_default": {
          "type": "object",
          "properties": {
            "pdf_language": { "type": "string" },
            "pdf_header": { "type": "string" },
            "pdf_footer": { "type": "string" },
            "pdf_header_logo": { "type": "string" },
            "pdf_hyphenation": { "type": "boolean" },
            "pdf_fields": {
              "type": "object",
              "patternProperties": {
                ".*": { "type": ["string", "number"] }
              }
            }
          }
        }
      }
    }
    FRONTMATTER_SCHEMA = {
      "type": "object",
      "properties": {
        "pdf_language": { "type": "string" },
        "pdf_header": { "type": "string" },
        "pdf_footer": { "type": "string" },
        "pdf_header_logo": { "type": "string" },
        "pdf_hyphenation": { "type": "boolean" },
        "pdf_fields": {
          "type": "object",
          "patternProperties": {
            ".*": { "type": ["string", "number"] }
          }
        }
      }
    }

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
      errors = JSON::Validator.fully_validate(schema, yml, :validate_schema => true)
      if errors.length > 0
        puts errors.join("\n")
        throw errors.join("\n")
      end
    end

    private

    def resolve_strict_property(value, defs)
      if value.kind_of?(Array)
        value.map { |n| resolve_strict_property(n, defs) }
      elsif value.kind_of?(Hash)
        resolve_strict_properties(value, defs)
      else
        value
      end
    end

    def resolve_strict_properties(node, defs)
      return nil if node.nil?

      ref = node['$ref']
      result = unless ref.nil?
                 def_name = ref.sub('#/$defs/', '')
                 resolve_strict_properties(defs[def_name], defs)
               else
                 clone = {}
                 node.each_key do |key|
                   clone[key] = resolve_strict_property(node[key], defs)
                 end
                 clone
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
