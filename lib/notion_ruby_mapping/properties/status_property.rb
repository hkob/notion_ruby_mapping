# frozen_string_literal: true

module NotionRubyMapping
  # Status property
  class StatusProperty < Property
    TYPE = "status"

    ### Public announced methods

    ## Common methods

    def status
      @json
    end

    ### Not public announced methods

    ## Common methods

    # @param [String] name Property name
    # @param [Boolean, Hash] json
    def initialize(name, will_update: false, base_type: :page, property_cache: nil, json: {})
      super name, will_update: will_update, base_type: base_type, property_cache: property_cache
      @json = json
    end

    ## Page property only methods

    # @return [Hash]
    def property_values_json
      assert_page_property __method__
      {}
      #{@name => {"status" => @json, "type" => "status"}}
    end
  end
end
