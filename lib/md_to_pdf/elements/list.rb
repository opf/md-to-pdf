module MarkdownToPDF
  module List
    def draw_list(node, opts)
      level = count_list_level(node)
      is_task_list = tasklist?(node)
      is_ordered = node.list_type == :ordered_list
      list_start = is_ordered ? (node.list_start || 0) : 0
      list_style = list_style(level, is_ordered, is_task_list)
      padding = level == 1 ? opts_padding(list_style) : {}
      point_inline = opt_list_point_inline?(list_style)
      content_opts = opts_font(list_style, opts).merge(
        {
          force_paragraph: {
            bottom_padding: opt_list_point_spacing(list_style)
          }
        }
      )
      points = collect_points(node, level, is_ordered, is_task_list, list_start, content_opts)
      with_block_padding_all(padding) do
        if point_inline
          draw_inline_points(points, content_opts)
        else
          draw_points(points, content_opts)
        end
      end
    end

    def data_html_list(tag, _node, opts)
      level = count_list_level_html(tag)
      is_ordered = tag.name.downcase == 'ol'
      is_task_list = !tag.search("input[type=checkbox]").first.nil?
      list_style = list_style(level, is_ordered, is_task_list)
      content_opts = opts_font(list_style, opts).merge(
        {
          force_paragraph: {
            bottom_padding: opt_list_point_spacing(list_style)
          }
        }
      )
      points = collect_points_html(tag, level, is_ordered, is_task_list, content_opts)
      [points, level, list_style, content_opts]
    end

    def draw_html_list_tag(tag, node, opts)
      points, level, list_style, content_opts = data_html_list(tag, node, opts)
      padding = level == 1 ? opts_padding(list_style) : {}
      with_block_padding_all(padding) do
        draw_points_html(points, node, content_opts)
      end
    end

    private

    def draw_points(points, opts)
      points.each do |point|
        @pdf.float { @pdf.formatted_text([text_hash(point[:bullet], point[:opts])], filter_block_hash(point[:opts])) }
        @pdf.indent(point[:width]) { draw_node(point[:node], opts) }
      end
    end

    def draw_points_html(points, node, opts)
      points.each do |point|
        @pdf.float { @pdf.formatted_text([text_hash(point[:bullet], point[:opts])], filter_block_hash(point[:opts])) }
        @pdf.indent(point[:width]) do
          y = @pdf.y
          draw_html_tag(point[:tag], node, opts)
          if y == @pdf.y
            point_height = @pdf.height_of_formatted([text_hash(point[:bullet], point[:opts])], filter_block_hash(point[:opts]))
            @pdf.move_down(point_height)
          end
        end
      end
    end

    def draw_inline_points(points, opts)
      points.each do |point|
        node = point[:node]
        bullet = point[:bullet]
        child = node.first_child
        return @pdf.formatted_text([text_hash(bullet, point[:opts])], filter_block_hash(point[:opts])) if child.nil?

        # insert into paragraph
        text_node = Markly::Node.new(:text).tap { |n| n.string_content = bullet }
        insert_parent = child.type == :paragraph && child.first_child ? child.first_child : child
        insert_parent.insert_before(text_node)

        node.to_a.each do |inner_node|
          if inner_node.type == :paragraph
            draw_node_list([inner_node], opts)
          else
            @pdf.indent(point[:width]) { draw_node([inner_node], opts) }
          end
        end
      end
    end

    def collect_points_html(tag, level, is_ordered, is_task_list, content_opts)
      point_style = list_point_style(level, is_ordered, is_task_list)
      auto_span = opt_list_point_spanning?(point_style)
      bullet_opts = opts_font(point_style, content_opts)
      spacing = opt_list_point_spacing(point_style)
      points = []
      index = 1
      tag.children.each do |sub|
        if sub.name.downcase == 'li'
          checked = false
          if is_task_list
            checked_box_tag = sub.search("input[type=checkbox]").first
            unless checked_box_tag.nil?
              checked = checked_box_tag.attributes.key?('checked')
              checked_box_tag['md_to_pdf_done'] = true
            end
          end
          bullet = list_bullet(point_style, is_ordered, is_task_list, index, checked)
          bullet_width = measure_text_width(bullet, bullet_opts) + spacing
          space_width = measure_text_width(Prawn::Text::NBSP, bullet_opts)
          points.push({ tag: sub, bullet: bullet, width: bullet_width, space_width: space_width, opts: bullet_opts })
          index += 1
        end
      end
      if auto_span || is_task_list
        max_span = max_point_width(points)
        points.each { |point| point[:width] = max_span }
      end
      points
    end

    def collect_points(node, level, is_ordered, is_task_list, list_start, content_opts)
      point_style = list_point_style(level, is_ordered, is_task_list)
      auto_span = opt_list_point_spanning?(point_style)
      bullet_opts = opts_font(point_style, content_opts)
      spacing = opt_list_point_spacing(point_style)
      points = []
      node.each_with_index do |li, index|
        number = list_start + index
        bullet = list_bullet(point_style, is_ordered, is_task_list, number, task_list_checked?(li))
        bullet_width = measure_text_width(bullet, bullet_opts) + spacing
        points.push({ node: li, bullet: bullet, width: bullet_width, opts: bullet_opts })
      end
      if auto_span
        max_span = max_point_width(points)
        points.each { |point| point[:width] = max_span }
      end
      points
    end

    def max_point_width(points)
      max_span = 0
      points.each { |point| max_span = [max_span, point[:width]].max }
      max_span
    end

    def draw_listitem(node, opts)
      # only occurs when there is a single <li> without a proper list
      draw_node(node, opts)
    end

    def count_list_level_html(tag)
      level = 1
      parent = tag.parent
      until parent.nil?
        if %w[ul ol].include?(parent.name.downcase)
          level += 1
        end
        parent = parent.parent
      end
      level
    end

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

    def list_bullet(style, is_ordered, is_task_list, number, is_checked)
      bullet_sign = if is_task_list
                      opt_task_list_point_sign(style, is_checked)
                    elsif is_ordered
                      opt_list_point_number(number, style)
                    else
                      opt_list_point_sign(style)
                    end
      "#{bullet_sign} "
    end

    def tasklist?(node)
      node.to_a.any? { |list_item| list_item.type_string == 'tasklist' }
    end

    def task_list_checked?(node)
      node.tasklist_item_checked?
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
  end
end
