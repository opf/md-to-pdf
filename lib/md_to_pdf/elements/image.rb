module MarkdownToPDF
  module Image
    def draw_image(node, _opts)
      warn("Rendering span/table images is currently not supported", "img", node)
      nil
    end

    def data_image(node, _opts)
      { image: node.url } if node.url
    end

    def draw_standalone_image(node, opts)
      embed_image(node.url, node, opts)
    end

    def embed_image(url, node, opts)
      image_file = image_url_to_local_file(url, node)
      return if image_file.nil? || image_file.empty?

      style = build_image_style(opts)
      image_obj, image_info = @pdf.build_image_object(image_file)
      image_margin_opts, image_opts = build_image_settings(style, image_info, opts)
      image_title = get_image_title(opts, node)

      with_block_margin(image_margin_opts) do
        if image_opts[:position] == :right
          @pdf.float { @pdf.embed_image(image_obj, image_info, image_opts) }
        else
          @pdf.embed_image(image_obj, image_info, image_opts)
        end
        draw_image_caption(image_title, style, opts) unless image_title.nil?
      end
    end

    private

    def draw_image_caption(caption, image_style, opts)
      style = image_style[:caption] || {}
      caption_opts = merge_opts(opts, opts_paragraph_align(style), opts_font(style, opts))
      with_block_padding_all(opts_padding(style)) do
        @pdf.formatted_text([text_hash(caption, caption_opts)], filter_block_hash(caption_opts))
      end
    end

    def get_image_title(opts, node)
      return opts[:image_caption] unless opts[:image_caption].nil?

      node.title if node.type == :image && !node.title.nil?
    end

    def build_image_settings(style, image_info, opts)
      image_margin_opts = opts_margin(style)
      image_opts = build_image_opts(style, image_info, image_margin_opts, opts)
      [image_margin_opts, image_opts]
    end

    def build_image_opts(style, image_info, image_margin_opts, opts)
      max_width = opt_image_max_width(style)
      options = opts_image(style)
      width = @pdf.bounds.width - (image_margin_opts[:left_margin] || 0) - (image_margin_opts[:right_margin] || 0)
      width = [max_width, width].min unless max_width.nil?
      width = [image_info.width, width].min
      options[:scale] = [width / image_info.width.to_f, 1].min
      options[:position] = :right if (opts[:image_classes] || '') =~ /\bright\b/
      options
    end

    def build_image_style(opts)
      style = @styles.image
      image_classes = (opts[:image_classes] || '').split
      image_classes.each do |image_class|
        style = style.merge(@styles.image_class(image_class))
      end
      style
    end
  end
end
