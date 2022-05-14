# frozen_string_literal: true

module NotionRubyMapping
  # TextObject
  class TextObject < RichTextObject
    # @param [String] text
    # @return [TextObject]
    def initialize(text, options = {})
      super "text", {"plain_text" => text}.merge(options)
      @text = text
      @will_update = false
    end
    attr_reader :text, :will_update

    # @param [String, RichTextObject] value
    def text=(value)
      @will_update = true
      if value.is_a? RichTextObject
        @options = value.options
        @text = value.text
      else
        @text = value
        @options["plain_text"] = value
      end
    end

    protected

    def partial_property_values_json
      url = @options["href"]
      {
        "content" => @text,
        "link" => url ? {"url" => url} : nil,
      }
    end
  end
end
