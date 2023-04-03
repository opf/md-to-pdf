module MarkdownToPDF
  module External
    def image_url_to_local_file(url, node)
      return nil if url.nil? || url.empty?

      validate_image(url, node)
    end

    def hyphenate(text)
      @hyphens.hyphenate(text)
    end

    def auto_generate_header_ids?
      true
    end

    def handle_unknown_inline_html_tag(tag, node, opts)
      warn("data_inlinehtml; Html tag currently unsupported.", tag.name, node)
      # [array of pdf data, options]
      [[], opts]
    end

    def handle_unknown_html_tag(tag, node, opts)
      warn("draw_html; Html tag on root level currently unsupported.", tag.name, node)
      # [continue walking the html children, options]
      [true, opts]
    end

    def warn(text, element, node)
      puts "WARNING: #{text}\nGot #{element} at #{node.sourcepos.inspect}\n\n"
    end

    private

    def validate_image(url, node)
      if url !~ /\.jpe?g$|\.png$/
        warn(
          "Requested to render images that are potentially not a JPEG or PNG.\n" \
          "The image might not be present if it's not in one of these formats.",
          url, node
        )
        return nil
      end
      if url.start_with?('http:', 'https:')
        warn("Images must be local", url, node)
        return nil
      end

      image_file = File.expand_path(File.join(@images_path, url))
      unless File.exist?(image_file)
        image_file = File.expand_path(File.join(@styling_images_path, url))
        unless File.exist?(image_file)
          warn("Image file not found", image_file, node)
          return nil
        end
      end
      image_file
    end

  end
end
