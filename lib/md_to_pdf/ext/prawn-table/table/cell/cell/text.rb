# frozen_string_literal: true

# Monkey patch table text cell
# * to fix a bug
# * introduce width calculations by longest word in cell

Prawn::Table::Cell::Text.prepend(Module.new do
  # fix  https://github.com/prawnpdf/prawn-table/issues/42
  # which is merged in https://github.com/prawnpdf/prawn-table/pull/60
  # but not released as prawn-table version since 2015
  def styled_width_of(text)
    options = @text_options.reject { |k| k == :style }
    with_font { @pdf.width_of(text, options) }
  end

  # new: get content width with split text (so no words are broken by char)
  def natural_split_content_width
    [styled_width_of_longest_word, @pdf.bounds.width].min
  end

  def styled_width_of_longest_word_formatted
    p = @text_options[:inline_format]
    p = [] unless p.is_a?(Array)

    str = @content.gsub(' ', " \n ")

    arranger = Prawn::Text::Formatted::Arranger.new(@pdf, @text_options.compact)
    with_font do
      arranger.consumed = @pdf.text_formatter.format(str, *p)
      arranger.finalize_line
    end
    w = 1
    arranger.fragments.each do |fragment|
      w = [w, fragment.width].max
    end
    w
  end

  def styled_width_of_longest_word
    return 1 if @content.nil?

    if @text_options.key?(:inline_format) && @content.include?('<')
      return styled_width_of_longest_word_formatted
    end

    longest_word = @content.split(/\s+/m).max_by(&:length)
    return 1 if longest_word.nil?

    options = @text_options.reject { |k| %i[style inline_format].include?(k) }
    with_font { @pdf.width_of(longest_word, options) }
  end
end)
