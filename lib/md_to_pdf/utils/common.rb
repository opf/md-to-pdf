require 'prawn/measurements'

module MarkdownToPDF
  module Common
    include Prawn::Measurements

    def with_block_padding(opts)
      @pdf.move_down(opts[:top_padding]) if opts.key?(:top_padding)
      yield
      @pdf.move_down(opts[:bottom_padding]) if opts.key?(:bottom_padding)
    end

    def with_block_margin(opts)
      @pdf.move_down(opts[:top_margin]) if opts.key?(:top_margin)
      yield
      @pdf.move_down(opts[:bottom_margin]) if opts.key?(:bottom_margin)
    end

    def with_block_padding_all(opts, &block)
      with_block_padding(opts) do
        @pdf.indent(opts[:left_padding] || 0, opts[:right_padding] || 0, &block)
      end
    end

    def with_block_margin_all(opts, &block)
      with_block_margin(opts) do
        @pdf.indent(opts[:left_margin] || 0, opts[:right_margin] || 0, &block)
      end
    end

    def merge_opts(*args)
      result = {}
      args.each { |o| result = result.merge(o) }
      result.compact
    end

    def first_number(*args)
      args.find { |value| !value.nil? }
    end

    def parse_pt(something)
      return nil if something.nil?

      parsed = number_unit(something.to_s)
      value = parsed[:value]
      case parsed[:unit]
      when 'mm'
        mm2pt(value)
      when 'cm'
        cm2pt(value)
      when 'dm'
        dm2pt(value)
      when 'm'
        m2pt(value)
      when 'yd'
        yd2pt(value)
      when 'ft'
        ft2pt(value)
      when 'in'
        in2pt(value)
      else
        value
      end
    end

    def number_unit(string)
      value = string.to_f # => -123.45
      unit = string[/[a-zA-Z]+/] # => "min"
      { value: value, unit: unit }
    end

    def measure_block_padding_height(opts)
      (opts[:top_padding] || 0) + (opts[:bottom_padding] || 0)
    end

    def text_hash(text, opts)
      text = text.to_s.gsub(/\s+/, ' ')
      filter_text_hash(merge_opts({ text: text }, opts))
    end

    def text_hash_raw(text, opts)
      filter_text_hash(merge_opts({ text: text }, opts))
    end

    def filter_text_hash(opts)
      hash = {}
      %i[text styles size character_spacing font color link anchor draw_text_callback callback].each do |key|
        hash[key] = opts[key] if opts.key?(key)
      end
      hash
    end

    def filter_block_hash(opts)
      hash = {}
      %i[align valign mode final_gap leading fallback_fonts direction indent_paragraphs].each do |key|
        hash[key] = opts[key] if opts.key?(key)
      end
      hash
    end

    def add_link_destination(id)
      pdf_dest = @pdf.dest_xyz(0, @pdf.y)
      @pdf.add_dest(id, pdf_dest)
    end

    def draw_formatted_text(data_list, opts, node)
      image_list = data_list.select { |item| item.key?(:image) }
      text_list = data_list.reject { |item| item.key?(:image) }
      @pdf.formatted_text(text_list, filter_block_hash(opts)) unless text_list.empty?
      image_list.each do |item|
        embed_image(item[:image], node, opts.merge({ image_classes: item[:image_classes] }))
      end
    end

    def measure_text_width(text, opts)
      @pdf.save_font do
        @pdf.font(opts[:font], opts)
        @pdf.width_of(text, opts)
      end
    end
  end
end
