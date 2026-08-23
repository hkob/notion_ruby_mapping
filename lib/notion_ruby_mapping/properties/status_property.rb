# frozen_string_literal: true

module NotionRubyMapping
  # Status property
  class StatusProperty < Property
    include EqualsDoesNotEqual
    include IsEmptyIsNotEmpty
    TYPE = "status"

    ### Public announced methods

    ## Common methods

    # @see https://www.notion.so/hkob/StatusProperty-c8b2c83019bc42edbc1527386c7ef453#bdb34c0aeaa74729887da087d0bd8022
    def status
      @json
    end

    ## Page property only methods

    # @return [String]
    # @see https://www.notion.so/hkob/StatusProperty-c8b2c83019bc42edbc1527386c7ef453#69452ceee6c9452296e96bb2a37460ee
    def status_name
      assert_page_property __method__
      @json["name"]
    end

    # @param [String] status
    # @see https://www.notion.so/hkob/StatusProperty-c8b2c83019bc42edbc1527386c7ef453#b3fba1b6322140f28308de3ba70a8b7b
    def status=(status)
      assert_page_property __method__
      @will_update = true
      @json = {"name" => status}
    end

    ## Database or DataSource property only methods
    # @param [String] name
    # @param [String] color
    # @return [Array<Hash>] updated status options
    def add_status_option(name:, color:, group: nil)
      hash = {"name" => name, "color" => color}
      hash["group"] = group if group
      edit_status_options << hash
    end

    # @return [Array<Hash>] editable status options
    def edit_status_options
      assert_database_or_data_source_property __method__
      @will_update = true
      @json["edit_options"] ||= []
    end

    # @return [Array<Hash>] status options
    def status_options
      assert_database_or_data_source_property __method__
      @json["options"] || []
    end

    # @return [Array<String>] status option names
    def status_names
      assert_database_or_data_source_property __method__
      status_options.map { |s| s["name"] }
    end

    ### Not public announced methods

    ## Common methods

    # @param [String, Symbol] name Property name
    # @param [Boolean, Hash] json
    def initialize(name, will_update: false, base_type: "page", property_id: nil, property_cache: nil, json: {})
      super name, will_update: will_update, base_type: base_type, property_id: property_id,
                  property_cache: property_cache
      @json = json
    end

    ## Page property only methods

    # @return [Hash]
    def property_values_json
      assert_page_property __method__
      {@name => {"status" => @json, "type" => "status"}}
    end

    ## Database property only methods

    # @return [Hash]
    def update_property_schema_json
      assert_database_or_data_source_property __method__
      ans = super
      return ans if ans != {} || !@will_update

      ans[@name] ||= {}
      ans[@name]["status"] ||= {}
      ans[@name]["status"]["options"] = @json["edit_options"]
      ans
    end

    ## Database property only methods

    # @return [Hash]
    def property_schema_json_sub
      @json["edit_options"] ? {"options" => @json["edit_options"]} : {}
    end
  end
end
