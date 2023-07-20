module MarkdownToPDF
  class StyleSchemaDocsGenerator
    def initialize(schema)
      @schema = schema
      @references = []
      @done = []
    end

    def generate_markdown
      blocks = []
      build_blocks(@schema, blocks)
      build_reference_blocks(blocks)
      root = build_entry('', @schema, true)
      result = root[:block]
      result += blocks.sort_by { |b| b[:title] }.map { |b| b[:block] }.flatten
      result += measurement_section
      result.join("\n")
    end

    private

    def build_children_blocks(node, blocks)
      ref_node = get_ref(node) || node
      (ref_node['properties'] || {}).each do |key, value|
        if value["$ref"]
          build_children_blocks(value, blocks)
        elsif value["type"] == 'object'
          block = build_entry(key, value)
          blocks.push(block)
          build_children_blocks(value, blocks)
        end
      end
      (ref_node['patternProperties'] || {}).each do |key, value|
        if value["$ref"]
          build_children_blocks(value, blocks)
        elsif value["type"] == 'object'
          block = build_entry(format_pattern_prop_key(key, 'x'), value)
          blocks.push(block)
          build_children_blocks(value, blocks)
        end
      end
    end

    def build_blocks(node, blocks)
      (node['properties'] || {}).each do |key, value|
        block = build_entry(key, value)
        blocks.push(block)
        build_children_blocks(value, blocks)
      end
      (node['patternProperties'] || {}).each do |key, value|
        block = build_entry(format_pattern_prop_key(key), value)
        blocks.push(block)
        build_children_blocks(value, blocks)
      end
    end

    def format_pattern_prop_key(key, char = 'x')
      key.sub('^', '').sub('\d+', char)
    end

    def build_reference_blocks(blocks)
      result = []
      i = 0 # items may get added to @references while iterating, so no .each here
      while i < @references.length
        entry = @references[i]
        i += 1
        unless @done.include?(entry[:value])
          block = build_entry(entry[:key], entry[:value])
          blocks.push(block)
        end
      end
      result
    end

    def build_entry(key, prop, is_root = false)
      level = is_root ? 1 : 2
      result = []
      ref_obj = get_ref(prop) || prop
      title = prio_value(prop['title'], ref_obj['title'])
      result << "\n#{'#' * level} #{title || key}"
      type = ref_obj['type']
      description = prio_value(prop['description'], ref_obj['description'])
      result << "\n#{description}" if description
      result << "\nKey: `#{key}`" unless key.empty?

      example = prio_value(prop['x-example'], ref_obj['x-example'])
      if example
        result << "\nExample:\n```yml\n#{example.to_yaml.sub("---\n", '').gsub("\n  - ", "\n    - ")}```"
      end
      result += print_prop_table(ref_obj) if type == 'object'
      result
      { key: key, block: result, title: title || key }
    end

    def print_prop_table(root_prop)
      result = []
      result << "\n| Key | Description | Data type |"
      result << "| - | - | - |"
      (root_prop['properties'] || {}).each do |key, prop|
        ref_obj = get_ref(prop, true) || prop
        desc = []
        title = prio_value(prop['title'], ref_obj['title'])
        desc << "**#{title}**" if title
        description = prio_value(prop['description'], ref_obj['description'])
        desc << description if description

        examples = prio_value(prop['examples'], ref_obj['examples']) || []
        if examples.length == 1
          desc << "Example: `#{examples[0]}`"
        elsif examples.length > 1
          desc << "Examples: #{examples.map { |entry| "`#{entry}`" }.join(', ')}"
        end
        enum = prio_value(prop['enum'], ref_obj['enum']) || []
        unless enum.empty?
          desc << "Valid values:"
          desc << enum.map { |entry| "`#{entry}`" }.join(', ')
        end

        type = ref_obj['type']
        type = "#{type.join(' or ')}<br/>#{link_to_title('Units')}" if type.is_a? Array

        if type == 'object'
          desc << link_to_title(ref_obj['title'])
        end

        if type == 'array'
          item_spec = ref_obj['items']
          item_spec_ref_obj = get_ref(item_spec) || item_spec
          sub_type = (item_spec_ref_obj || item_spec)['type']
          type += " of #{sub_type}"
          unless item_spec_ref_obj.nil?
            examples = prio_value(item_spec['examples'], item_spec_ref_obj['examples']) || []
            desc << "Example: `[#{examples[0]}]`" unless examples.empty?
          end
          enum = prio_value(item_spec_ref_obj['enum'], item_spec['enum']) || []
          unless enum.empty?
            desc << "Valid values:"
            desc << enum.map { |entry| "`#{entry}`" }.join(', ')
          end
        end

        result << "| `#{key}` | #{desc.join('<br/>')} | #{type} |"
      end
      (root_prop['allOf'] || []).each do |item|
        ref_obj = get_ref(item, true) || item
        title = prio_value(item['title'], ref_obj['title'])
        description = link_to_title(ref_obj['title'])
        description = "#{title}<br/>#{description}" if title && title != ref_obj['title']
        result << "| … | #{description} |  |"
      end
      (root_prop['patternProperties'] || []).each do |key, value|
        ref_obj = get_ref(value, true) || value
        title = prio_value(value['title'], ref_obj['title'])
        key_text = key
        if key == '.*'
          key_text = 'your choice'
        elsif key.include?('\d+')
          key_text = [1, 2, 'x'].map { |num| "`#{format_pattern_prop_key(key, num.to_s)}`" }.join('<br/>')
        end
        description = link_to_title(ref_obj['title'])
        description = "#{title}<br/>#{description}" if title && title != ref_obj['title']
        result << "| #{key_text} | #{description} | #{ref_obj['type']} |"
      end
      result
    end

    def link_to_title(title)
      return '' if title.nil? || title.empty?

      "See [#{title}](##{generate_id(title)})"
    end

    def measurement_section
      result = []
      result << "## Units\n"
      result << "available units are\n"
      result << "`mm` - Millimeter, `cm` - Centimeter, `dm` - Decimeter, `m` - Meter\n"
      result << "`in` - Inch, `ft` - Feet, `yr` - Yard\n"
      result << "`pt` - [Postscript point](https://en.wikipedia.org/wiki/Point_(typography)#Desktop_publishing_point) (default if no unit is used)"
      result
    end

    def print_entry(key, prop, level = 1)
      result = []
      ref_obj = get_ref(prop) || prop
      @done.push(ref_obj)
      title = prio_value(prop['title'], ref_obj['title'])
      result << "\n##{'#' * level} #{title || key}"
      type = ref_obj['type']
      # result << "\nType: `#{type}`"
      description = prio_value(prop['description'], ref_obj['description'])
      result << "\n#{description}" if description
      result << "\nKey: `#{key}`"
      example = prio_value(prop['x-example'], ref_obj['x-example'])
      if example
        result << "\nExample:\n```yml\n#{example.to_yaml.sub("---\n", '').gsub("\n  - ", "\n    - ")}```"
      end
      result += print_prop_table(ref_obj) if type == 'object'
      result
    end

    def generate_id(title)
      id = (title || '').downcase
      id.gsub!(/[^\p{Word}\- ]/u, '') # remove punctuation
      id.tr!(' ', '-') # replace spaces with dash
      id
    end

    def get_ref(ref_parent, include_to_references = false)
      ref = ref_parent['$ref']
      unless ref.nil?
        ref_id = ref.split('/').last
        ref_obj = @schema['$defs'][ref.split('/').last]
        if include_to_references && ref_obj && ref_obj["type"] == "object" && @references.none? { |item| item[:value] == ref_obj }
          @references.push({ key: ref_id, value: ref_obj, title: ref_obj["title"] || ref_id })
        end
        ref_obj
      end
    end

    def prio_value(first, second)
      return first unless first.nil?
      return second unless second.nil?

      nil
    end
  end
end
