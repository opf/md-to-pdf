require 'prawn'
require 'prawn/table'

module MarkdownToPDF
  class PDFDocument < Prawn::Document
    def alignment_to_x(align, width)
      align = (align || 'left').to_sym
      x = 0
      unless align == :left
        x = if align == :right
              bounds.width - width
            else
              (bounds.width - width) / 2
            end
      end
      x
    end
  end
end
