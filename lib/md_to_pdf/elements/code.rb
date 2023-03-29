module MarkdownToPDF
  module Code
    def data_code(node, opts)
      text_hash(node.string_content, code_opts(opts))
    end

    private

    def code_opts(opts)
      opts_font(@styles.code, opts)
    end
  end
end
