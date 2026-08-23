# frozen_string_literal: true

module NotionRubyMapping
  # MultiSelect property
  class MultiSelectProperty < MultiProperty
    TYPE = "multi_select"

    ### Public announced methods

    ## Common methods

    # @return [Array<Hash>, Hash] raw multi_select array for page property, or multi_select schema object for database/data_source property
    def multi_select
      @json
    end

    # @return [Array<String>] selected option names for page property, or schema option names for database/data_source property
    def multi_select_names
      mshs = @base_type == "page" ? @json : @json["options"]
      mshs.map { |h| h["name"] }
    end

    ## Database property only methods

    # @param [String] name
    # @param [String] color
    # @return [Array<Hash>] updated multi_select options
    # @see https://www.notion.so/hkob/MultiSelectProperty-b90bba1c55d540ba97131bb013d4ca74#bcac830b00e04cb6bf7dbbb110d95667
    def add_multi_select_option(name:, color:)
      edit_multi_select_options << {"name" => name, "color" => color}
    end

    # @return [Array<Hash>] editable multi_select options
    def edit_multi_select_options
      assert_database_or_data_source_property __method__
      @will_update = true
      @json["options"] ||= []
    end

    # @return [Array<Hash>] schema multi_select options
    # @see https://www.notion.so/hkob/MultiSelectProperty-b90bba1c55d540ba97131bb013d4ca74#5ff6ec299cf64049bde2416f61b30fa9
    def multi_select_options
      assert_database_or_data_source_property __method__
      @json["options"] || []
    end

    ## Page property only methods

    # @param [String, Array<String>, nil] multi_select selected option name or names
    # @return [Array<Hash>] settled array
    def multi_select=(multi_select)
      assert_page_property __method__
      @will_update = true
      @json = multi_select ? Array(multi_select).map { |ms| {"name" => ms} } : []
    end

    ### Not public announced methods

    ## Common methods

    # @param [String, Symbol] name
    # @param [Hash, nil] json
    # @param [String, Array<String>, nil] multi_select selected option name or names (optional)
    def initialize(name, will_update: false, base_type: "page", json: nil, multi_select: nil,
                   property_id: nil, property_cache: nil)
      super name, will_update: will_update, base_type: base_type, property_id: property_id,
                  property_cache: property_cache
      if database_or_data_source?
        @json = json || {"options" => []}
      else
        @json = json || []
        @json = Array(multi_select).map { |ms| {"name" => ms} } unless multi_select.nil?
      end
    end

    ## Database property only methods

    # @return [Hash]
    def update_property_schema_json
      assert_database_or_data_source_property __method__
      ans = super
      return ans if ans != {} || !@will_update

      ans[@name] ||= {}
      ans[@name]["multi_select"] ||= {}
      ans[@name]["multi_select"]["options"] = @json["options"]
      ans
    end

    ## Page property only methods

    # @return [Hash] page property values payload
    def property_values_json
      assert_page_property __method__
      {
        @name => {
          "type" => "multi_select",
          "multi_select" => @json,
        },
      }
    end

    protected

    ## Database property only methods

    # @return [Hash]
    def property_schema_json_sub
      {"options" => edit_multi_select_options}
    end
  end
end
