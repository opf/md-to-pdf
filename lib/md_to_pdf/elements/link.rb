module MarkdownToPDF
  module Link
    def data_link(node, opts)
      link_opts = link_opts(node.url, opts)
      data_node_children(node, link_opts)
    end

    def link_opts(url, opts)
      return opts if url.nil?

      link_opts = build_link_opts(opts)
      if url.start_with?('#')
        link_opts[:anchor] = url.sub(/\A#/, '')
      else
        link_opts[:link] = url
      end
      link_opts
    end

    def remove_link_opts(opts)
      link_opts = opts.dup
      link_opts.delete(:anchor)
      link_opts.delete(:link)
      link_opts
    end

    private

    def build_link_opts(opts)
      style = @styles.link
      opts_font(style, opts)
    end
  end
end
