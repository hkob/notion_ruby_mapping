# frozen_string_literal: true

module NotionRubyMapping
  # TextObject
  class TextObject < RichTextObject
    # @param [String] text
    # @return [TextObject]
    def initialize(text, options = {})
      super "text", {"plain_text" => text}.merge(options)
      @text = text
      @type = "text"
      @will_update = false
    end
    attr_reader :text, :will_update

    # @param [String, RichTextObject] value
    # @return [RichTextObject] self
    def text=(value)
      @will_update = true
      if value.is_a? RichTextObject
        @options = value.options
        @text = value.text
      else
        p value
        @text = value
        @options["plain_text"] = value
      end
      self
    end

    # @param [String, RichTextObject] value
    # @return [String] input text
    def plain_text=(value)
      text(value)
    end

    # @param [Boolean] flag
    # @return [Boolean] input flag
    def bold=(flag)
      @will_update = true
      @options["bold"] = flag
    end

    # @param [Boolean] flag
    # @return [Boolean] input flag
    def italic=(flag)
      @will_update = true
      @options["italic"] = flag
    end

    # @param [Boolean] flag
    # @return [Boolean] input flag
    def strikethrough=(flag)
      @will_update = true
      @options["strikethrough"] = flag
    end

    # @param [Boolean] flag
    # @return [Boolean] input flag
    def underline=(flag)
      @will_update = true
      @options["underline"] = flag
    end

    # @param [Boolean] flag
    # @return [Boolean] input flag
    def code=(flag)
      @will_update = true
      @options["code"] = flag
    end

    # @param [String] color
    # @return [String] input color
    def color=(color)
      @will_update = true
      @options["color"] = color
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
