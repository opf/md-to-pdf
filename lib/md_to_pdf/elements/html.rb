module MarkdownToPDF
  module HTML
    def html_tag_to_font_style(tag, opts)
      case tag.downcase
      when '<u>'
        add_font_style(opts, :underline)
      when '</u>'
        remove_font_style(opts, :underline)
      when '<b>'
        add_font_style(opts, :bold)
      when '</b>'
        remove_font_style(opts, :bold)
      when '<i>'
        add_font_style(opts, :italic)
      when '</i>'
        remove_font_style(opts, :italic)
      when '<sub>'
        add_font_style(opts, :sub)
      when '</sub>'
        remove_font_style(opts, :sub)
      when '<sup>'
        add_font_style(opts, :sup)
      when '</sup>'
        remove_font_style(opts, :sup)
      when '<strikethrough>'
        add_font_style(opts, :strikethrough)
      when '</strikethrough>'
        remove_font_style(opts, :strikethrough)
      when '</a>'
        result = remove_link_opts(opts)
        result[:original_opts] || result
      else
        node = Nokogiri::HTML.fragment(tag).children[0]
        if node && node.name == 'a' && node.attr('href')
          result = link_opts(node.attr('href'), opts)
          result[:original_opts] = opts
          result
        end
      end
    end

    def draw_html(node, opts)
      html = node.string_content.gsub("\n", '').strip
      parsed_data = Nokogiri::HTML.fragment(html)
      draw_html_tag(parsed_data, node, opts)
    end

    def data_inlinehtml(node, opts)
      html = node.string_content
      if html.downcase == '</a>'
        remove_link_opts(opts)
        return []
      end
      parsed_data = Nokogiri::HTML.fragment(html)
      data_inlinehtml_tag(parsed_data, node, opts)
    end

    private

    def data_inlinehtml_tag(tag, node, opts)
      result = []
      current_opts = opts
      tag.children.each do |sub|
        case sub.name
        when 'text'
          result.push(text_hash(sub.text, current_opts))
        when 'a'
          url = sub.attr('href')
          unless url.nil?
            if url.start_with?('#')
              opts[:anchor] = url.sub(/\A#/, '')
            else
              opts[:link] = url
            end
          end
        when 'comment'
          # ignore html comments
        when 'br'
          result.push(text_hash_raw("\n", current_opts))
        else
          data_array, current_opts = handle_unknown_inline_html_tag(sub, node, current_opts)
          result.concat(data_array)
        end
      end
      result
    end

    def draw_html_tag(tag, node, opts)
      current_opts = opts
      tag.children.each do |sub|
        case sub.name
        when 'img'
          embed_image(sub.attr('src'), node, current_opts.merge({ image_classes: sub.attr('class') }))
        when 'text'
          @pdf.formatted_text([text_hash(sub.text, current_opts)])
        when 'a'
          draw_html_tag(sub, node, link_opts(sub.attr('href'), current_opts))
        when 'comment'
          # ignore html comments
        when 'br'
          @pdf.formatted_text([text_hash_raw("\n", current_opts)])
        when 'br-page'
          @pdf.start_new_page
        else
          process_children, current_opts = handle_unknown_html_tag(sub, node, current_opts)
          draw_html_tag(sub, node, opts) if process_children
        end
      end
    end

    def cell_inline_formatting(cell_data_part)
      # https://prawnpdf.org/docs/0.11.1/Prawn/Text.html internal format
      value = cell_inline_formatting_data(cell_data_part)
      cell_inline_formatting_styles(cell_data_part, value)
    end

    def cell_inline_formatting_styles(cell_data_part, value)
      styles = cell_data_part[:styles]
      if styles
        value = "<b>#{value}</b>" if styles.include?(:bold)
        value = "<i>#{value}</i>" if styles.include?(:italic)
        value = "<u>#{value}</u>" if styles.include?(:underline)
        value = "<strikethrough>#{value}</strikethrough>" if styles.include?(:strikethrough)
        value = "<sub>#{value}</sub>" if styles.include?(:sub)
        value = "<sup>#{value}</sup>" if styles.include?(:sup)
      end
      value
    end

    def cell_inline_formatting_data(cell_data_part)
      value = cell_data_part[:text] || ''
      value = "<link href=\"#{cell_data_part[:link]}\">#{value}</link>" if cell_data_part.key?(:link)
      value = "<link anchor=\"#{cell_data_part[:anchor]}\">#{value}</link>" if cell_data_part.key?(:anchor)
      value = "<color rgb=\"#{cell_data_part[:color]}\">#{value}</color>" if cell_data_part.include?(:color)
      value = "<font size=\"#{cell_data_part[:size]}\">#{value}</font>" if cell_data_part.key?(:size)
      if cell_data_part.key?(:character_spacing)
        value = "<font character_spacing=\"#{cell_data_part[:character_spacing]}\">#{value}</font>"
      end
      value = "<font name=\"#{cell_data_part[:font]}\">#{value}</font>" if cell_data_part.key?(:font)
      value
    end

    def add_font_style(opts, style)
      merge_opts(opts, { styles: (opts[:styles] || []) + [style] })
    end

    def remove_font_style(opts, style)
      merge_opts(opts, { styles: (opts[:styles] || []) - [style] })
    end
  end
end