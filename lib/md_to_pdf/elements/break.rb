module MarkdownToPDF
  module Break
    def data_softbreak(_node, opts)
      text_hash_raw(" ", opts)
    end

    def data_linebreak(_node, opts)
      text_hash_raw("\n", opts)
    end
  end
end
