# frozen_string_literal: true

module NotionRubyMapping
  # Query object
  class Query
    def initialize(filter: {}, sort: [])
      @filter = filter
      @sort = sort
    end
    attr_reader :filter, :sort

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
  end
end
