# frozen_string_literal: true

module NotionRubyMapping
  # LastEditedTimeProperty
  class LastEditedTimeProperty < DateBaseProperty
    TYPE = "last_edited_time"

    ### Public announced methods

    ## Common methods

    # @return [Date, Hash]
    # @see https://www.notion.so/hkob/LastEditedTimeProperty-5058fd594f6748a48fd4db52535f4c18#a7b568bf997c44d49cdbe4bfbf29824e
    def last_edited_time
      @json
    end

    ### Not public announced methods

    ## Common methods

    # @param [String, Symbol] name Property name
    # @param [String] json last_edited_time value (optional)
    def initialize(name, will_update: false, base_type: "page", json: nil, property_id: nil, property_cache: nil)
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
