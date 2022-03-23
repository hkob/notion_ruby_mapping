# frozen_string_literal: true

module NotionRubyMapping
  # Query object
  class Query
    def initialize(filter: {}, sort: [], page_size: 100, start_cursor: nil)
      @filter = filter
      @sort = sort
      @page_size = page_size
      @start_cursor = start_cursor
    end
    attr_reader :filter, :sort, :page_size
    attr_accessor :start_cursor

    # @param [Query] other_query other query
    # @return [NotionRubyMapping::Query] updated self (Query object)
    def and(other_query)
      if @filter.key? "and"
        @filter["and"] << other_query.filter
      else
        @filter = {"and" => [@filter, other_query.filter]}
      end
      self
    end

    # @param [Query] other_query other query
    # @return [NotionRubyMapping::Query] updated self (Query object)
    def or(other_query)
      if @filter.key? "or"
        @filter["or"] << other_query.filter
      else
        @filter = {"or" => [@filter, other_query.filter]}
      end
      self
    end

    # @param [NotionRubyMapping::Property] property
    # @return [NotionRubyMapping::Query] updated self (Query object)
    def ascending(property)
      key = property.is_a?(LastEditedTimeProperty) || property.is_a?(CreatedTimeProperty) ? "timestamp" : "property"
      @sort << {key => property.name, "direction" => "ascending"}
      self
    end

    # @param [NotionRubyMapping::Property] property
    # @return [NotionRubyMapping::Query] updated self (Query object)
    def descending(property)
      key = property.is_a?(LastEditedTimeProperty) || property.is_a?(CreatedTimeProperty) ? "timestamp" : "property"
      @sort << {key => property.name, "direction" => "descending"}
      self
    end

    # @return [Hash]
    def query_json
      parameters = {}
      parameters[:filter] = filter unless filter.empty?
      parameters[:sorts] = sort unless sort.empty?
      parameters[:start_cursor] = start_cursor if start_cursor
      parameters[:page_size] = page_size if page_size
      parameters
    end
  end
end
