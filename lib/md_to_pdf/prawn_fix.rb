# frozen_string_literal: true

require 'prawn/font_metric_cache'

if Prawn::FontMetricCache::CacheEntry.members == %i[font options string]
  class Prawn::FontMetricCache::CacheEntry
    # workaround for https://github.com/prawnpdf/prawn/issues/1140
    # caching of font measering with different sizes does not work properly
    def initialize font, options, size
      font = font.hash
      super
    end
  end
end
