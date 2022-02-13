# frozen_string_literal: true

module NotionRubyMapping
  # Notion database
  class Database < Base
    def self.find(key)
      NotionCache.instance.database key
    end

    def self.query(id, query = nil)
      query ||= Query.new
      NotionCache.instance.database_query(id, query)
    end
  end
end
