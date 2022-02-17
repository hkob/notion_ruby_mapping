# frozen_string_literal: true

module NotionRubyMapping
  # Notion page object
  class Page < Base
    def self.find(id)
      NotionCache.instance.page id
    end

    # @param [String] id page_id (with or without "-")
    # @param [Payload] payload
    def update
      update_json @nc.update_page(@id, create_json)
    end
    
    # @return [Hash]
    def reload_json
      @nc.page_json @id
    end
  end
end
