require 'prawn/table'

module MarkdownToPDF
  module Blockquote
    def data_blockquote(node, opts)
      result = []
      case node.type
      when :paragraph
        result.concat(data_blockquote_paragraph(node, opts, result.empty?))
      when :blockquote
        result.push(data_blockquote_quote(node, opts))
      when :list
        cells = data_blockquote_list(node, opts)
        cells.each { |cell| result.push([cell]) }
      else
        warn("Unsupported node.type #{node.type} in data_blockquote()", node.type, node)
      end
      result
    end

    def draw_blockquote(node, opts)
      cell_style_opts = blockquote_opts(opts)
      margin_opts = blockquote_margins_opts(opts)
      data = blockquote_data_rows(node, cell_style_opts)
      return if data.empty?

      with_block_margin_all(margin_opts) do
        draw_blockquote_table(data, cell_style_opts[:alert_style_opts] || cell_style_opts)
      end
    end

    private

    def data_blockquote_paragraph(node, opts, is_first)
      node.to_a.each do |child|
        if child.type == :softbreak
          new_node = Markly::Node.new(:linebreak)
          child.insert_before(new_node)
          child.delete
        end
      end
      current_opts = opts
      alert_type = nil
      alert_title = nil
      if is_first && node.first_child && node.first_child.type == :text
        line = node.first_child.string_content
        line.match(/^\[!([A-Z]*)(?::([^\]]*))?\]/) do |m|
          if MarkdownToPDF::Fonts::ALERT_OCTICONS.key?(m[1].to_sym)
            alert_type = m[1].to_sym
            alert_title = m[2] || alert_type.to_s.capitalize
            opts[:alert_style_opts] = opts_alert_table_cell(@styles.alert_styles(alert_type), opts)
            current_opts = opts[:alert_style_opts]
          end
        end
      end

      cell_data = data_node_children(node, current_opts)
      if alert_type
        cell_data[0][:text] = "#{alert_title.strip}\n"
        icon = MarkdownToPDF::Fonts::ALERT_OCTICONS[alert_type]
        if current_opts[:alert_color]
          icon = "<color rgb=\"#{current_opts[:alert_color]}\">#{icon}</color>"
          cell_data[0][:color] = current_opts[:alert_color]
        end
        text = "<font name=\"#{MarkdownToPDF::Fonts::ALERT_OCTICONS_FONTNAME}\">#{icon}</font> "
        cell_data.insert(0, { text: text, raw: true })
      end
      [[make_table_cell_or_subtable(cell_data, current_opts, :left, 1)]]
    end

    def data_blockquote_list(node, opts)
      result = []
      node.to_a.select { |sub| sub.type == :list_item }.each do |sub|
        sub.to_a.each do |paragraph|
          cell_data = data_node_children(paragraph, opts)
          unless cell_data.empty?
            cell = make_table_cell_or_subtable(cell_data, opts, :left, 1)
            result.push(cell)
          end
        end
      end
      result
    end

    def data_blockquote_quote(node, opts)
      subtable_rows = []
      node.each do |child|
        subtable_data = data_blockquote(child, opts)
        subtable_rows.concat(subtable_data)
      end
      return [] if subtable_rows.empty?

      subtable = @pdf.make_table(subtable_rows, cell_style: opts) do
        (0..(row_length)).each do |i|
          rows(i).padding_left = 20
          rows(i).padding_top = 0
          rows(i).padding_bottom = 0
          rows(i).padding_right = 0
        end
      end
      [subtable]
    end

    def draw_blockquote_table(data, cell_style_opts)
      table = @pdf.make_table(data, width: @pdf.bounds.right, cell_style: cell_style_opts) do
        (0..(row_length - 2)).each do |i|
          rows(i).padding_bottom = cell_style_opts[:leading] || 0
        end
        (1..(row_length)).each do |i|
          rows(i).padding_top = cell_style_opts[:leading] || 0
        end
      end

      space_from_bottom = @pdf.y - @pdf.bounds.bottom
      @pdf.start_new_page if space_from_bottom < option_smart_blockquote_threshold

      table.draw
    end

    def blockquote_data_rows(node, cell_style_opts)
      data_rows = []
      node.each do |row|
        data_rows.concat(data_blockquote(row, cell_style_opts))
      end
      data_rows
    end

    def blockquote_opts(opts)
      style = @styles.blockquote
      opts_table_cell(style, opts)
    end

    def blockquote_margins_opts(_opts)
      style = @styles.blockquote
      opts_margin(style)
    end
  end
end
