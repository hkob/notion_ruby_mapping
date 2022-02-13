# frozen_string_literal: true

module NotionRubyMapping
  # Notion block
  class Block < Base
    def self.find(key)
      NotionCache.instance.block key
    end
  end
end
