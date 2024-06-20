module MarkdownToPDF
  module Fonts
    ALERT_OCTICONS = {
      NOTE: "\ue800",
      TIP: "\ue801",
      WARNING: "\ue802",
      IMPORTANT: "\ue803",
      CAUTION: "\ue804"
    }.freeze
    ALERT_OCTICONS_FONTNAME = 'octicon-alerts'

    def pdf_init_fonts(doc, fonts, fallback_font, fonts_path)
      fonts.each { |font| register_pdf_font(doc, font, fonts_path) }
      if fallback_font[:pathname] && fallback_font[:filename]
        normal = File.expand_path(File.join(fonts_path, fallback_font[:pathname], fallback_font[:filename]))
        doc.font_families.update(fallback_font[:name] => { normal: normal })
        doc.fallback_fonts = [fallback_font[:name]]
      end
    end

    def pdf_init_md2pdf_fonts(doc)
      normal = File.join(File.dirname(File.expand_path(__FILE__)), 'fonts', 'octicon-alerts', 'octicon-alerts.ttf')
      doc.font_families.update(ALERT_OCTICONS_FONTNAME => { normal: normal })
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
