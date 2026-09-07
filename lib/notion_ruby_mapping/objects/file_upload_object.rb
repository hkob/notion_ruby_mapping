# frozen_string_literal: true

module NotionRubyMapping
  # Uploads a local or external file to Notion.
  #
  # Creating an instance starts the upload immediately. Large local files are
  # split into multiple parts before being uploaded.
  class FileUploadObject
    # Maximum size of each upload part.
    MAX_SIZE = 10 * 1024 * 1024

    # Creates and uploads a file.
    #
    # When +external_url+ is provided, +fname+ is used as the filename sent to
    # Notion. Otherwise, +fname+ must point to an existing local file.
    #
    # @param fname [String] local file path or filename
    # @param external_url [String, nil] URL of a file for Notion to import
    # @raise [StandardError] if the local file does not exist
    # @raise [ArgumentError] if the local file is empty
    def initialize(fname:, external_url: nil)
      @fname = fname
      if external_url
        payload = {mode: "external_url", external_url: external_url, filename: fname}
        create payload
      else
        raise StandardError, "FileUploadObject requires a valid file name: #{fname}" unless File.exist?(fname)

        @file_size = File.size fname
        raise ArgumentError, "FileUploadObject requires a non-empty file: #{fname}" if @file_size.zero?

        @number_of_parts = (@file_size - 1) / MAX_SIZE + 1
        payload = if @number_of_parts == 1
                    {}
                  else
                    {number_of_parts: @number_of_parts, mode: "multi_part",
                     filename: File.basename(@fname)}
                  end
        create payload
        if @number_of_parts == 1
          single_file_upload
        else
          @temp_files = FileUploadObject.split_to_small_files(@fname, MAX_SIZE)
          @temp_files.each_with_index do |temp_file, i|
            single_file_upload temp_file.path, i + 1
            temp_file.close
            temp_file.unlink
          end
          NotionRubyMapping::NotionCache.instance.complete_a_file_upload_request @id
        end
      end
    end
    # @return [String] file upload ID
    attr_reader :id

    # @return [String] local file path or filename
    attr_reader :fname

    # @return [String] last retrieved upload status
    attr_reader :status

    # Creates a file upload through the Notion API.
    #
    # @param payload [Hash] file upload creation payload
    # @return [String] initial upload status
    # @api private
    def create(payload)
      nc = NotionRubyMapping::NotionCache.instance
      response = nc.create_file_upload_request(payload)
      @id = nc.hex_id response["id"]
      @status = response["status"]
    end

    # Reloads the current upload status from Notion.
    #
    # @return [FileUploadObject] self
    def reload
      nc = NotionRubyMapping::NotionCache.instance
      response = nc.file_upload_request @id
      @status = response["status"]
      self
    end

    # Uploads a local file or one part of a multipart upload.
    #
    # @param fname [String] path of the file to upload
    # @param part_number [Integer] multipart part number
    # @return [void]
    # @raise [StandardError] if the upload response is invalid
    # @api private
    def single_file_upload(fname = @fname, part_number = 0)
      if @number_of_parts > 1
        options = {"part_number" => part_number}
        status = "pending"
      else
        options = {}
        status = "uploaded"
      end
      nc = NotionRubyMapping::NotionCache.instance
      response = nc.send_file_upload_request fname, @id, options
      return if nc.hex_id(response["id"]) == @id && response["status"] == status

      raise StandardError, "File upload failed: #{response}"
    end

    # Splits a file into temporary files.
    #
    # The caller is responsible for closing and deleting the returned files.
    #
    # @param org_file [String] path of the original file
    # @param max_size [Integer] maximum size of each part in bytes
    # @return [Array<Tempfile>] temporary file parts
    # @raise [StandardError] if the original file does not exist
    # @api private
    def self.split_to_small_files(org_file, max_size = MAX_SIZE)
      raise StandardError, "File does not exist: #{org_file}" unless File.exist?(org_file)

      temp_files = []
      File.open(org_file, "rb") do |file|
        until file.eof?
          chunk = file.read(max_size)
          temp_file = Tempfile.new("part_")
          temp_file.binmode
          temp_file.write(chunk)
          temp_file.rewind
          temp_files << temp_file
        end
      end
      temp_files
    end
  end
end
