# frozen_string_literal: true

module NotionRubyMapping
  # Notion page object
  class Page < Base
    def self.find(key)
      NotionCache.instance.page key
    end
  end
end
