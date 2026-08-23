# frozen_string_literal: true

module NotionRubyMapping
  # Unique ID property
  class UniqueIdProperty < Property
    include EqualsDoesNotEqual
    include GreaterThanLessThan
    include IsEmptyIsNotEmpty
    TYPE = "unique_id"

    ### Public announced methods

    ## Common methods

    # @return [Hash, nil]
    def unique_id
      @json
    end

    # @return [String, nil]
    def prefix
      @json && @json["prefix"]
    end

    # @return [Integer, nil]
    def number
      @json && @json["number"]
    end

    ## Database property only methods

    # @param [String, nil] prefix
    # @return [String, nil]
    def prefix=(prefix)
      assert_database_or_data_source_property __method__
      @will_update = true
      @json["prefix"] = prefix
    end

    ## Page property only methods

    ### Not public announced methods

    ## Common methods

    # @param [String] name Property name
    # @param [Hash, nil] json unique_id Hash
    def initialize(name, will_update: false, base_type: "page", json: nil, property_id: nil, property_cache: nil)
      super name, will_update: will_update, base_type: base_type, property_id: property_id, property_cache: property_cache
      @json = json
      @json ||= {} if database_or_data_source?
    end

    # @param [Hash] json
    # @return [NotionRubyMapping::UniqueIdProperty]
    def update_from_json(json)
      @will_update = false
      @json = json["unique_id"]
      self
    end

    ## Database property only methods

    # @return [Hash]
    def update_property_schema_json
      assert_database_or_data_source_property __method__
      ans = super
      return ans if ans != {} || !@will_update

      ans[@name] ||= {}
      ans[@name]["unique_id"] = @json
      ans
    end

    ## Page property only methods

    # @return [Hash]
    def property_values_json
      assert_page_property __method__
      {@name => {"unique_id" => @json, "type" => "unique_id"}}
    end

    protected

    ## Database property only methods

    # @return [Hash]
    def property_schema_json_sub
      {"prefix" => prefix}
    end
  end
end
