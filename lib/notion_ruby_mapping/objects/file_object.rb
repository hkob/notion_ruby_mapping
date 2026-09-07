# frozen_string_literal: true

module NotionRubyMapping
  # Represents file information shared by file-based blocks and file properties.
  #
  # Use the owning block or property to update a file. This object is primarily
  # intended for inspecting the current file representation.
  class FileObject
    # Creates a file representation.
    #
    # @param url [String, nil] external file URL
    # @param file_upload_object [FileUploadObject, nil] uploaded file
    # @param json [Hash, nil] file JSON returned by the Notion API
    # @raise [ArgumentError] if no file source is provided
    # @api private
    def initialize(url: nil, file_upload_object: nil, json: nil)
      if url
        @type = "external"
        @url = url
      elsif file_upload_object
        @type = "file_upload"
        @file_upload_object = file_upload_object
      elsif json
        @type = json["type"]
        @url = json[@type]["url"]
        @expiry_time = json[@type]["expiry_time"]
      else
        raise ArgumentError, "FileObject requires url:, file_upload_object:, or json:"
      end
    end
    # @return [String, nil] current file URL
    attr_reader :url

    # @return [String] file type: `"external"`, `"file"`, or `"file_upload"`
    attr_reader :type

    # @return [FileUploadObject, nil] current file upload object
    attr_reader :file_upload_object

    # Converts a supported file value to a file object.
    #
    # @param value [String, FileUploadObject, FileObject]
    #   external URL, uploaded file, or existing file object
    # @return [FileObject] converted file object
    # @api private
    def self.file_object(value)
      if value.is_a? FileUploadObject
        FileObject.new file_upload_object: value
      elsif value.is_a? FileObject
        value
      else
        FileObject.new url: value
      end
    end

    # Checks whether the file uses an external URL.
    #
    # @return [Boolean] true if the file type is `"external"`
    def external?
      @type == "external"
    end

    # Replaces the current representation with an uploaded file.
    #
    # @param file_upload_object [FileUploadObject] uploaded file
    # @api private
    def file_upload_object=(file_upload_object)
      @file_upload_object = file_upload_object
      @type = "file_upload"
      @url = nil
      @expiry_time = nil
    end

    # Replaces the current representation with an external URL.
    #
    # @param url [String] external file URL
    # @api private
    def url=(url)
      @url = url
      @type = "external"
      @expiry_time = nil
    end

    # Builds the Notion API file JSON.
    #
    # @return [Hash{String => Object}] file JSON
    # @api private
    def property_values_json
      if @type == "file_upload"
        {
          "type" => @type.to_s,
          @type => {
            "id" => @file_upload_object.id,
          },
        }
      else
        ans = {
          "type" => @type.to_s,
          @type => {
            "url" => @url,
          },
        }
        ans[@type]["expiry_time"] = @expiry_time if @expiry_time
        ans
      end
    end
  end
end
