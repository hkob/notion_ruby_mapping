# frozen_string_literal: true

module NotionRubyMapping
  # Notion block
  class Heading2Block < TextSubBlockColorBaseBlock
    # @param [RichTextArray, String, Array<String>, RichTextObject, Array<RichTextObject>] text_info
    # @param [String] color
    def initialize(text_info = nil, color: nil, json: nil, id: nil, parent: nil)
      super(text_info, color: color, json: json, id: id, parent: parent)
      @can_have_children = false
    end

    # @return [String (frozen)]
    def type
      :heading_2
    end

    # @param [Boolean] not_update false when update
    # @return [Hash{String (frozen)->Hash}]
    def block_json(not_update: true)
      ans = super
      ans[type][:is_toggleable] = false
      ans
    end
  end
end
