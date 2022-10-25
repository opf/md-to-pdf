require 'text/hyphen'

module MarkdownToPDF
  class Hyphenate
    def initialize(language)
      @loaded = false
      return if language.nil?

      language = 'de2' if language == 'de'
      language = 'hu2' if language == 'hu'
      language = 'en_uk' if language == 'en'
      language = 'no2' if language == 'no'
      begin
        @hh = Text::Hyphen.new(language: language, left: 2, right: 2)
        @loaded = true
      rescue
        puts "WARNING: language #{language} for hyphenation could not be found"
      end
    end

    def hyphenate(text)
      return text unless @loaded

      text.split(/ /, -1).map do |string|
        if string.empty?
          ''
        else
          @hh.visualize(string, Prawn::Text::SHY)
        end
      end.join(' ')
    end
  end
end
