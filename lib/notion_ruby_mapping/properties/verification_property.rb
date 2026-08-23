# frozen_string_literal: true

module NotionRubyMapping
  # Verification property
  class VerificationProperty < Property
    TYPE = "verification"

    ### Public announced methods

    ## Common methods

    def verification
      @json
    end

    ### Not public announced methods

    ## Common methods

    # @param [String, Symbol] name Property name
    # @param [Hash] json
    def initialize(name, will_update: false, base_type: "page", property_id: nil, property_cache: nil, json: {})
      super name, will_update: will_update, base_type: base_type, property_id: property_id,
                  property_cache: property_cache
      @json = json
    end

    ## DataSource only methods

    # Creates a filter query for the verification status.
    #
    # @param [String] value Verification status. Expected values are "verified", "expired", and "none".
    # @param [String, nil] condition Rollup condition name.
    # @param [String, nil] another_type Rollup target type.
    # @return [NotionRubyMapping::Query] Generated Query object.
    def filter_status(value, condition: nil, another_type: nil)
      make_filter_query "status", value, condition: condition, another_type: another_type
    end

    ## Page property only methods

    # @return [Hash]
    def property_values_json
      assert_page_property __method__
      {@name => {"verification" => @json, "type" => TYPE}}
    end
  end
end
