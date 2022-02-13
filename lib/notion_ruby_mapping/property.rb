# frozen_string_literal: true

module NotionRubyMapping
  # abstract class for property
  class Property
    def initialize(name)
      @name = name
    end
    attr_reader :name

    # @param [Symbol] key query parameter
    # @param [Object] value query value
    # @return [NotionRubyMapping::Query] generated Query object
    def make_filter_query(key, value)
      Query.new(filter: {property: @name, type => {key => value}})
    end

    # @return [Symbol] property type
    def type
      self.class::TYPE
    end
  end

  # module for make query of equals and does_not_equal
  module EqualsDoesNotEqual
    # @param [String, Number] value
    # @return [Object]
    def filter_equals(value)
      make_filter_query :equals, value
    end

    def filter_does_not_equal(value)
      make_filter_query :does_not_equal, value
    end
  end

  # module for make query of contains and does_not_contain
  module ContainsDoesNotContain
    def filter_contains(value)
      make_filter_query :contains, value
    end

    def filter_does_not_contain(value)
      make_filter_query :does_not_contain, value
    end
  end

  # module for make query of starts_with and ends_with
  module StartsWithEndsWith
    def filter_starts_with(value)
      make_filter_query :starts_with, value
    end

    def filter_ends_with(value)
      make_filter_query :ends_with, value
    end
  end

  # module for make query of is_empty and is_not_empty
  module IsEmptyIsNotEmpty
    def filter_is_empty
      make_filter_query :is_empty, true
    end

    def filter_is_not_empty
      make_filter_query :is_not_empty, true
    end
  end

  # module for make query of starts_with and ends_with
  module GreaterThanLessThan
    def filter_greater_than(value)
      make_filter_query :greater_than, value
    end

    def filter_less_than(value)
      make_filter_query :less_than, value
    end

    def filter_greater_than_or_equal_to(value)
      make_filter_query :greater_than_or_equal_to, value
    end

    def filter_less_than_or_equal_to(value)
      make_filter_query :less_than_or_equal_to, value
    end
  end
end
