module MarkdownToPDF
  module Fonts
    def pdf_init_fonts(doc, fonts, fallback_font, fonts_path)
      fonts.each do |font|
        register_pdf_font(doc, font, fonts_path)
      end
      if fallback_font[:pathname] && fallback_font[:filename]
        font_path = File.expand_path(File.join(fonts_path, fallback_font[:pathname], fallback_font[:filename]))
        doc.fallback_fonts = [font_path]
      end
    end

    private

    def register_pdf_font(doc, font, fonts_path)
      font_name = font[:name]
      font_pathname = font[:pathname]
      font_path = File.expand_path(File.join(fonts_path, font_pathname))
      doc.font_families.update(
        font_name => {
          bold: File.join(font_path, font[:bold]),
          italic: File.join(font_path, font[:italic]),
          normal: File.join(font_path, font[:regular]),
          bold_italic: File.join(font_path, font[:bold_italic])
        }
      )
    end

  end
end
