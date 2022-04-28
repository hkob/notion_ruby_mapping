# frozen_string_literal: true

module NotionRubyMapping
  # Number property
  class NumberProperty < Property
    include EqualsDoesNotEqual
    include GreaterThanLessThan
    include IsEmptyIsNotEmpty
    TYPE = "number"

    ### Public announced methods

    ## Common methods

    # @return [Numeric, Hash]
    def number
      @json
    end

    ## Database property only methods

    # @return [String] new or settled format
    def format
      assert_database_property __method__
      @json["format"]
    end

    # @param [String] format
    # @return [String] settled format
    def format=(format)
      assert_database_property __method__
      @will_update = true
      @json["format"] = format
    end

    ## Page property only methods

    # @param [Numeric] num
    # @return [Numeric] settled number
    def number=(num)
      assert_page_property __method__
      @will_update = true
      @json = num
    end

    ### Not public announced methods

    ## Common methods

    # @param [String] name Property name
    # @param [Float, Integer, Hash] json Number value or format Hash
    def initialize(name, will_update: false, base_type: :page, json: nil, format: nil)
      super name, will_update: will_update, base_type: base_type
      @json = json
      @json ||= {"format" => (format || "number")} if database?
    end

    # @param [Hash] json
    # @return [NotionRubyMapping::NumberProperty]
    def update_from_json(json)
      @will_update = false
      @json = json["number"]
      self
    end

    ## Database property only methods

    # @return [Hash]
    def update_property_schema_json
      assert_database_property __method__
      ans = super
      return ans if ans != {} || !@will_update

      ans[@name] ||= {}
      ans[@name]["number"] = @json
      ans
    end

    ## Page property only methods

    # @return [Hash]
    def property_values_json
      assert_page_property __method__
      {@name => {"number" => @json, "type" => "number"}}
    end

    protected

    ## Database property only methods

    # @return [Hash]
    def property_schema_json_sub
      {"format" => format}
    end
  end
end
