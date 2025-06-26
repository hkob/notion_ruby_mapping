# frozen_string_literal: true

module NotionRubyMapping
  # Notion block
  class TextSubBlockColorBaseBlock < Block
    # @param [RichTextArray, String, Array<String>, RichTextObject, Array<RichTextObject>, nil] text_info
    # @param [String] color
    # @param [NotionRubyMapping::Block, Array<NotionRubyMapping::Block>, nil] sub_blocks
    def initialize(text_info = nil, sub_blocks: nil, color: "default", json: nil, id: nil, parent: nil)
      raise StandardError, "TextSubBlockColorBaseBlock is abstract class" if instance_of?(TextSubBlockColorBaseBlock)

      super(json: json, id: id, parent: parent)
      if @json
        decode_block_rich_text_array
        decode_color
      else
        rich_text_array_and_color "rich_text", text_info, color
        add_sub_blocks sub_blocks
      end
      @can_have_children = true
    end

    # @see https://www.notion.so/hkob/BulletedListItemBlock-ac4978f4efbb40109f0fb3bd00f43476#36d044b3db734fc5b0e21c07d829cb81
    # @see https://www.notion.so/hkob/BulletedListItemBlock-ac4978f4efbb40109f0fb3bd00f43476#cef80016457e46e7bb178f063e4981de
    attr_reader :color, :rich_text_array

    # @param [String] new_color
    # @see https://www.notion.so/hkob/BulletedListItemBlock-ac4978f4efbb40109f0fb3bd00f43476#2d59111c9e434dfa99d294cc9a74e468
    def color=(new_color)
      @color = new_color
      @payload.add_update_block_key "color"
      @rich_text_array.will_update = true
    end

    # @param [Boolean] not_update false when update
    # @return [Hash{String (frozen)->Hash}]
    def block_json(not_update: true)
      ans = super
      ans[type] = @rich_text_array.update_property_schema_json not_update
      ans[type]["color"] = @color
      ans[type]["children"] = @sub_blocks.map(&:block_json) if @sub_blocks
      ans
    end
  end
end
