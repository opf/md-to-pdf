require "open3"
require "tempfile"

module MarkdownToPDF
  module Codeblock
    # https://github.com/1jehuang/mermaid-rs-renderer, a single static binary that
    # renders mermaid without a node installation.
    MERMAID_RS_CLI = "mmdr".freeze
    MERMAID_RS_CONFIG = '{"theme":"neutral","themeVariables":{"background":"transparent"}}'.freeze
    MERMAID_RS_SCALE = 1
    MAX_MERMAID_SOURCE_BYTES = 64 * 1024

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

    def mermaid_cli_available?
      return $mermaid_cli_available if defined?($mermaid_cli_available)

      $mermaid_cli_available =
        begin
          _, status = Open3.capture2e("mmdc", "-V")
          status.success?
        rescue StandardError
          false
        end
    end

    def mermaid_rs_cli_available?
      return $mermaid_rs_cli_available if defined?($mermaid_rs_cli_available)

      $mermaid_rs_cli_available =
        begin
          _, status = Open3.capture2e(MERMAID_RS_CLI, "--version")
          status.success?
        rescue StandardError
          false
        end
    end

    def build_mermaid_block(node, opts)
      return true if build_mermaid_cli_block(node, opts)

      build_mermaid_rs_block(node, opts)
    end

    def build_mermaid_cli_block(node, _opts)
      return false unless respond_to?(:mermaid_cli_enabled?, true) && mermaid_cli_enabled?
      return false unless respond_to?(:mermaid_cli_available?, true) && mermaid_cli_available?

      embed_mermaid_image do |destination|
        run_mermaid_cli(node.string_content, destination, 'png',
                        { background: "transparent", theme: "neutral", scale: "2" })
      end
    end

    def build_mermaid_rs_block(node, _opts)
      return false unless respond_to?(:mermaid_rs_cli_enabled?, true) && mermaid_rs_cli_enabled?
      return false unless respond_to?(:mermaid_rs_cli_available?, true) && mermaid_rs_cli_available?

      embed_mermaid_image do |destination|
        run_mermaid_rs_cli(node.string_content, destination)
      end
    end

    def embed_mermaid_image
      image_file = Tempfile.new(['mermaid', ".png"])
      begin
        return false unless yield(image_file.path)

        image_obj, image_info = @pdf.build_image_object(image_file.path)
        options = {}
        if image_info.width > @pdf.bounds.width
          options[:scale] = [@pdf.bounds.width / image_info.width.to_f, 1].min
        end
        @pdf.embed_image(image_obj, image_info, options)
        true
      rescue StandardError
        false
      ensure
        image_file.unlink
      end
    end

    def run_mermaid_rs_cli(source, destination)
      return false if source.to_s.bytesize > MAX_MERMAID_SOURCE_BYTES

      tmp_file('mermaid', 'mmd', source) do |input|
        tmp_file('mermaid', 'json', MERMAID_RS_CONFIG) do |config|
          args = ["-i", input, "-e", 'png', "-o", destination, "-c", config]
          width, height = mermaid_rs_scaled_size(input, config)
          args.push("-w", width.to_s, "-H", height.to_s) if width && height
          _, _, status = Open3.capture3(MERMAID_RS_CLI, *args)
          status.success?
        end
      end
    rescue StandardError
      false
    end

    # mmdr renders at the diagram's natural size, which lands in the pdf at 72 dpi.
    # Rendering at a multiple of it keeps the image sharp in print. The size comes
    # from the svg, which every mmdr version writes to stdout when -o is omitted.
    def mermaid_rs_scaled_size(input, config)
      svg, _, status = Open3.capture3(MERMAID_RS_CLI, "-i", input, "-c", config)
      return nil unless status.success?

      root = svg[/<svg\b[^>]*>/]
      return nil if root.nil?

      width = root[/\bwidth="([0-9.]+)"/, 1].to_f
      height = root[/\bheight="([0-9.]+)"/, 1].to_f
      return nil unless width > 0 && height > 0

      [(width * MERMAID_RS_SCALE).round, (height * MERMAID_RS_SCALE).round]
    rescue StandardError
      nil
    end

    def run_mermaid_cli(mmdc, destination, format, options = {})
      tmp_file('mermaid', 'mmdc', mmdc) do |filename|
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
      rescue StandardError
        false
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
