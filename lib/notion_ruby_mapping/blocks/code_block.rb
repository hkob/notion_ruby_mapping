# frozen_string_literal: true

module NotionRubyMapping
  # Notion block
  class CodeBlock < Block
    # @param [RichTextArray, String, Array<String>, RichTextObject, Array<RichTextObject>] text_info
    # @param [RichTextArray, String, Array<String>, RichTextObject, Array<RichTextObject>] caption
    # @param [String] language
    # @see https://www.notion.so/hkob/CodeBlock-3a25869f60394b3f902c1ed0bf5ce1c9#7777d9b785234278876d7bf6842dd8a2
    def initialize(text_info = nil, caption: [], language: "shell", json: nil, id: nil, parent: nil)
      super(json: json, id: id, parent: parent)
      if @json
        decode_block_rich_text_array
        decode_block_caption
        @language = json[type]["language"] || "shell"
      else
        rich_text_array_and_color "rich_text", text_info
        @caption = RichTextArray.rich_text_array "caption", caption
        @language = language
      end
    end

    # @see https://www.notion.so/hkob/CodeBlock-3a25869f60394b3f902c1ed0bf5ce1c9#282b6ca100a14841b849ab24519647f3
    # @see https://www.notion.so/hkob/CodeBlock-3a25869f60394b3f902c1ed0bf5ce1c9#6321da9df4f04ccdbddddcd93b1afbe2
    # @see https://www.notion.so/hkob/CodeBlock-3a25869f60394b3f902c1ed0bf5ce1c9#9de0cd82fb594a3a8d12095d9e21ea8d
    attr_reader :caption, :language, :rich_text_array

    # @param [Boolean] not_update false when update
    # @return [Hash{String (frozen)->Hash}]
    def block_json(not_update: true)
      ans = super
      ans[type] = @rich_text_array.update_property_schema_json(not_update).merge(
        @caption.update_property_schema_json(not_update),
      )
      ans[type]["language"] = @language
      ans
    end

    # @param [String] new_language
    def language=(new_language)
      @language = new_language
      @payload.add_update_block_key "language"
    end

    # @return [String]
    def type
      "code"
    end
  end
end
