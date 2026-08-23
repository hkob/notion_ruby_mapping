# frozen_string_literal: true

module NotionRubyMapping
  # EmailProperty
  class EmailProperty < Property
    include EqualsDoesNotEqual
    include ContainsDoesNotContain
    include StartsWithEndsWith
    include IsEmptyIsNotEmpty
    TYPE = "email"

    ### Public announced methods

    ## Common methods

    # @return [String, Hash, nil] email address for page properties, empty hash for database/data source properties
    def email
      @json
    end

    ## Page property only methods

    # @param [String, nil] email
    def email=(email)
      assert_page_property __method__
      @will_update = true
      @json = email
    end

    ### Not public announced methods

    ## Common methods

    # @param [String, Symbol] name Property name
    def initialize(name, will_update: false, base_type: "page", json: nil, property_id: nil, property_cache: nil)
      super name, will_update: will_update, base_type: base_type, property_id: property_id,
                  property_cache: property_cache
      @json = database_or_data_source? ? {} : json
    end

    # @return [Hash]
    def property_values_json
      assert_page_property __method__
      {@name => {"email" => @json, "type" => "email"}}
    end
  end
end
