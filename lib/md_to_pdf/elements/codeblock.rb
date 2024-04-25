require "open3"
require "tempfile"

module MarkdownToPDF
  module Codeblock
    def draw_codeblock(node, opts)
      return if node.fence_info == "mermaid" && build_mermaid_block(node, opts)

      cell_style_opts = codeblock_style(opts)
      table_rows = build_codeblock_cell_rows(node, cell_style_opts)
      return if table_rows.empty?

      with_block_margin_all(codeblock_margin_style) do
        @pdf.table(table_rows, width: @pdf.bounds.right, cell_style: cell_style_opts) do
          if table_rows.length > 1
            cells.columns(0).rows(0..0).each { |cell| cell.padding_bottom = 1 }
            cells.columns(0).rows(-1..-1).each { |cell| cell.padding_top = 1 }
            value_cells = cells.columns(0).rows(1..-2)
            value_cells.each do |cell|
              cell.padding_top = 1
              cell.padding_bottom = 1
            end
          end
        end
      end
    end

    private

    def mermaid_cli_enabled?
      mermaid_cli_available?
    end

    def mermaid_cli_available?
      return $mermaid_cli_available if defined?($mermaid_cli_available)

      $mermaid_cli_available =
        begin
          _, status = Open3.capture2e("mmdc", "-V")
          status.success?
        rescue StandardError => e
          false
        end
    end

    def build_mermaid_block(node, _opts)
      return false unless mermaid_cli_enabled?

      image_file = Tempfile.new(['mermaid', ".png"])
      begin
        return false unless run_mermaid_cli(node.string_content, image_file.path, 'png',
                                            { background: "transparent", theme: "neutral" })

        image_obj, image_info = @pdf.build_image_object(image_file.path)
        options = {
          scale: [@pdf.bounds.width / image_info.width.to_f, 1].min
        }
        @pdf.embed_image(image_obj, image_info, options)
        true
      rescue StandardError => e
        false
      ensure
        image_file.unlink
      end
    end

    def run_mermaid_cli(mmdc, destination, format, options = {})
      tmp_file('mermaid', 'mmdc', mmdc) do |filename|
        begin
          args = ["-i", filename, '-e', format, '-o', destination]
          args << '-C' << options[:css_file] if options[:css_file]
          args << '-t' << options[:theme] if options[:theme]
          args << '-w' << options[:width] if options[:width]
          args << '-H' << options[:height] if options[:height]
          args << '-s' << options[:scale] if options[:scale]
          args << '-b' << options[:background] if options[:background]
          args << '-p' << options[:puppeteer_config_file] if options[:puppeteer_config_file]
          args << '-c' << options[:config_file] if options[:config_file]
          _, status = Open3.capture2e("mmdc", *args)
          status.success?
        rescue StandardError => e
          false
        end
      end
    end

    def tmp_file(basename, input_ext, code)
      source_file = Tempfile.new([basename, ".#{input_ext}"])
      begin
        File.write(source_file.path, code)
        yield source_file.path
      ensure
        source_file.unlink
      end
    end

    def build_codeblock_cell_rows(node, cell_style_opts)
      lines = node.string_content.gsub(' ', Prawn::Text::NBSP).split("\n")
      lines.map do |line|
        [build_codeblock_cell(line, cell_style_opts)]
      end
    end

    def build_codeblock_cell(text, cell_style_opts)
      Prawn::Table::Cell::Text.new(
        @pdf, [0, 0],
        content: text,
        font: cell_style_opts[:font],
        size: cell_style_opts[:size],
        text_color: cell_style_opts[:color]
      )
    end

    def codeblock_style(opts)
      style = @styles.codeblock
      opts_table_cell(style, opts).merge({ border_width: 0 })
    end

    def codeblock_margin_style
      style = @styles.codeblock
      opts_margin(style)
    end
  end
end
