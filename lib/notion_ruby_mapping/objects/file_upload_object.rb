# frozen_string_literal: true

class FileUploadObject
  MAX_SIZE = 10 * 1024 * 1024 # 10 MB
  # @param [String] id
  def initialize(fname:, external_url: nil)
    @fname = fname
    if external_url
      payload = {mode: "external_url", external_url: external_url, filename: fname}
      create payload
    else
      raise StandardError, "FileUploadObject requires a valid file name: #{fname}" unless File.exist?(fname)

      @file_size = File.size fname
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
  attr_reader :id, :fname, :status

  # @return [FileUploadObject]
  def create(payload)
    nc = NotionRubyMapping::NotionCache.instance
    response = nc.create_file_upload_request(payload)
    @id = nc.hex_id response["id"]
    @status = response["status"]
  end

  def reload
    nc = NotionRubyMapping::NotionCache.instance
    response = nc.file_upload_request @id
    @status = response["status"]
    self
  end

  # @param [String] fname
  # @param [Integer, NilClass] part_number
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
