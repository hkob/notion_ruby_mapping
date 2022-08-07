# frozen_string_literal: true

module NotionRubyMapping
  # CommentObject
  class CommentObject
    # @param [String] text_objects
    def initialize(text_objects: nil, json: {})
      if text_objects
        @text_objects = RichTextArray.new "rich_text", text_objects: text_objects
        @json = {}
      elsif json
        @json = json
        @text_objects = RichTextArray.new "rich_text", json: json["rich_text"]
      else
        raise StandardError, "Either text_objects or json is required CommentObject"
      end
      @will_update = false
    end
    attr_reader :will_update, :text_objects

    def discussion_id
      NotionCache.instance.hex_id @json["discussion_id"]
    end

    # @return [String] full_text
    def full_text
      @text_objects.full_text
    end
  end
end
