# frozen_string_literal: true

module NotionRubyMapping
  # MultiSelect property
  class MultiSelectProperty < MultiProperty
    include ContainsDoesNotContain
    include IsEmptyIsNotEmpty
    TYPE = "multi_select"

    ### Public announced methods

    ## Common methods

    # @return [Array, Hash]
    def multi_select
      @json
    end

    # @return [Array]
    def multi_select_names
      mshs = @base_type == :page ? @json : @json["options"]
      mshs.map { |h| h["name"] }
    end

    ## Database property only methods

    # @param [String] name
    # @param [String] color
    # @return [Array] added array
    def add_multi_select_options(name:, color:)
      edit_multi_select_options << {"name" => name, "color" => color}
    end

    # @return [Array] copyed multi select options
    def edit_multi_select_options
      assert_database_property __method__
      @will_update = true
      @json["options"] ||= []
    end

    # @return [Array]
    def multi_select_options
      assert_database_property __method__
      @json["options"] || []
    end

    ## Page property only methods

    # @param [Hash] multi_select
    # @return [Array, nil] settled array
    def multi_select=(multi_select)
      @will_update = true
      @json = multi_select ? Array(multi_select).map { |ms| {"name" => ms} } : []
    end

    ### Not public announced methods

    ## Common methods

    # @param [String] name
    # @param [Hash] json
    # @param [Array<String>, String] multi_select
    def initialize(name, will_update: false, base_type: :page, json: nil, multi_select: nil)
      super name, will_update: will_update, base_type: base_type
      if database?
        @json = json || {"options" => []}
      else
        @json = json || []
        @json = Array(multi_select).map { |ms| {"name" => ms} } unless multi_select.nil?
      end
    end

    ## Database property only methods

    # @return [Hash]
    def update_property_schema_json
      assert_database_property __method__
      ans = super
      return ans if ans != {} || !@will_update

      ans[@name] ||= {}
      ans[@name]["multi_select"] ||= {}
      ans[@name]["multi_select"]["options"] = @json["options"]
      ans
    end

    ## Page property only methods

    # @return [Hash] created json
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
