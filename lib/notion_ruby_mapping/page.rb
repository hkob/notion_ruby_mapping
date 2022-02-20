# frozen_string_literal: true

module NotionRubyMapping
  # Notion page object
  class Page < Base
    def self.find(id)
      NotionCache.instance.page id
    end

    def update
      update_json @nc.update_page(@id, create_json)
    end

    # @return [Hash]
    def reload_json
      @nc.page_json @id
    end
  end
end
