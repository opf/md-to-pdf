module MarkdownToPDF
  module IDs
    def generate_id(str)
      id = basic_generate_id(str)
      if used_ids.key?(id)
        id += "-#{used_ids[id] += 1}"
      else
        used_ids[id] = 0
      end
      id
    end

    private

    def used_ids
      @used_ids ||= {}
    end

    def basic_generate_id(str)
      id = str.downcase
      id.gsub!(/[^\p{Word}\- ]/u, '') # remove punctuation
      id.tr!(' ', '-') # replace spaces with dash
      id = "section" if id.empty?
      id
    end
  end
end
