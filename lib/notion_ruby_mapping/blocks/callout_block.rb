# frozen_string_literal: true

module NotionRubyMapping
  # Notion block
  class CalloutBlock < Block
    # @param [RichTextArray, String, Array<String>, RichTextObject, Array<RichTextObject>] text_info
    # @param [String] emoji
    # @param [String] file_url
    # @param [String] color
    # @param [NotionRubyMapping::Block, Array<NotionRubyMapping::Block>, nil] sub_blocks
    def initialize(text_info = nil, emoji: nil, file_url: nil, sub_blocks: nil, color: "default", json: nil, id: nil,
                   parent: nil)
      super(json: json, id: id, parent: parent)
      if @json
        decode_block_rich_text_array
        decode_color
      else
        rich_text_array_and_color "rich_text", text_info, color
        @emoji = EmojiObject.emoji_object emoji if emoji
        @file_object = FileObject.file_object file_url if file_url
        add_sub_blocks sub_blocks
      end
      @can_have_children = true
    end

    # @see https://www.notion.so/hkob/CalloutBlock-0eb8b64bea664bc89fad706a866a6e26#db689d47cbcc44359a5ade17ca754cdd
    # @see https://www.notion.so/hkob/CalloutBlock-0eb8b64bea664bc89fad706a866a6e26#4314e4d50617485f8d0fc3505c5b3e9b
    attr_reader :color, :rich_text_array

    # @param [Boolean] not_update false when update
    # @return [Hash{String (frozen)->Hash}]
    def block_json(not_update: true)
      ans = super
      ans[type] = @rich_text_array.update_property_schema_json not_update
      ans[type]["color"] = @color
      ans[type]["icon"] = @emoji.property_values_json if @emoji
      ans[type]["icon"] = @file_object.property_values_json if @file_object
      ans[type]["children"] = @sub_blocks.map(&:block_json) if @sub_blocks
      ans
    end

    # @param [String] new_color
    # @see https://www.notion.so/hkob/CalloutBlock-0eb8b64bea664bc89fad706a866a6e26#b3598e385c2d4a23ada506441a7f0f32
    def color=(new_color)
      @color = new_color
      @payload.add_update_block_key "color"
    end

    # @return [String, nil]
    # @see https://www.notion.so/hkob/CalloutBlock-0eb8b64bea664bc89fad706a866a6e26#611496b7fd96499882fad138ef248b04
    def emoji
      @emoji&.emoji
    end

    # @param [String] emoji
    # @see https://www.notion.so/hkob/CalloutBlock-0eb8b64bea664bc89fad706a866a6e26#0bd030c398184f94b819358830c2e26d
    def emoji=(emoji)
      @emoji = EmojiObject.emoji_object emoji
      @file_object = nil
      @payload.add_update_block_key "icon"
    end

    # @return [String]
    # @see https://www.notion.so/hkob/CalloutBlock-0eb8b64bea664bc89fad706a866a6e26#57a8fc88f2ee49f7963942ad30cbca04
    def file_url
      @file_object&.url
    end

    # @param [String] url
    # @see https://www.notion.so/hkob/CalloutBlock-0eb8b64bea664bc89fad706a866a6e26#041dd676bbfb442699229486fd30370a
    def file_url=(url)
      @file_object = FileObject.file_object url
      @emoji = nil
      @payload.add_update_block_key "icon"
    end

    # @return [String (frozen)]
    def type
      "callout"
    end
  end
end
