# frozen_string_literal: true

module NotionRubyMapping
  # Number property
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

    ## Database property only methods

    ## Page property only methods

    ### Not public announced methods

    ## Common methods

    # @param [String] name Property name
    # @param [Float, Integer, Hash] json Number value or format Hash
    def initialize(name, will_update: false, base_type: "page", json: nil, property_id: nil, property_cache: nil)
      super name, will_update: will_update, base_type: base_type, property_id: property_id, property_cache: property_cache
      @json = json
      @json ||= {} if database?
    end

    # @param [Hash] json
    # @return [NotionRubyMapping::NumberProperty]
    def update_from_json(json)
      @will_update = false
      @json = json["unique_id"]
      self
    end

    ## Database property only methods

    ## Page property only methods

    # @return [Hash]
    def property_values_json
      assert_page_property __method__
      {@name => {"unique_id" => @json, "type" => "unique_id"}}
    end

    ## Database property only methods
  end
end
