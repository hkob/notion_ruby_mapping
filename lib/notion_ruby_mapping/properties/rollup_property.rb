# frozen_string_literal: true

module NotionRubyMapping
  # Rollup property
  class RollupProperty < DateBaseProperty
    include ContainsDoesNotContain
    include StartsWithEndsWith
    include GreaterThanLessThan
    TYPE = "rollup"

    ### Public announced methods

    ## Common methods

    # @return [Hash]
    def rollup
      @json
    end

    ## Database property only methods

    # @return [String] new or settled function
    def function
      assert_database_property __method__
      @json["function"]
    end

    # @param [String] func
    def function=(func)
      assert_database_property __method__
      @will_update = true
      @json["function"] = func
    end

    # @return [String] new or settled relation_property_name
    def relation_property_name
      assert_database_property __method__
      @json["relation_property_name"]
    end

    # @param [String] rpn
    def relation_property_name=(rpn)
      assert_database_property __method__
      @will_update = true
      @json["relation_property_name"] = rpn
    end

    # @return [String] new or settled rollup_property_name
    def rollup_property_name
      assert_database_property __method__
      @json["rollup_property_name"]
    end

    # @param [String] rpn
    def rollup_property_name=(rpn)
      assert_database_property __method__
      @will_update = true
      @json["rollup_property_name"] = rpn
    end

    ### Not public announced methods

    ## Common methods

    # @param [String] name
    # @param [Hash] json
    def initialize(name, will_update: false, json: nil, base_type: :page)
      super name, will_update: will_update, base_type: base_type
      @json = json || {}
    end

    ## Database property only methods

    # @return [Hash]
    def update_property_schema_json
      assert_database_property __method__
      ans = super
      return ans if ans != {} || !@will_update

      ans[@name] ||= {}
      ans[@name]["rollup"] ||= {}
      ans[@name]["rollup"]["function"] = function
      ans[@name]["rollup"]["relation_property_name"] = relation_property_name
      ans[@name]["rollup"]["rollup_property_name"] = rollup_property_name
      ans
    end

    protected

    ## Database property only methods

    # @return [Hash]
    def property_schema_json_sub
      {
        "function" => function,
        "relation_property_name" => relation_property_name,
        "rollup_property_name" => rollup_property_name,
      }
    end
  end
end
