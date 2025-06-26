# frozen_string_literal: true

module NotionRubyMapping
  # Notion block
  class TemplateBlock < Block
    # @param [RichTextArray, String, Array<String>, RichTextObject, Array<RichTextObject>] text_info
    # @param [NotionRubyMapping::Block, Array<NotionRubyMapping::Block>, nil] sub_blocks
    def initialize(text_info = nil, sub_blocks: nil, json: nil, id: nil, parent: nil)
      super(json: json, id: id, parent: parent)
      if @json
        decode_block_rich_text_array
      else
        rich_text_array_and_color "rich_text", text_info, nil
        add_sub_blocks sub_blocks
      end
      @can_have_children = true
    end

    attr_reader :rich_text_array

    # @param [Boolean] not_update false when update
    # @return [Hash{String (frozen)->Hash}]
    def block_json(not_update: true)
      ans = super
      ans[type] = @rich_text_array.update_property_schema_json not_update
      ans[type]["children"] = @sub_blocks.map(&:block_json) if @sub_blocks
      ans
    end

    def type
      "template"
    end
  end
end
