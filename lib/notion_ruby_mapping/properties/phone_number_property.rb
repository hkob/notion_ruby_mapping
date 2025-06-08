# frozen_string_literal: true

module NotionRubyMapping
  # PhoneNumberProperty
  class PhoneNumberProperty < Property
    include EqualsDoesNotEqual
    include ContainsDoesNotContain
    include StartsWithEndsWith
    include IsEmptyIsNotEmpty
    TYPE = :phone_number

    ### Public announced methods

    ## Common methods

    # @return [String, Hash, nil] phone number (Page), {} (Database)
    # @see https://www.notion.so/hkob/PhoneNumberProperty-5df14aaa938c4888aecd53ab6752d2e6#40bceda04fe04c64b932d6a1ed180eaa
    def phone_number
      @json
    end

    ## Page property only methods

    # @param [String] phone_number
    # @see https://www.notion.so/hkob/PhoneNumberProperty-5df14aaa938c4888aecd53ab6752d2e6#dc7e00e0558d40f79ca5cade1fccef29
    def phone_number=(phone_number)
      assert_page_property __method__
      @will_update = true
      @json = phone_number
    end

    ### Not public announced methods

    ## Common methods

    # @param [String, Symbol] name Property name
    def initialize(name, will_update: false, base_type: :page, json: nil, property_id: nil, property_cache: nil)
      super name, will_update: will_update, base_type: base_type, property_id: property_id,
                  property_cache: property_cache
      @json = database? ? {} : json
    end

    ## Page property only methods
    # @return [Hash]
    def property_values_json
      assert_page_property __method__
      {@name => {phone_number: @json, type: "phone_number"}}
    end
  end
end
