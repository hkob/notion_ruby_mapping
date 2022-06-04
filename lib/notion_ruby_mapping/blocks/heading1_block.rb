# frozen_string_literal: true

module NotionRubyMapping
  # Notion block
  class Heading1Block < TextSubBlockColorBaseBlock
    # @param [RichTextArray, String, Array<String>, RichTextObject, Array<RichTextObject>, nil] text_info
    # @param [String] color
    def initialize(text_info = nil, color: nil, json: nil, id: nil, parent: nil)
      super(text_info, color: color, json: json, id: id, parent: parent)
      @can_have_children = false
    end

    # @return [String (frozen)]
    def type
      "heading_1"
    end
  end
end
