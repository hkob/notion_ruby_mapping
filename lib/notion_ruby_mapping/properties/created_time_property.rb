# frozen_string_literal: true

module NotionRubyMapping
  # CreatedTimeProperty
  class CreatedTimeProperty < DateBaseProperty
    TYPE = "created_time"

    ### Public announced methods

    ## Common methods

    # @return [Date, Hash]
    # @see https://www.notion.so/hkob/CreatedTimeProperty-bb979ff02dc04efa9733da1003efa871#f1e80400878346c3a9ba8e32b824ed2b
    def created_time
      @json
    end

    ### Not public announced methods

    ## Common methods

    # @param [String] name Property name
    # @param [String] json created_time value (optional)
    def initialize(name, will_update: false, base_type: :page, json: nil, property_id: nil, property_cache: nil)
      super name, will_update: will_update, base_type: base_type, property_id: property_id,
                  property_cache: property_cache
      @json = json
      @json ||= {} if database?
    end

    ## Page property only methods
    # @return [Hash]
    def property_values_json
      assert_page_property __method__
      {}
    end
  end
end
