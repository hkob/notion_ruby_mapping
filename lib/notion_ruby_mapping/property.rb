# frozen_string_literal: true

module NotionRubyMapping
  # abstract class for property
  class Property
    # @param [String] name Property name
    # @param [Hash] json
    # @return [Property] generated Property object
    def initialize(name, json: nil)
      @name = name
      @will_update = false
      @json = json
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
    # @param [Hash] input_json
    # @return [NotionRubyMapping::Property, nil] generated Property object
    def self.create_from_json(key, input_json)
      keys = input_json.keys
      if keys.include? "number"
        NumberProperty.new key, json: input_json["number"]
      elsif keys.include? "select"
        SelectProperty.new key, json: input_json["select"]
      elsif keys.include? "multi_select"
        MultiSelectProperty.new key, json: input_json["multi_select"]
      elsif keys.include? "date"
        DateProperty.new key, json: input_json["date"]
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
