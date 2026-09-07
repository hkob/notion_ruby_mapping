# frozen_string_literal: true

module NotionRubyMapping
  # Base class for blocks that contain a file and an optional caption.
  #
  # This class manages the file representation, caption, and update payload
  # shared by file-based block types.
  # @abstract Subclass and implement {#type}.
  class FileBaseBlock < Block
    # Creates a file-based block.
    #
    # @param url_or_fuo [String, FileUploadObject, FileObject, nil]
    #   an external URL, a file upload object, or a file object
    # @param caption [RichTextArray, String, Array<String>, RichTextObject,
    #   Array<RichTextObject>, nil] caption content
    # @param json [Hash, nil] block JSON returned by the Notion API
    # @param id [String, nil] block ID
    # @param parent [Page, Block, nil] parent object
    def initialize(url_or_fuo = nil, caption: [], json: nil, id: nil, parent: nil)
      super(json: json, id: id, parent: parent)
      if @json
        @file_object = FileObject.new json: @json[type]
        decode_block_caption
        @can_append = @file_object.external?
      else
        @file_object = FileObject.file_object url_or_fuo
        @caption = RichTextArray.rich_text_array "caption", caption
      end
    end

    # @return [RichTextArray] block caption
    attr_reader :caption

    # @return [FileObject] current file representation
    attr_reader :file_object

    # Builds the block JSON representation.
    #
    # @param not_update [Boolean] true for a complete block payload;
    #   false for an update payload
    # @return [Hash{String => Object}] block JSON
    # @api private
    def block_json(not_update: true)
      ans = super
      ans[type] = @file_object.property_values_json
      ans[type].merge! @caption.update_property_schema_json(not_update) if @caption
      ans
    end

    # Returns the current file URL.
    #
    # A URL returned for a Notion-hosted file may expire.
    #
    # @return [String, nil] current file URL
    def url
      @file_object&.url
    end

    # Replaces the current file with an external URL.
    #
    # Call {Block#save} to send the change to the Notion API.
    #
    # @param url [String] new external URL
    def url=(url)
      @file_object.url = url
      @payload.add_update_block_key "external"
    end

    # Replaces the current file with an uploaded file.
    #
    # Call {Block#save} to send the change to the Notion API. After saving,
    # the file is reconstructed as a Notion-hosted file.
    #
    # @param file_upload_object [FileUploadObject] uploaded file
    def file_upload_object=(file_upload_object)
      @file_object.file_upload_object = file_upload_object
      @payload.add_update_block_key "file_upload"
    end

    # Reconstructs the file and caption from an API response.
    #
    # @param json [Hash] block JSON returned by the Notion API
    # @return [void]
    # @api private
    def update_file_object_from_json(json)
      @file_object = FileObject.new json: json[type]
      decode_block_caption
      @can_append = @file_object.external?
    end
  end
end
