# frozen_string_literal: true

module NotionRubyMapping
  # abstract class for property
  class Property
    # @param [String] name Property name
    # @return [Property] generated Property object
    def initialize(name)
      @name = name
      @will_update = false
    end
    attr_reader :name
    attr_accessor :will_update

    # @param [String] key query parameter
    # @param [Object] value query value
    # @return [NotionRubyMapping::Query] generated Query object
    def make_filter_query(key, value)
      Query.new(filter: {"property" => @name, type => {key => value}})
    end

    # @return [Symbol] property type
    def type
      self.class::TYPE
    end

    # @param [String] key
    # @param [Hash] json
    # @return [NotionRubyMapping::NumberProperty, nil] generated Property object
    def self.create_from_json(key, json)
      case json["type"]
      when "number"
        NumberProperty.new key, number: json["number"]
      else
        nil
      end
    end
  end

  # module for make query of equals and does_not_equal
  module EqualsDoesNotEqual
    # @param [String, Number] value Query value
    # @return [NotionRubyMapping::Query] generated Query object
    def filter_equals(value)
      make_filter_query "equals", value
    end

    # @param [String, Number] value Query value
    # @return [NotionRubyMapping::Query] generated Query object
    def filter_does_not_equal(value)
      make_filter_query "does_not_equal", value
    end
  end

  # module for make query of contains and does_not_contain
  module ContainsDoesNotContain
    # @param [String] value Query value
    # @return [NotionRubyMapping::Query] generated Query object
    def filter_contains(value)
      make_filter_query "contains", value
    end

    # @param [String] value Query value
    # @return [NotionRubyMapping::Query] generated Query object
    def filter_does_not_contain(value)
      make_filter_query "does_not_contain", value
    end
  end

  # module for make query of starts_with and ends_with
  module StartsWithEndsWith
    # @param [String] value Query value
    # @return [NotionRubyMapping::Query] generated Query object
    def filter_starts_with(value)
      make_filter_query "starts_with", value
    end

    # @param [String] value Query value
    # @return [NotionRubyMapping::Query] generated Query object
    def filter_ends_with(value)
      make_filter_query "ends_with", value
    end
  end

  # module for make query of is_empty and is_not_empty
  module IsEmptyIsNotEmpty
    # @return [NotionRubyMapping::Query] generated Query object
    def filter_is_empty
      make_filter_query "is_empty", true
    end

    # @return [NotionRubyMapping::Query] generated Query object
    def filter_is_not_empty
      make_filter_query "is_not_empty", true
    end
  end

  # module for make query of starts_with and ends_with
  module GreaterThanLessThan
    # @param [Number] value Query value
    # @return [NotionRubyMapping::Query] generated Query object
    def filter_greater_than(value)
      make_filter_query "greater_than", value
    end

    # @param [Number] value Query value
    # @return [NotionRubyMapping::Query] generated Query object
    def filter_less_than(value)
      make_filter_query "less_than", value
    end

    # @param [Number] value Query value
    # @return [NotionRubyMapping::Query] generated Query object
    def filter_greater_than_or_equal_to(value)
      make_filter_query "greater_than_or_equal_to", value
    end

    # @param [Number] value Query value
    # @return [NotionRubyMapping::Query] generated Query object
    def filter_less_than_or_equal_to(value)
      make_filter_query "less_than_or_equal_to", value
    end
  end
end
