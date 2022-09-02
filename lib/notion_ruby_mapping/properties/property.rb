# frozen_string_literal: true
#
require "forwardable"

module NotionRubyMapping
  # abstract class for property
  class Property
    extend Forwardable

    ### Public announced methods

    ## Common methods

    attr_reader :name, :will_update, :property_id
    attr_accessor :property_cache

    def_delegators :retrieve_page_property, :<<, :[], :add_person, :add_relation, :checkbox, :checkbox=, :created_by,
                   :created_time, :date, :each, :email, :email=, :end_date, :end_date=, :files, :files=, :filter_after,
                   :filter_before, :filter_contains, :filter_does_not_contain, :filter_does_not_equal,
                   :filter_ends_with, :filter_equals, :filter_greater_than, :filter_greater_than_or_equal_to,
                   :filter_is_empty, :filter_is_not_empty, :filter_less_than, :filter_less_than_or_equal_to,
                   :filter_next_month, :filter_next_week, :filter_next_year, :filter_on_or_after, :filter_on_or_before,
                   :filter_past_month, :filter_past_week, :filter_past_year, :filter_starts_with, :formula, :full_text,
                   :last_edited_by, :last_edited_time, :multi_select, :multi_select=, :multi_select_names, :number,
                   :number=, :people, :people=, :phone_number, :phone_number=, :property_values_json, :relation=,
                   :rollup, :start_date, :start_date=, :time_zone, :time_zone=, :select, :select=, :select_name, :url,
                   :url=

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
    def initialize(name, will_update: false, base_type: :page, property_id: nil, property_cache: nil, query: nil)
      @name = name
      @will_update = will_update
      @base_type = base_type
      @create = false
      @remove = false
      @new_name = nil
      @json = nil
      @property_id = property_id
      @property_cache = property_cache
      @query = query
    end

    # @param [String] name
    # @param [Hash] input_json
    # @return [NotionRubyMapping::Property, nil] generated Property object
    # @param [Symbol] base_type :page or :database
    # @param [String, nil] page_id
    def self.create_from_json(name, input_json, base_type = :page, property_cache = nil, query = nil)
      raise StandardError, "Property not found: #{name}:#{input_json}" if input_json.nil?

      type = input_json["type"]
      if type.nil?
        new name, property_id: input_json["id"], base_type: base_type, property_cache: property_cache, query: query
      elsif type == "property_item"
        tmp = new name, property_id: input_json["property_item"]["id"], base_type: base_type,
                  property_cache: property_cache, query: query
        objects = List.new(json: input_json, property: tmp, query: query).select { true }
        case input_json["property_item"]["type"]
        when "people"
          PeopleProperty.new name, people: objects, base_type: base_type,
                             property_cache: property_cache, query: query
        when "relation"
          RelationProperty.new name, relation: objects, base_type: base_type,
                               property_cache: property_cache, query: query
        when "rich_text"
          RichTextProperty.new name, text_objects: objects, base_type: base_type,
                               property_cache: property_cache, query: query
        when "rollup"
          RollupProperty.new name, json: objects, base_type: base_type,
                             property_cache: property_cache, query: query
        when "title"
          TitleProperty.new name, text_objects: objects, base_type: base_type,
                            property_cache: property_cache, query: query
        end
      else
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
          "relation" => RelationProperty,
          "number" => NumberProperty,
          "people" => PeopleProperty,
          "phone_number" => PhoneNumberProperty,
          "select" => SelectProperty,
          "status" => StatusProperty,
          "title" => TitleProperty,
          "rich_text" => RichTextProperty,
          "url" => UrlProperty,
        }[type]
        raise StandardError, "Irregular property type: #{type}" unless klass

        klass.new name, property_id: input_json["id"], json: input_json[type], base_type: base_type,
                  property_cache: property_cache
      end
    end

    # @return [FalseClass]
    def clear_will_update
      @will_update = false
    end

    # @return [TrueClass, FalseClass] true if database property
    def database?
      @base_type == :database
    end

    # @return [TrueClass, FalseClass] true if it has Property contents
    def contents?
      !instance_of? Property
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
      return unless contents?

      @json = json[type] if json[type] && json[type] != "property_item"
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

    # @return [NotionRubyMapping::Property, Array<UserObject>, nil]
    def retrieve_page_property
      assert_page_property __method__
      raise StandardError, "property_cache.page_id is empty" if @property_cache.page_id.nil?

      json = NotionCache.instance.page_property_request @property_cache.page_id, @property_id,
                                                        (@query&.query_json || {})
      new_property = self.class.create_from_json @name, json, :page, @property_cache, @query
      @property_cache.add_property new_property
      new_property
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
