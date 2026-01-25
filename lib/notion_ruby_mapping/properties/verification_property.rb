# frozen_string_literal: true

module NotionRubyMapping
  # Status property
  class VerificationProperty < Property
    TYPE = "verification"

    ### Public announced methods

    ## Common methods

    # @see https://www.notion.so/hkob/StatusProperty-c8b2c83019bc42edbc1527386c7ef453#bdb34c0aeaa74729887da087d0bd8022
    def verification
      @json
    end

    ## Page property only methods

    ## Page property only methods

    ### Not public announced methods

    ## Common methods

    # @param [String, Symbol] name Property name
    # @param [Boolean, Hash] json
    def initialize(name, will_update: false, base_type: "page", property_id: nil, property_cache: nil, json: {})
      super name, will_update: will_update, base_type: base_type, property_id: property_id,
                  property_cache: property_cache
      @json = json
    end

    ## DataSource only methods

    # @param [String, Number] value Query value
    # @param [String] condition rollup Rollup name
    # @param [String] another_type rollup_type Rollup type
    # @return [NotionRubyMapping::Query] generated Query object
    # @see https://www.notion.so/hkob/CheckboxProperty-ac1edbdb8e264af5ad1432b522b429fd#5f07c4ebc4744986bfc99a43827349fc
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
