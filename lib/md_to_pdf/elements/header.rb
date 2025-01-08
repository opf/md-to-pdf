module MarkdownToPDF
  module Header
    def measure_header(node, opts)
      header_opts = build_header_opts(node.header_level, opts)
      data = data_node_children(node, header_opts).reject { |item| item.key?(:image) }
      measure_block_padding_height(opts) +
        @pdf.height_of_formatted(data, filter_block_hash(header_opts))
    end

    def draw_header(node, opts)
      header_opts = build_header_opts(node.header_level, opts)
      header_opts[:top_padding] = 0 if is_first_on_page?
      generate_header_id(node) if option_auto_generate_header_ids?
      with_block_padding(header_opts) do
        draw_formatted_text(data_node_children(node, header_opts), header_opts, node)
      end
    end

    private

    def is_first_on_page?
      space_above = @pdf.bounds.absolute_top - @pdf.y
      space_above < 10
    end

    def generate_header_id(node)
      content = node.to_plaintext.gsub("\n", '').gsub(' ', ' ')
      id = generate_id(content)
      add_link_destination(id)
    end

    def build_header_opts(header_level, opts)
      style = @styles.headline
      style = style.merge(@styles.headline_level(header_level))
      h_opts = merge_opts(opts_font(style, opts), opts_padding(style))
      opts.merge(h_opts)
    end
  end
end
