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
      return if image_file.nil?

      image_obj, image_info = @pdf.build_image_object(image_file)
      image_margin_opts, image_opts = build_image_settings(opts, image_info)

      with_block_margin(image_margin_opts) do
        if image_opts[:position] == :right
          @pdf.float { @pdf.embed_image(image_obj, image_info, image_opts) }
        else
          @pdf.embed_image(image_obj, image_info, image_opts)
        end
      end
    end

    private

    def build_image_settings(opts, image_info)
      style = build_image_style(opts)
      image_margin_opts = opts_margin(style)
      image_opts = build_image_opts(style, image_info, image_margin_opts, opts)
      [image_margin_opts, image_opts]
    end

    def build_image_opts(style, image_info, image_margin_opts, opts)
      max_width = opt_image_max_width(style)
      options = opts_image(style)
      width = @pdf.bounds.width - (image_margin_opts[:left_margin] || 0) - (image_margin_opts[:right_margin] || 0)
      width = [max_width, width].min unless max_width.nil?
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
