# frozen_string_literal: true

module NotionRubyMapping
  # TextObject
  class FileObject
    # @param [String] url
    # @return [TextObject]
    def initialize(url: nil, json: {})
      if url
        @type = "external"
        @url = url
      elsif json
        @type = json["type"]
        @url = json[@type]["url"]
        @expiry_time = json[@type]["expiry_time"]
      else
        raise StandardError, "FileObject requires url: or json:"
      end
      @will_update = false
    end
    attr_reader :will_update, :url, :type

    # @param [FileObject, String] uo
    # @return [FileObject] self or created FileObject
    # @see https://www.notion.so/hkob/FileObject-6218c354e985423a90904f47a985be33#54b37c567e1d4dfcab06f6d8f8fd412e
    def self.file_object(url_or_fo)
      if url_or_fo.is_a? FileObject
        url_or_fo
      else
        FileObject.new url: url_or_fo
      end
    end

    # @return [TrueClass, FalseClass] true if "type" is "external"
    def external?
      @type == "external"
    end

    # @param [String] url
    # @see https://www.notion.so/hkob/FileObject-6218c354e985423a90904f47a985be33#6b841f75d0234a1aac93fb54348abb96
    def url=(url)
      @url = url
      @type = "external"
      @expiry_time = nil
      @will_update = true
    end

    # @return [Hash]
    def property_values_json
      ans = {
        "type" => @type,
        @type => {
          "url" => @url,
        },
      }
      ans[@type]["expiry_time"] = @expiry_time if @expiry_time
      ans
    end
  end
end
