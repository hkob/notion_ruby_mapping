# frozen_string_literal: true

module NotionRubyMapping
  # abstract class for property
  class Property
    ### Public announced methods

    ## Common methods

    attr_reader :name, :will_update

    ## Database property only methods

    # @param [String] new_name
    def new_name=(new_name)
      assert_database_property __method__
      @will_update = true
      @new_name = new_name
    end

    # @return [NotionRubyMapping::Property] self
    def remove
      assert_database_property __method__
      @will_update = true
      @remove = true
      self
    end

    ### Not public announced methods

    ## Common methods

    # @param [String] name Property name
    # @return [Property] generated Property object
    def initialize(name, will_update: false, base_type: :page)
      @name = name
      @will_update = will_update
      @base_type = base_type
      @create = false
      @remove = false
      @new_name = nil
      @json = nil
    end

    # @param [String] name
    # @param [Hash] input_json
    # @return [NotionRubyMapping::Property, nil] generated Property object
    def self.create_from_json(name, input_json, base_type = :page)
      raise StandardError, "Property not found: #{name}:#{input_json}" if input_json.nil?

      type = input_json["type"]
      klass = {
        "checkbox" => CheckboxProperty,
        "created_time" => CreatedTimeProperty,
        "date" => DateProperty,
        "formula" => FormulaProperty,
        "last_edited_time" => LastEditedTimeProperty,
        "rollup" => RollupProperty,
        "email" => EmailProperty,
        "files" => FilesProperty,
        "created_by" => CreatedByProperty,
        "last_edited_by" => LastEditedByProperty,
        "multi_select" => MultiSelectProperty,
        "people" => PeopleProperty,
        "relation" => RelationProperty,
        "number" => NumberProperty,
        "phone_number" => PhoneNumberProperty,
        "select" => SelectProperty,
        "title" => TitleProperty,
        "rich_text" => RichTextProperty,
        "url" => UrlProperty,
      }[type]
      raise StandardError, "Irregular property type: #{type}" unless klass

      klass.new name, json: input_json[type], base_type: base_type
    end

    # @return [FalseClass]
    def clear_will_update
      @will_update = false
    end

    # @return [TrueClass, FalseClass] true if database property
    def database?
      @base_type == :database
    end

    # @param [String] key query parameter
    # @param [Object] value query value
    # @return [NotionRubyMapping::Query] generated Query object
    def make_filter_query(key, value, rollup = nil, rollup_type = nil)
      if rollup
        Query.new filter: {"property" => @name, rollup => {rollup_type => {key => value}}}
      elsif rollup_type
        Query.new filter: {"property" => @name, rollup_type => {key => value}}
      elsif @name == "__timestamp__"
        Query.new filter: {"timestamp" => type, type => {key => value}}
      else
        Query.new filter: {"property" => @name, type => {key => value}}
      end
    end

    # @return [TrueClass, FalseClass] true if page property
    def page?
      @base_type == :page
    end

    # @param [Hash] json
    def update_from_json(json)
      @will_update = false
      @json = json[type]
    end

    # @return [Symbol] property type
    def type
      self.class::TYPE
    end

    ## Database property only methods

    # @param [Symbol, nil] method
    def assert_database_property(method)
      raise StandardError, "#{method} can execute only Database property." unless database?
    end

    # @return [Hash]
    def property_schema_json
      assert_database_property __method__
      {@name => {type => property_schema_json_sub}}
    end

    # @return [Hash]
    def update_property_schema_json
      assert_database_property __method__
      if @remove
        {@name => nil}
      elsif @new_name
        {@name => {"name" => @new_name}}
      else
        {}
      end
    end

    ## Page property only methods

    # @param [Symbol, nil] method
    def assert_page_property(method)
      raise StandardError, "#{method} can execute only Page property." unless @base_type == :page
    end

    ## Page property only methods

    # @return [Hash] {} created_time cannot be updated
    def property_values_json
      assert_page_property __method__
      {}
    end

    protected

    ## Database property only methods

    # @return [Hash]
    def property_schema_json_sub
      {}
    end
  end

  # module for make query of equals and does_not_equal
  module EqualsDoesNotEqual
    ### Public announced methods

    # @param [String, Number] value Query value
    # @param [String] rollup Rollup name
    # @param [String] rollup_type Rollup type
    # @return [NotionRubyMapping::Query] generated Query object
    # @see https://www.notion.so/hkob/CheckboxProperty-ac1edbdb8e264af5ad1432b522b429fd#5f07c4ebc4744986bfc99a43827349fc
    def filter_equals(value, rollup = nil, rollup_type = nil)
      make_filter_query "equals", value, rollup, rollup_type
    end

    # @param [String, Number] value Query value
    # @param [String] rollup Rollup name
    # @param [String] rollup_type Rollup type
    # @return [NotionRubyMapping::Query] generated Query object
    # @see https://www.notion.so/hkob/CheckboxProperty-ac1edbdb8e264af5ad1432b522b429fd#a44a1875c3ef49f2b4f817291953a1d4
    def filter_does_not_equal(value, rollup = nil, rollup_type = nil)
      make_filter_query "does_not_equal", value, rollup, rollup_type
    end
  end

  # module for make query of contains and does_not_contain
  module ContainsDoesNotContain
    ### Public announced methods

    # @param [String] value Query value
    # @param [String] rollup Rollup name
    # @param [String] rollup_type Rollup type
    # @return [NotionRubyMapping::Query] generated Query object
    # @see https://www.notion.so/hkob/CreatedByProperty-945fa6be1c014da2b7e55a2b76e37b57#271a2ebaa1ec48acae732ca98920feab
    def filter_contains(value, rollup = nil, rollup_type = nil)
      make_filter_query "contains", value, rollup, rollup_type
    end

    # @param [String] value Query value
    # @param [String] rollup Rollup name
    # @param [String] rollup_type Rollup type
    # @return [NotionRubyMapping::Query] generated Query object
    # @see https://www.notion.so/hkob/CreatedByProperty-945fa6be1c014da2b7e55a2b76e37b57#b0328e3b146f48a4ad4c9c2ee5363486
    def filter_does_not_contain(value, rollup = nil, rollup_type = nil)
      make_filter_query "does_not_contain", value, rollup, rollup_type
    end
  end

  # module for make query of starts_with and ends_with
  module StartsWithEndsWith
    ### Public announced methods

    # @param [String] value Query value
    # @param [String] rollup Rollup name
    # @param [String] rollup_type Rollup type
    # @return [NotionRubyMapping::Query] generated Query object
    # @see https://www.notion.so/hkob/EmailProperty-39aeb5df56ea4cc1b9380574e4fdeec0#d3e098b2f38c4c8c9d3e815516cfd953
    def filter_starts_with(value, rollup = nil, rollup_type = nil)
      make_filter_query "starts_with", value, rollup, rollup_type
    end

    # @param [String] value Query value
    # @param [String] rollup Rollup name
    # @param [String] rollup_type Rollup type
    # @return [NotionRubyMapping::Query] generated Query object
    def filter_ends_with(value, rollup = nil, rollup_type = nil)
      make_filter_query "ends_with", value, rollup, rollup_type
    end
  end

  # module for make query of is_empty and is_not_empty
  module IsEmptyIsNotEmpty
    ### Public announced methods

    # @param [String] rollup Rollup name
    # @param [String] rollup_type Rollup type
    # @return [NotionRubyMapping::Query] generated Query object
    # @see https://www.notion.so/hkob/CreatedByProperty-945fa6be1c014da2b7e55a2b76e37b57#38749dfae0854c68b4c55095d3efbff1
    def filter_is_empty(rollup = nil, rollup_type = nil)
      make_filter_query "is_empty", true, rollup, rollup_type
    end

    # @param [String] rollup Rollup name
    # @param [String] rollup_type Rollup type
    # @return [NotionRubyMapping::Query] generated Query object
    # @see https://www.notion.so/hkob/CreatedByProperty-945fa6be1c014da2b7e55a2b76e37b57#515659ea52b54fb48c81b813f3b705f6
    def filter_is_not_empty(rollup = nil, rollup_type = nil)
      make_filter_query "is_not_empty", true, rollup, rollup_type
    end
  end

  # module for make query of starts_with and ends_with
  module GreaterThanLessThan
    ### Public announced methods

    # @param [Number] value Query value
    # @param [String] rollup Rollup name
    # @param [String] rollup_type Rollup type
    # @return [NotionRubyMapping::Query] generated Query object
    def filter_greater_than(value, rollup = nil, rollup_type = nil)
      make_filter_query "greater_than", value, rollup, rollup_type
    end

    # @param [Number] value Query value
    # @param [String] rollup Rollup name
    # @param [String] rollup_type Rollup type
    # @return [NotionRubyMapping::Query] generated Query object
    def filter_less_than(value, rollup = nil, rollup_type = nil)
      make_filter_query "less_than", value, rollup, rollup_type
    end

    # @param [Number] value Query value
    # @param [String] rollup Rollup name
    # @param [String] rollup_type Rollup type
    # @return [NotionRubyMapping::Query] generated Query object
    def filter_greater_than_or_equal_to(value, rollup = nil, rollup_type = nil)
      make_filter_query "greater_than_or_equal_to", value, rollup, rollup_type
    end

    # @param [Number] value Query value
    # @param [String] rollup Rollup name
    # @param [String] rollup_type Rollup type
    # @return [NotionRubyMapping::Query] generated Query object
    def filter_less_than_or_equal_to(value, rollup = nil, rollup_type = nil)
      make_filter_query "less_than_or_equal_to", value, rollup, rollup_type
    end
  end
end
