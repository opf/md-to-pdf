module MarkdownToPDF
  module Fonts
    def pdf_init_fonts(doc, fonts, fonts_path)
      fonts.each do |font|
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
end
