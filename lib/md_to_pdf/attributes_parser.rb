# frozen_string_literal: true

# kramdown - fast, pure-Ruby Markdown-superset converter
# Copyright (C) 2009-2013 Thomas Leitner <t_leitner@gmx.at>
# Permission is hereby granted, free of charge, to any person obtaining a
# copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be included
# in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
# OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
# CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
# TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
# SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

module MarkdownToPDF
  class AttributesParser
    OPT_SPACE = / {0,3}/
    IAL_CLASS_ATTR = 'class'
    ALD_ID_CHARS = /[\w-]/
    ALD_ANY_CHARS = /\\}|[^}]/
    ALD_ID_NAME = /\w#{ALD_ID_CHARS}*/
    ALD_CLASS_NAME = /[^\s.#]+/
    ALD_TYPE_KEY_VALUE_PAIR = /(#{ALD_ID_NAME})=("|')((?:\\\}|\\\2|[^}\2])*?)\2/
    ALD_TYPE_CLASS_NAME = /\.(#{ALD_CLASS_NAME})/
    ALD_TYPE_ID_NAME = /#([A-Za-z][\w:-]*)/
    ALD_TYPE_ID_OR_CLASS = /#{ALD_TYPE_ID_NAME}|#{ALD_TYPE_CLASS_NAME}/
    ALD_TYPE_ID_OR_CLASS_MULTI = /((?:#{ALD_TYPE_ID_NAME}|#{ALD_TYPE_CLASS_NAME})+)/
    ALD_TYPE_REF = /(#{ALD_ID_NAME})/
    ALD_TYPE_ANY = /(?:\A|\s)(?:#{ALD_TYPE_KEY_VALUE_PAIR}|#{ALD_TYPE_REF}|#{ALD_TYPE_ID_OR_CLASS_MULTI})(?=\s|\Z)/

    # Parse the string +str+ and extract all attributes and returns all found attributes to the hash +opts+.
    def parse_attribute_list(str)
      opts = {}
      return opts if str.strip.empty? || str.strip == ':'

      attrs = str.scan(ALD_TYPE_ANY)
      attrs.each do |key, sep, val, ref, id_and_or_class, _, _|
        if ref
          (opts[:refs] ||= []) << ref
        elsif id_and_or_class
          id_and_or_class.scan(ALD_TYPE_ID_OR_CLASS).each do |id_attr, class_attr|
            if class_attr
              opts[IAL_CLASS_ATTR] = "#{opts[IAL_CLASS_ATTR]} #{class_attr}".lstrip
            else
              opts['id'] = id_attr
            end
          end
        else
          val.gsub!(/\\(\}|#{sep})/, "\\1")
          opts[key] = val
        end
      end
      opts
    end
  end
end
