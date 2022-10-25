module MarkdownToPDF
  class IdGenerator
    def initialize
      @used_ids = {}
    end

    def generate_id(str)
      gen_id = basic_generate_id(str)
      if @used_ids.key?(gen_id)
        gen_id += "-#{@used_ids[gen_id] += 1}"
      else
        @used_ids[gen_id] = 0
      end
      gen_id
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
