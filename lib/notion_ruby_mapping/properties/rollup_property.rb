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
    # @see https://www.notion.so/hkob/RollupProperty-eb10fbac3a93436289e74e5c651e9134#4b5749f350e542e5a018030bde411fb9
    def rollup
      @json
    end

    ## Database property only methods

    # @return [String] new or settled function
    # @see https://www.notion.so/hkob/RollupProperty-eb10fbac3a93436289e74e5c651e9134#94021d4e6c0b44519443c1e1cc6b3aba
    def function
      assert_database_property __method__
      @json["function"]
    end

    # @param [String] func
    # @see https://www.notion.so/hkob/RollupProperty-eb10fbac3a93436289e74e5c651e9134#647c74803cac49a9b79199828157e17a
    def function=(func)
      assert_database_property __method__
      @will_update = true
      @json["function"] = func
    end

    # @return [String] new or settled relation_property_name
    # @see https://www.notion.so/hkob/RollupProperty-eb10fbac3a93436289e74e5c651e9134#684fc4739c4f4d6a9b93687f72cd8dad
    def relation_property_name
      assert_database_property __method__
      @json["relation_property_name"]
    end

    # @param [String] rpn
    # @see https://www.notion.so/hkob/RollupProperty-eb10fbac3a93436289e74e5c651e9134#a61c2100758841c381edd820aa88ac65
    def relation_property_name=(rpn)
      assert_database_property __method__
      @will_update = true
      @json["relation_property_name"] = rpn
    end

    # @return [String] new or settled rollup_property_name
    # @see https://www.notion.so/hkob/RollupProperty-eb10fbac3a93436289e74e5c651e9134#8ce9ee31a2e2473ab7ba21781e4b440d
    def rollup_property_name
      assert_database_property __method__
      @json["rollup_property_name"]
    end

    # @param [String] rpn
    # @see https://www.notion.so/hkob/RollupProperty-eb10fbac3a93436289e74e5c651e9134#66503f4472f2456aa9b383f03b1fe0a6
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
