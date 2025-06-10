# frozen_string_literal: true

module NotionRubyMapping
  # Notion block
  class UrlBaseBlock < Block
    # @param [Sting] url
    def initialize(url, json: nil, id: nil, parent: nil)
      raise StandardError, "UrlBaseBlock is abstract class" if instance_of?(UrlBaseBlock)

      super(json: json, id: id, parent: parent)
      @url = if @json
               @json[type][:url]
             else
               url
             end
    end

    attr_reader :url

    # @param [Boolean] not_update false when update
    # @return [Hash{String (frozen)->Hash}]
    def block_json(not_update: true)
      ans = super
      ans[type] = {url: @url}
      ans
    end

    # @param [String] str
    def url=(str)
      @url = str
      @payload.add_update_block_key :url
    end
  end
end
