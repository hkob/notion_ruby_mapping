# frozen_string_literal: true

module NotionRubyMapping
  # Button property
  class PlaceProperty < Property
    TYPE = "place"

    ### Public announced methods

    ## Common methods

    # @return [Boolean, Hash, nil]
    def place
      @json
    end

    # @param [String, Symbol] name Property name
    # @param [Boolean, Hash] json
    def initialize(name, will_update: false, base_type: "page", property_id: nil, property_cache: nil, json: nil)
      super name, will_update: will_update, base_type: base_type, property_id: property_id,
                  property_cache: property_cache
      @json = json
    end

    ## Page property only methods

    # @return [Hash]
    def property_values_json
      assert_page_property __method__
      {@name => {"place" => @json, "type" => "place"}}
    end
  end
end
