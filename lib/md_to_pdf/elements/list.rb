module MarkdownToPDF
  module List
    def draw_list(node, opts)
      list = list_settings(node, opts)
      points = point_settings(node, list)
      with_block_padding_all(list[:opts_padding]) do
        node.each_with_index do |li, index|
          convert_list_entry(li, index + list[:list_start], points, list)
        end
      end
    end

    def draw_listitem(node, opts)
      # only occurs when there is a single <li> without a proper list
      draw_node(node, opts)
    end

    private

    def count_list_level(node)
      level = 1
      parent = node.parent
      until parent.nil?
        if parent.type == :list
          level += 1
        end
        parent = parent.parent
      end
      level
    end

    def list_settings(node, opts)
      is_task_list = tasklist?(node)
      is_ordered = node.list_type == :ordered_list
      list_start = is_ordered ? (node.list_start || 0) : 0
      level = count_list_level(node)
      style = list_style(level, is_ordered, is_task_list)
      {
        is_ordered: is_task_list ? false : is_ordered,
        is_task_list: is_task_list,
        list_start: list_start,
        level: level,
        point_inline: opt_list_point_inline?(style),
        opts_padding: opts_padding(style),
        content_opts: opts_font(style, opts).merge(
          {
            force_paragraph: {
              bottom_padding: opt_list_point_spacing(style)
            }
          }
        )
      }
    end

    def point_settings(node, list)
      point_style = list_point_style(list[:level], list[:is_ordered], list[:is_task_list])
      auto_span = opt_list_point_spanning?(point_style)
      bullet_opts = opts_font(point_style, list[:content_opts])
      {
        spacing: opt_list_point_spacing(point_style),
        auto_span: auto_span,
        max_span: auto_span ? measure_max_span(node, point_style, bullet_opts, list) : 0,
        bullet_opts: bullet_opts,
        style: point_style
      }
    end

    def list_bullet(node, style, is_ordered, is_task_list, number)
      return opt_task_list_point_sign(style, task_list_checked?(node)) if is_task_list
      return opt_list_point_sign(style) unless is_ordered

      bullet = opt_list_point_alphabetical?(style) ? list_point_alphabetically(number) : number
      template = opt_list_point_template(style)
      template.gsub('<number>', bullet.to_s)
    end

    def tasklist?(node)
      list_item = node.first
      list_item&.type_string == 'tasklist'
    end

    def task_list_checked?(node)
      node.tasklist_item_checked?
    end

    def list_point_alphabetically(int)
      name = 'a'
      (int - 1).times { name.succ! }
      name
    end

    def measure_max_span(node, style, bullet_opts, list)
      max_span = 0
      node.each_with_index do |sub, index|
        bullet = list_bullet(sub, style, list[:is_ordered], list[:is_task_list], index + list[:list_start])
        bullet_width = measure_text_width("#{bullet} ", bullet_opts)
        max_span = [max_span, bullet_width].max
      end
      max_span
    end

    def list_point_style(level, is_ordered, is_task_list)
      if is_task_list
        point_style = @styles.task_list_point
        point_style_level = @styles.task_list_point_level(level)
      else
        point_style = @styles.list_point(is_ordered)
        point_style_level = @styles.list_point_level(is_ordered, level)
      end
      point_style.merge(point_style_level)
    end

    def list_style(level, is_ordered, is_task_list)
      if is_task_list
        style = @styles.task_list
        style_level = @styles.task_list_level(level)
      else
        style = @styles.list(is_ordered)
        style_level = @styles.list_level(is_ordered, level)
      end
      style.merge(style_level)
    end

    def build_bullet(node, points, index, is_ordered, is_task_list)
      bullet = list_bullet(node, points[:style], is_ordered, is_task_list, index)
      bullet_width =
        if points[:auto_span]
          points[:max_span]
        else
          measure_text_width("#{bullet} ", points[:bullet_opts])
        end
      [bullet, bullet_width + points[:spacing]]
    end

    def convert_list_entry(node, index, points, list)
      if list[:point_inline]
        convert_list_entry_inline(node, index, points, list)
      else
        convert_list_entry_float(node, index, points, list)
      end
    end

    def convert_list_entry_float(node, index, points, list)
      bullet, bullet_width = build_bullet(node, points, index, list[:is_ordered], list[:is_task_list])
      @pdf.float { @pdf.formatted_text([text_hash("#{bullet} ", points[:bullet_opts])]) }
      @pdf.indent(bullet_width) { draw_node(node, list[:content_opts]) }
    end

    def convert_list_entry_inline(node, index, points, list)
      bullet, bullet_width = build_bullet(node, points, index, list[:is_ordered], list[:is_task_list])
      child = node.first_child
      text_node = CommonMarker::Node.new(:text)
      text_node.string_content = "#{bullet} "
      return @pdf.formatted_text([text_hash(bullet, points[:bullet_opts])]) if child.nil?

      insert_parent = child.type == :paragraph && child.first_child ? child.first_child : child
      insert_parent.insert_before(text_node)
      node.each do |inner_node|
        if inner_node.type == :paragraph
          draw_node(inner_node, list[:content_opts])
        else
          @pdf.indent(bullet_width) { draw_node(inner_node, list[:content_opts]) }
        end
      end
    end
  end
end
