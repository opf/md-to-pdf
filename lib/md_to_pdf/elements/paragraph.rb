module MarkdownToPDF
  module Paragraph
    def draw_paragraph(node, opts)
      return if handle_first_child_image(node, opts)

      p_opts = build_paragraph_opts(opts)
      p_padding_opts = build_paragraph_padding_opts(opts)
      with_block_padding_all(p_padding_opts) do
        convert_paragraph_nodes(node, p_opts, opts)
      end
    end

    private

    def convert_paragraph_nodes(node, p_opts, opts)
      nodes = []
      n = node.first_child
      until n.nil?
        test = n
        n = n.next
        if test.type == :image
          unless nodes.empty?
            draw_formatted_text(data_node_list(nodes, p_opts), p_opts, node)
            nodes = []
          end
          draw_standalone_image(test, opts)
        else
          nodes.push(test)
        end
      end
      draw_formatted_text(data_node_list(nodes, p_opts), p_opts, node) unless nodes.empty?
    end

    def build_paragraph_opts(opts)
      style = @styles.paragraph
      merge_opts(opts, opts_paragraph_align(style), opts_font(style, opts))
    end

    def build_paragraph_padding_opts(opts)
      opts[:force_paragraph] || opts_padding(@styles.paragraph)
    end

    def handle_first_child_image(node, opts)
      n = node.first_child
      return false unless n && n.type == :image

      image_opts = opts.dup
      nn = n.next
      if nn && nn.type == :text && nn.string_content.start_with?('{:') && nn.string_content.end_with?('}')
        image_classes = parse_attribute_class(nn.string_content.slice(2..-2))
        image_opts[:image_classes] = image_classes if image_classes
        nn.delete
      end
      draw_standalone_image(n, image_opts)
      true
    end
  end
end
