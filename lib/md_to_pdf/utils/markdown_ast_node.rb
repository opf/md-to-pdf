module MarkdownToPDF
  module MarkdownASTNode
    def draw_node(node, opts, smart_headers = false)
      draw_node_list(node.to_a, opts, smart_headers)
    end

    def draw_node_list(list, opts, smart_headers = false)
      list_opts = opts.dup
      return smart_render_node_list(list, list_opts) if smart_headers

      list.each { |inner_node| draw_node_by_type(inner_node, list_opts) }
    end

    def data_node(node, opts)
      case node.type
      when :text
        data_text(node, opts)
      when :strong
        data_strong(node, opts)
      when :emph
        data_emph(node, opts)
      when :strikethrough
        data_strikethrough(node, opts)
      when :link
        data_link(node, opts)
      when :image
        data_image(node, opts)
      when :code
        data_code(node, opts)
      when :inline_html, :html
        data_inlinehtml(node, opts)
      when :footnote_reference
        data_footnote_reference(node, opts)
      when :softbreak
        data_softbreak(node, opts)
      when :linebreak
        data_linebreak(node, opts)
      when :footnote_definition
        draw_footnote_definition(node, opts)
      else
        warn("Unsupported node.type #{node.type} in convert_data()", node.type, node)
        nil
      end
    end

    def data_node_children(node, opts)
      data_node_list(node.to_a, opts)
    end

    def data_node_list(list, opts)
      list_opts = opts.dup
      result = []
      list.each do |inner_node|
        new_opts = inner_node.type == :inline_html ? html_tag_to_font_style(inner_node.string_content, list_opts) : nil
        if new_opts
          list_opts = new_opts
        else
          result.push(data_node(inner_node, list_opts))
        end
      end
      result.flatten.compact
    end

    private

    def smart_render_headers(list, opts, threshold)
      return if list.empty?

      height = 0
      list.each do |header_node|
        height += measure_header(header_node, opts)
      end

      space_from_bottom = @pdf.y - @pdf.bounds.bottom - height
      if space_from_bottom < threshold
        @pdf.start_new_page
      end
      list.each do |header_node|
        draw_header(header_node, opts)
      end
    end

    def smart_render_node_list(list, opts)
      # outline
      # 1. collect consecutive headers
      # 2. measure headers
      # 3. if not %threshold% free space on page left, create new page
      # 4. render headers
      # 5. render items
      # 6. goto 1.
      threshold = option_smart_header_threshold
      header_nodes = []
      list.each do |inner_node|
        if inner_node.type == :header
          header_nodes.push(inner_node)
        else
          smart_render_headers(header_nodes, opts, threshold)
          header_nodes = []
          draw_node_by_type(inner_node, opts)
        end
      end
      smart_render_headers(header_nodes, opts, threshold)
    end

    def draw_node_by_type(node, opts)
      case node.type
      when :header
        draw_header(node, opts)
      when :paragraph
        draw_paragraph(node, opts)
      when :list
        draw_list(node, opts)
      when :list_item
        draw_listitem(node, opts)
      when :table
        draw_table(node, opts)
      when :blockquote
        draw_blockquote(node, opts)
      when :code_block
        draw_codeblock(node, opts)
      when :hrule
        draw_hrule(node, opts)
      when :image
        draw_image(node, opts)
      when :html
        draw_html(node, opts)
      when :footnote_definition
        draw_footnote_definition(node, opts)
      else
        warn("Unsupported node.type #{node.type} in draw_node_by_type(node)", node.type, node)
        nil
      end
    end
  end
end
