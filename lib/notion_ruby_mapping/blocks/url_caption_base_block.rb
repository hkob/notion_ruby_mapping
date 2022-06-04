# frozen_string_literal: true

module NotionRubyMapping
  # Notion block
  class UrlCaptionBaseBlock < Block
    # @param [Sting] url
    # @param [RichTextArray, String, Array<String>, RichTextObject, Array<RichTextObject>] caption
    # @see https://www.notion.so/hkob/BookmarkBlock-f2a8c15ad469436c966f74b58dcacbd4#845a1349bf5a4392b427199d6f327557
    # @see https://www.notion.so/hkob/EmbedBlock-57c31e7d8e1d41669eb30f27e1c41035#3421ddd6f27f4ebea4c7e4450f81b866
    def initialize(url = nil, caption: [], json: nil, id: nil, parent: nil)
      raise StandardError, "UrlCaptionBaseBlock is abstract class" if instance_of?(UrlCaptionBaseBlock)

      super(json: json, id: id, parent: parent)
      if @json
        @url = @json[type]["url"]
        decode_block_caption
      else
        @url = url
        @caption = RichTextArray.rich_text_array "caption", caption
      end
    end

    # @see https://www.notion.so/hkob/BookmarkBlock-f2a8c15ad469436c966f74b58dcacbd4#bb6ff9f5dbdc4d52bbf8cdea89fc66de
    # @see https://www.notion.so/hkob/BookmarkBlock-f2a8c15ad469436c966f74b58dcacbd4#eabb5436af464f77865e4a223da72329
    # @see https://www.notion.so/hkob/EmbedBlock-57c31e7d8e1d41669eb30f27e1c41035#f28b77ca0b634acc8e606f954c516ae9
    # @see https://www.notion.so/hkob/EmbedBlock-57c31e7d8e1d41669eb30f27e1c41035#3df6808f8eed43c7bc07ced53cbce6ba
    attr_reader :caption, :url

    # @param [Boolean] not_update false when update
    # @return [Hash{String (frozen)->Hash}]
    def block_json(not_update: true)
      ans = super
      ans[type] = @caption.update_property_schema_json not_update
      ans[type]["url"] = @url
      ans
    end

    # @param [String] str
    # @see https://www.notion.so/hkob/BookmarkBlock-f2a8c15ad469436c966f74b58dcacbd4#054829bf342f40aea4fa6bd23820fbcb
    # @see https://www.notion.so/hkob/EmbedBlock-57c31e7d8e1d41669eb30f27e1c41035#25ece6bfce0749f8b4bbecc6ba7feedc
    def url=(str)
      @url = str
      @payload.add_update_block_key "url"
    end
  end
end
