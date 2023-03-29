module MarkdownToPDF
  module Link
    def data_link(node, opts)
      link_opts = build_link_opts(opts)
      link = node.url
      if link.start_with?('#')
        link_opts[:anchor] = link.sub(/\A#/, '')
      else
        link_opts[:link] = link
      end
      data_node_children(node, link_opts)
    end

    private

    def build_link_opts(opts)
      style = @styles.link
      opts_font(style, opts)
    end
  end
end
