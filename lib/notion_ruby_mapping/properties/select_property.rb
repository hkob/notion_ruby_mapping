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
    def select
      @json
    end

    ## Page property only methods

    # @return [String]
    def select_name
      assert_page_property __method__
      @json["name"]
    end

    ## Database property only methods

    # @param [String] name
    # @param [String] color
    # @return [Array] added array
    def add_select_options(name:, color:)
      edit_select_options << {"name" => name, "color" => color}
    end

    # @return [Array] copyed multi select options
    def edit_select_options
      assert_database_property __method__
      @will_update = true
      @json["options"] ||= []
    end

    # @return [Array]
    def select_options
      assert_database_property __method__
      @json["options"] || []
    end

    # @return [String]
    def select_names
      assert_database_property __method__
      @json["options"].map { |s| s["name"] }
    end

    ## Page property only methods

    # @param [String] select
    # @return [Hash] settled value
    def select=(select)
      @will_update = true
      @json = {"name" => select}
    end

    ### Not public announced methods

    ## Common methods

    # @param [String] name Property name
    # @param [Hash] json
    # @param [String] select String value (optional)
    def initialize(name, will_update: false, base_type: :page, json: nil, select: nil)
      super name, will_update: will_update, base_type: base_type
      @json = if database?
                json || {"options" => []}
              else
                json || {"name" => select}
              end
    end

    ## Database property only methods

    # @return [Hash]
    def update_property_schema_json
      assert_database_property __method__
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
