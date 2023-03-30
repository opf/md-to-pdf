module MarkdownToPDF
  module Text
    def data_text(node, opts)
      text_hash(hyphenate(node.string_content), opts)
    end

    def data_strong(node, opts)
      data_node_list(node.to_a, opts.merge({ styles: (opts[:styles] || []) + [:bold] }))
    end

    def data_emph(node, opts)
      data_node_list(node.to_a, opts.merge({ styles: (opts[:styles] || []) + [:italic] }))
    end

    def data_strikethrough(node, opts)
      data_node_list(node.to_a, opts.merge({ styles: (opts[:styles] || []) + [:strikethrough] }))
    end
  end
end
