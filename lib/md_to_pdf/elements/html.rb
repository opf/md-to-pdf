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
      end
    end

    def draw_html(node, opts)
      html = node.string_content.gsub("\n", '').strip
      parsed_data = Nokogiri::HTML.fragment(html)
      parsed_data.children.each do |tag|
        case tag.name
        when 'img'
          embed_image(tag.attr('src'), node, opts.merge({ image_classes: tag.attr('class') }))
        when 'text'
          @pdf.formatted_text([text_hash(tag.text, opts)])
        when 'comment'
          # ignore html comments
        when 'br'
          @pdf.formatted_text([text_hash_raw("\n", opts)])
        when 'br-page'
          @pdf.start_new_page
        else
          warn("WARNING: draw_html; Html tag on root level currently unsupported.", tag.name, node)
        end
      end
    end

    def data_inlinehtml(node, opts)
      html = node.string_content
      parsed_data = Nokogiri::HTML.fragment(html)
      result = []
      parsed_data.children.each do |tag|
        case tag.name
        when 'text'
          result.push(text_hash(tag.text, opts))
        when 'comment'
          # ignore html comments
        when 'br'
          result.push(text_hash_raw("\n", opts))
        else
          warn("WARNING: data_inlinehtml; Html tag currently unsupported.", tag.name, node)
        end
      end
      result
    end

    private

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
