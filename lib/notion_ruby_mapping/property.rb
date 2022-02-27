# frozen_string_literal: true

module NotionRubyMapping
  # abstract class for property
  class Property
    # @param [String] name Property name
    # @return [Property] generated Property object
    def initialize(name, will_update: false)
      @name = name
      @will_update = will_update
    end
    attr_reader :name

    # @return [TrueClass, FalseClass]
    attr_reader :will_update

    # @param [String] key query parameter
    # @param [Object] value query value
    # @return [NotionRubyMapping::Query] generated Query object
    def make_filter_query(key, value, rollup = nil, rollup_type = nil)
      if rollup
        Query.new filter: {"property" => @name, rollup => {rollup_type => {key => value}}}
      else
        Query.new filter: {"property" => @name, type => {key => value}}
      end
    end

    # @return [Symbol] property type
    def type
      self.class::TYPE
    end

    # @param [String] name
    # @param [Hash] input_json
    # @return [NotionRubyMapping::Property, nil] generated Property object
    def self.create_from_json(name, input_json)
      raise StandardError, "Property not found: #{name}:#{input_json}" if input_json.nil?

      case input_json["type"]
      when "number"
        NumberProperty.new name, number: input_json["number"]
      when "select"
        SelectProperty.new name, json: input_json["select"]
      when "multi_select"
        MultiSelectProperty.new name, json: input_json["multi_select"]
      when "date"
        DateProperty.new name, json: input_json["date"]
      when "title"
        TitleProperty.new name, json: input_json["title"]
      when "rich_text"
        RichTextProperty.new name, json: input_json["rich_text"]
      when "checkbox"
        CheckboxProperty.new name, checkbox: input_json["checkbox"]
      when "people"
        PeopleProperty.new name, json: input_json["people"]
      when "email"
        EmailProperty.new name, email: input_json["email"]
      when "url"
        UrlProperty.new name, url: input_json["url"]
      when "phone_number"
        PhoneNumberProperty.new name, phone_number: input_json["phone_number"]
      when "files"
        FilesProperty.new name, json: input_json["files"]
      when "created_time"
        CreatedTimeProperty.new name, created_time: input_json["created_time"]
      when "last_edited_time"
        LastEditedTimeProperty.new name, last_edited_time: input_json["last_edited_time"]
      when "created_by"
        CreatedByProperty.new name, json: input_json["created_by"]
      when "last_edited_by"
        LastEditedByProperty.new name, json: input_json["last_edited_by"]
      when "formula"
        FormulaProperty.new name, json: input_json["formula"]
      when "rollup"
        RollupProperty.new name, json: input_json["rollup"]
      when "relation"
        RelationProperty.new name, json: input_json["relation"]
      else
        raise StandardError, "Irregular property type: #{input_json["type"]}"
      end
    end
  end

  # module for make query of equals and does_not_equal
  module EqualsDoesNotEqual
    # @param [String, Number] value Query value
    # @return [NotionRubyMapping::Query] generated Query object
    def filter_equals(value, rollup = nil, rollup_type = nil)
      make_filter_query "equals", value, rollup, rollup_type
    end

    # @param [String, Number] value Query value
    # @return [NotionRubyMapping::Query] generated Query object
    def filter_does_not_equal(value, rollup = nil, rollup_type = nil)
      make_filter_query "does_not_equal", value, rollup, rollup_type
    end
  end

  # module for make query of contains and does_not_contain
  module ContainsDoesNotContain
    # @param [String] value Query value
    # @return [NotionRubyMapping::Query] generated Query object
    def filter_contains(value, rollup = nil, rollup_type = nil)
      make_filter_query "contains", value, rollup, rollup_type
    end

    # @param [String] value Query value
    # @return [NotionRubyMapping::Query] generated Query object
    def filter_does_not_contain(value, rollup = nil, rollup_type = nil)
      make_filter_query "does_not_contain", value, rollup, rollup_type
    end
  end

  # module for make query of starts_with and ends_with
  module StartsWithEndsWith
    # @param [String] value Query value
    # @return [NotionRubyMapping::Query] generated Query object
    def filter_starts_with(value, rollup = nil, rollup_type = nil)
      make_filter_query "starts_with", value, rollup, rollup_type
    end

    # @param [String] value Query value
    # @return [NotionRubyMapping::Query] generated Query object
    def filter_ends_with(value, rollup = nil, rollup_type = nil)
      make_filter_query "ends_with", value, rollup, rollup_type
    end
  end

  # module for make query of is_empty and is_not_empty
  module IsEmptyIsNotEmpty
    # @return [NotionRubyMapping::Query] generated Query object
    def filter_is_empty(rollup = nil, rollup_type = nil)
      make_filter_query "is_empty", true, rollup, rollup_type
    end

    # @return [NotionRubyMapping::Query] generated Query object
    def filter_is_not_empty(rollup = nil, rollup_type = nil)
      make_filter_query "is_not_empty", true, rollup, rollup_type
    end
  end

  # module for make query of starts_with and ends_with
  module GreaterThanLessThan
    # @param [Number] value Query value
    # @return [NotionRubyMapping::Query] generated Query object
    def filter_greater_than(value, rollup = nil, rollup_type = nil)
      make_filter_query "greater_than", value, rollup, rollup_type
    end

    # @param [Number] value Query value
    # @return [NotionRubyMapping::Query] generated Query object
    def filter_less_than(value, rollup = nil, rollup_type = nil)
      make_filter_query "less_than", value, rollup, rollup_type
    end

    # @param [Number] value Query value
    # @return [NotionRubyMapping::Query] generated Query object
    def filter_greater_than_or_equal_to(value, rollup = nil, rollup_type = nil)
      make_filter_query "greater_than_or_equal_to", value, rollup, rollup_type
    end

    # @param [Number] value Query value
    # @return [NotionRubyMapping::Query] generated Query object
    def filter_less_than_or_equal_to(value, rollup = nil, rollup_type = nil)
      make_filter_query "less_than_or_equal_to", value, rollup, rollup_type
    end
  end
end
