# frozen_string_literal: true

module NotionRubyMapping
  # Notion database
  class Database < Base
    def self.find(key)
      NotionCache.instance.database key
    end

    # @param [String] id database_id (with or without "-")
    # @param [NotionRubyMapping::Query] query object
    def self.query(id, query = nil)
      query ||= Query.new
      NotionCache.instance.database_query(id, query)
    end

    # @param [String] id database_id (with or without "-")
    # @param [Hash] payload
    def update(id, payload)
      @nc.update_database(id, payload)
    end
  end
end
