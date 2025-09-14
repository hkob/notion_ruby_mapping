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

    # @return [Numeric, Hash, nil]
    # @see https://www.notion.so/hkob/NumberProperty-964ebc1948074d7ca8340187aa352d40#571b41dd33ae42039e6b982a502b7ac7
    def number
      @json
    end

    ## Database property only methods

    # @return [String] new or settled format
    # @see https://www.notion.so/hkob/NumberProperty-964ebc1948074d7ca8340187aa352d40#5e3682ed9e124d518f735b236787d7a7
    def format
      assert_database_or_data_source_property __method__
      @json["format"]
    end

    # @param [String] format
    # @return [String] settled format
    # @see https://www.notion.so/hkob/NumberProperty-964ebc1948074d7ca8340187aa352d40#89695432078643e48307c348e2983456
    def format=(format)
      assert_database_or_data_source_property __method__
      @will_update = true
      @json["format"] = format
    end

    ## Page property only methods

    # @param [Numeric] num
    # @return [Numeric] settled number
    # @see https://www.notion.so/hkob/NumberProperty-964ebc1948074d7ca8340187aa352d40#a3f28cc7029046878dfd694b5b33e8d8
    def number=(num)
      assert_page_property __method__
      @will_update = true
      @json = num
    end

    ### Not public announced methods

    ## Common methods

    # @param [String, Symbol] name Property name
    # @param [Float, Integer, Hash] json Number value or format Hash
    def initialize(name, will_update: false, base_type: "page", json: nil, format: nil, property_id: nil,
                   property_cache: nil)
      super name, will_update: will_update, base_type: base_type, property_id: property_id,
                  property_cache: property_cache
      @json = json
      @json ||= {"format" => format || "number"} if database_or_data_source?
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
      assert_database_or_data_source_property __method__
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
