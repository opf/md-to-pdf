module MarkdownToPDF
  class Styles
    def initialize(styling = {})
      @styling = styling
    end

    def default_fields
      get_style(:fields_default)
    end

    def fonts
      @styling[:fonts] || []
    end

    def fallback_font
      @styling[:fallback_font] || {}
    end

    def page_footer
      get_style(:page_footer)
    end

    def page_footer2
      get_style(:page_footer_2)
    end

    def page_footer3
      get_style(:page_footer_3)
    end

    def min_footer_offset
      @min_footer_offset ||= [page_footer[:offset] || 0, page_footer2[:offset] || 0, page_footer3[:offset] || 0].min
    end

    def page_logo
      get_style(:page_logo)
    end

    def page_header
      get_style(:page_header)
    end

    def page_header2
      get_style(:page_header_2)
    end

    def page_header3
      get_style(:page_header_3)
    end

    def page
      get_style(:page)
    end

    def link
      get_style(:link)
    end

    def headline
      get_style(:header)
    end

    def paragraph
      get_style(:paragraph)
    end

    def image
      get_style(:image)
    end

    def image_class(image_class_name)
      image_classes = get_style(:image_classes)
      image_classes[image_class_name.to_sym] || {}
    end

    def code
      get_style(:code)
    end

    def hrule
      get_style(:hrule)
    end

    def headline_level(level)
      get_style(:"header_#{level}")
    end

    def footnote_reference
      get_style(:footnote_reference)
    end

    def footnote_definition
      get_style(:footnote_definition)
    end

    def footnote_definition_point
      get_style(footnote_definition)[:point] || {}
    end

    def task_list
      get_style(:task_list)
    end

    def task_list_level(level)
      get_style("task_list_#{level}")
    end

    def task_list_point
      get_style(:task_list_point)
    end

    def task_list_point_level(level)
      get_style("task_list_point_#{level}")
    end

    def list(is_ordered)
      get_style(is_ordered ? :ordered_list : :unordered_list)
    end

    def list_level(is_ordered, level)
      get_style(:"#{is_ordered ? :ordered_list : :unordered_list}_#{level}")
    end

    def list_point(is_ordered)
      get_style(is_ordered ? :ordered_list_point : :unordered_list_point)
    end

    def list_point_level(is_ordered, level)
      get_style(:"#{is_ordered ? :ordered_list : :unordered_list}_point_#{level}")
    end

    def table
      get_style(:table)
    end

    def table_cell
      table[:cell] || {}
    end

    def table_header
      table[:header] || {}
    end

    def headless_table
      return table if @styling[:headless_table].nil?

      get_style(:headless_table)
    end

    def headless_table_cell
      headless_table[:cell] || {}
    end

    def headless_table_header
      headless_table[:header] || {}
    end

    def html_table
      return table if @styling[:html_table].nil?

      get_style(:html_table)
    end

    def html_table_cell
      html_table[:cell] || {}
    end

    def html_table_header
      html_table[:header] || {}
    end

    def codeblock
      get_style(:codeblock)
    end

    def blockquote
      get_style(:blockquote)
    end

    def get_style(section)
      @styling[section] || {}
    end

    def alert_styles(alert_type)
      alert_styles = get_style(:alerts)
      alert_styles[alert_type] || {}
    end
  end
end
