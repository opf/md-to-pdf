module MarkdownToPDF
  module Options
    def init_options(options)
      @options = def_options.merge(options)
    end

    def options
      @options ||= def_options
    end

    def def_options
      {
        table_page_break_threshold: 80,
        smart_header_threshold: 150,
        auto_generate_header_ids: true
      }
    end

    def option_table_page_break_threshold
      options[:table_page_break_threshold]
    end

    def option_smart_header_threshold
      options[:smart_header_threshold]
    end

    def option_auto_generate_header_ids?
      options[:auto_generate_header_ids]
    end
  end
end
