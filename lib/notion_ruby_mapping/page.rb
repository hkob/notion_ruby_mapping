# frozen_string_literal: true

module NotionRubyMapping
  # Notion page object
  class Page < Base
    def self.find(key)
      NotionCache.instance.page key
    end

    # @param [String] id page_id (with or without "-")
    # @param [Payload] payload
    def update
      update_json @nc.update_page(@id, payload.create_json)
    end
  end
end
