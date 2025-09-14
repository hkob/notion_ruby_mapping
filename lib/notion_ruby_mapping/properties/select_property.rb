# frozen_string_literal: true

module NotionRubyMapping
  # Select property
  class SelectProperty < Property
    include EqualsDoesNotEqual
    include IsEmptyIsNotEmpty
    TYPE = "select"

    ### Public announced methods

    ## Common methods

    # @return [Hash]
    # @see https://www.notion.so/hkob/SelectProperty-6d6a0defa70d4b26af0fdbdcfbf99f28#7ad3734ac42c43068f1e04633bab400b
    def select
      @json
    end

    ## Page property only methods

    # @return [String]
    # @see https://www.notion.so/hkob/SelectProperty-6d6a0defa70d4b26af0fdbdcfbf99f28#27a05e52715a4acd9156b5f146653e51
    def select_name
      assert_page_property __method__
      @json["name"]
    end

    ## Database property only methods

    # @param [String] name
    # @param [String] color
    # @return [Array] added array
    # @see https://www.notion.so/hkob/SelectProperty-6d6a0defa70d4b26af0fdbdcfbf99f28#3e1c7dbda7fb455f94ee93d9653b7880
    def add_select_option(name:, color:)
      edit_select_options << {"name" => name, "color" => color}
    end

    # @return [Array] copyed multi select options
    def edit_select_options
      assert_database_or_data_source_property __method__
      @will_update = true
      @json["options"] ||= []
    end

    # @return [Array]
    # @see https://www.notion.so/hkob/SelectProperty-6d6a0defa70d4b26af0fdbdcfbf99f28#790a297f2c1b4ba5a4d86074d4c70a89
    def select_options
      assert_database_or_data_source_property __method__
      @json["options"] || []
    end

    # @return [String]
    # @see https://www.notion.so/hkob/SelectProperty-6d6a0defa70d4b26af0fdbdcfbf99f28#72da1632793c4a5296f3bc89de2df413
    def select_names
      assert_database_or_data_source_property __method__
      @json["options"].map { |s| s["name"] }
    end

    ## Page property only methods

    # @param [String] select
    # @see https://www.notion.so/hkob/SelectProperty-6d6a0defa70d4b26af0fdbdcfbf99f28#3bd195bf5c0a498ebf850409f7deb67a
    def select=(select)
      assert_page_property __method__
      @will_update = true
      @json = {"name" => select}
    end

    ### Not public announced methods

    ## Common methods

    # @param [String, Symbol] name Property name
    # @param [Hash] json
    # @param [String] select String value (optional)
    def initialize(name, will_update: false, base_type: "page", json: nil, select: nil, property_id: nil,
                   property_cache: nil)
      super name, will_update: will_update, base_type: base_type, property_id: property_id,
                  property_cache: property_cache
      @json = if database_or_data_source?
                json || {"options" => []}
              else
                json || {"name" => select}
              end
    end

    ## Database property only methods

    # @return [Hash]
    def update_property_schema_json
      assert_database_or_data_source_property __method__
      ans = super
      return ans if ans != {} || !@will_update

      ans[@name] ||= {}
      ans[@name]["select"] ||= {}
      ans[@name]["select"]["options"] = @json["options"]
      ans
    end

    ## Page property only methods

    # @return [Hash]
    def property_values_json
      assert_page_property __method__
      {@name => {"type" => "select", "select" => @json}}
    end

    protected

    ## Database property only methods

    # @return [Hash]
    def property_schema_json_sub
      {"options" => edit_select_options}
    end
  end
end
