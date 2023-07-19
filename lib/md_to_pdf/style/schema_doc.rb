module MarkdownToPDF
  class StyleSchemaDocsGenerator
    def initialize(schema)
      @schema = schema
      @references = []
      @done = []
    end

    def generate_markdown
      result = build_properties_blocks
      result += build_references
      result += measurement_section
      result.join("\n")
    end

    private

    def build_references
      result = []
      i = 0 # items may get added to @references while iterating, so no .each here
      while i < @references.length
        entry = @references[i]
        i += 1
        result += print_entry(entry[:key], entry[:value]) unless @done.include?(entry[:key])
      end
      result
    end

    def build_properties_blocks
      blocks = []
      @schema['properties'].each do |key, value|
        block = print_entry(key, value, 1)
        block += print_entry_obj_children(key, value, 2)
        blocks.push({ key: key, block: block })
      end
      @schema['patternProperties'].each do |key, value|
        pattern_key = key.sub('^', '')
        default_key = pattern_key.sub('_\d+', '')
        index = blocks.find_index { |b| default_key == b[:key] }
        title = value['title'] || ''
        2.times do |number|
          sub_key = pattern_key.sub('\d+', (number + 1).to_s)
          value['title'] = "#{title} #{number + 1}"
          block = print_entry(sub_key, value)
          block += print_entry_obj_children(sub_key, value, 2)
          blocks.insert(number + index + 1, { key: key, block: block })
        end
      end
      blocks.map { |b| b[:block] }.flatten
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
      @done.push(key)
      result = []
      ref_obj = get_ref(prop) || prop
      title = prio_value(prop['title'], ref_obj['title'])
      result << "\n##{'#' * level} #{title || key}"
      result << "\nKey: `#{key}`"
      type = ref_obj['type']
      # result << "\nType: `#{type}`"
      description = prio_value(prop['description'], ref_obj['description'])
      result << "\n#{description}" if description

      example = prio_value(prop['x-example'], ref_obj['x-example'])
      if example
        result << "\n```yml\n#{example.to_yaml.sub("---\n", '').gsub("\n  - ", "\n    - ")}```"
      end
      result += print_root_prop_object(ref_obj) if type == 'object'
      result
    end

    def print_entry_obj_children(_root_key, root_value, level)
      result = []
      ref_obj = get_ref(root_value)
      props = ref_obj['properties'] || {}
      props.each do |key, value|
        child_ref = get_ref(value) || value
        if child_ref['type'] == 'object' && !@done.include?(key)
          @done.push(key)
          result += print_entry(key, value, level + 1)
        end
      end
      result
    end

    def print_root_prop_object(root_prop)
      result = []
      props = root_prop['properties'] || {}
      result << "\n| Key | Description | Data type |"
      result << "| - | - | - |"
      result += build_prop_rows(props)
      all_of = root_prop['allOf'] || []
      all_of.each do |item|
        ref_obj = get_ref(item, true) || {}
        result << "| … | See [#{ref_obj['title']}](##{generate_id(ref_obj['title'])}) |  |"
      end
      (root_prop['patternProperties'] || []).each do |key, value|
        ref_obj = get_ref(value, true) || value
        key_text = '…'
        if key == '.*'
          key_text = 'your choice'
        end
        result << "| #{key_text} | See [#{ref_obj['title']}](##{generate_id(ref_obj['title'])}) |  |"
      end
      result
    end

    def generate_id(title)
      (title || '').downcase.gsub(' ', '_')
    end

    def build_prop_rows(props)
      result = []
      props.each do |key, prop|
        ref_obj = get_ref(prop) || prop
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
        type = "#{type.join(' or ')}<br/>See [Units](#units)" if type.is_a? Array

        if type == 'object'
          desc << "See [#{title}](##{generate_id(title)})"
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
      result
    end

    def get_ref(ref_parent, include_to_references = false)
      ref = ref_parent['$ref']
      unless ref.nil?
        ref_id = ref.split('/').last
        ref_obj = @schema['$defs'][ref.split('/').last]
        if include_to_references && ref_obj && @references.none? { |item| item[:key] == ref_id }
          @references.push({ key: ref_id, value: ref_obj })
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
