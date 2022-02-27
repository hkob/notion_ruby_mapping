# frozen_string_literal: true

module NotionRubyMapping
  # Notion database
  class Database < Base
    def self.find(id)
      NotionCache.instance.database id
    end

    # @param [NotionRubyMapping::Query] query object
    def query_database(query = Query.new)
      response = @nc.database_query @id, query
      List.new json: response, database: self, query: query
    end

    # @return [NotionRubyMapping::Base]
    def update
      update_json @nc.update_database_request(@id, property_values_json)
    end

    protected

    # @return [Hash]
    def reload_json
      @nc.database_request @id
    end
  end
end
