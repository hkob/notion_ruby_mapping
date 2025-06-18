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
      payload = @number_of_parts == 1 ? {} : {number_of_parts: @number_of_parts, mode: "multi_part", filename: @fname}
      create payload
      single_file_upload if @number_of_parts == 1
    end
  end
  attr_reader :id, :fname

  # @return [FileUploadObject]
  def create(payload)
    nc = NotionRubyMapping::NotionCache.instance
    response = nc.create_file_upload_request(payload)
    @id = nc.hex_id response[:id]
  end

  def single_file_upload
    nc = NotionRubyMapping::NotionCache.instance
    response = nc.file_upload_request @fname, @id
    return if nc.hex_id(response[:id]) == @id && response[:status] == "uploaded"

    raise StandardError, "File upload failed: #{response}"
  end
end
