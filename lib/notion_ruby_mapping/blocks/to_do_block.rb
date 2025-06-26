# frozen_string_literal: true

module NotionRubyMapping
  # Notion block
  class ToDoBlock < TextSubBlockColorBaseBlock
    # @param [RichTextArray, String, Array<String>, RichTextObject, Array<RichTextObject>] text_info
    # @param [Boolean] checked
    # @param [NotionRubyMapping::Block, Array<NotionRubyMapping::Block>, nil] sub_blocks
    # @param [String] color
    def initialize(text_info = nil, checked = false, sub_blocks: nil, color: "default", json: nil, id: nil, parent: nil)
      super(text_info, sub_blocks: sub_blocks, color: color, json: json, id: id, parent: parent)
      @checked = if @json
                   @json[type]["checked"]
                 else
                   checked
                 end
    end

    # @see https://www.notion.so/hkob/ToDoBlock-9e4d863244b541869d91c84620e190d4#a4550dc684de43d2be171d4abbbea7ce
    attr_reader :checked

    # @param [Boolean] not_update false when update
    # @return [Hash{String (frozen)->Hash}]
    def block_json(not_update: true)
      ans = super
      ans[type]["checked"] = @checked
      ans
    end

    # @param [Boolean] new_checked
    # @see https://www.notion.so/hkob/ToDoBlock-9e4d863244b541869d91c84620e190d4#8ef8b12721914cccb17790879bdc2fbf
    def checked=(new_checked)
      @checked = new_checked
      @payload.add_update_block_key "checked"
    end

    # @return [String (frozen)]
    def type
      "to_do"
    end
  end
end
