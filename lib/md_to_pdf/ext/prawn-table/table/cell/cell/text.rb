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
    @natural_split_content_width ||= [styled_width_of_longest_word, @pdf.bounds.width].min
  end

  # new: get the width of the longest word in the cell
  def styled_width_of_longest_word
    return 1 if @content.nil?

    # TODO: html tags are removed and not applied, so real width could be off
    longest_word = @content.gsub(/<\/?[^>]*>/, "").split(/\s+/m).max_by(&:length)
    return 1 if longest_word.nil?

    styled_width_of(longest_word)
  end
end)
