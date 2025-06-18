# frozen_string_literal: true

module NotionRubyMapping
  # Notion block
  class FileBaseBlock < Block
    # @param [String, nil] url
    # @param [RichTextArray, String, Array<String>, RichTextObject, Array<RichTextObject>, nil] caption
    # @see https://www.notion.so/hkob/FileBlock-08f2aa6948364d00b92beacaac9a619c#ace53d2e6ff2404f937179ae1e966e98
    # @see https://www.notion.so/hkob/ImageBlock-806b3d2a9a2c4bf5a5aca6e3fbc8a7e2#4cb790b8b5c847acab4341d55e4fa66a
    def initialize(url = nil, caption: [], json: nil, id: nil, parent: nil)
      super(json: json, id: id, parent: parent)
      if @json
        @file_object = FileObject.new json: @json[type]
        decode_block_caption
        @can_append = @file_object.external?
      else
        @file_object = FileObject.file_object url
        @caption = RichTextArray.rich_text_array :caption, caption
      end
    end

    # @see https://www.notion.so/hkob/FileBlock-08f2aa6948364d00b92beacaac9a619c#158487a7e1644fae8778dcff59869356
    # @see https://www.notion.so/hkob/ImageBlock-806b3d2a9a2c4bf5a5aca6e3fbc8a7e2#19a4aa3e06514bbe84be9d3b8a45a20f
    attr_reader :caption, :file_object

    # @param [Boolean] not_update false when update
    # @return [Hash{String (frozen)->Hash}]
    def block_json(not_update: true)
      ans = super
      ans[type] = @file_object.property_values_json
      ans[type].merge! @caption.update_property_schema_json(not_update) if @caption
      ans
    end

    # @return [String]
    # @see https://www.notion.so/hkob/FileBlock-08f2aa6948364d00b92beacaac9a619c#d3e7d31b7b274955aa7603163867fa57
    # @see https://www.notion.so/hkob/ImageBlock-806b3d2a9a2c4bf5a5aca6e3fbc8a7e2#01e1883119f14c5f9f7f6823793e72ec
    def url
      @file_object&.url
    end

    # @param [String] url
    # @see https://www.notion.so/hkob/FileBlock-08f2aa6948364d00b92beacaac9a619c#23497b8eb2214c45b3d5881796f984cb
    # @see https://www.notion.so/hkob/ImageBlock-806b3d2a9a2c4bf5a5aca6e3fbc8a7e2#61598d260b6140f2a359f7d22ea2548a
    def url=(url)
      @file_object.url = url
      @payload.add_update_block_key :external
    end

    # @param [FileUploadObject] fuo
    def file_upload_object=(fuo)
      @file_object.file_upload_object = fuo
      @payload.add_update_block_key :file_upload
    end

    def update_file_object_from_json(json)
      @file_object = FileObject.new json: json[type]
      decode_block_caption
      @can_append = @file_object.external?
    end
  end
end
