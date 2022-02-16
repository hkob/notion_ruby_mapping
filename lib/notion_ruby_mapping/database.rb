# frozen_string_literal: true

module NotionRubyMapping
  # Notion database
  class Database < Base
    def self.find(id)
      NotionCache.instance.database id
    end

    # @param [String] id database_id (with or without "-")
    # @param [NotionRubyMapping::Query] query object
    def self.query(id, query = nil)
      query ||= Query.new
      NotionCache.instance.database_query(id, query)
    end

    # @param [String] id database_id (with or without "-")
    # @param [Payload] payload
    def update
      update_json @nc.update_database @id, @payload.create_json
    end
  end
end

