# frozen_string_literal: true

module NotionRubyMapping
  # PhoneNumberProperty
  class PhoneNumberProperty < Property
    include EqualsDoesNotEqual
    include ContainsDoesNotContain
    include StartsWithEndsWith
    include IsEmptyIsNotEmpty
    TYPE = "phone_number"

    ### Public announced methods

    ## Common methods

    # @return [String, Hash, nil] phone number (Page), {} (Database)
    def phone_number
      @json
    end

    ## Page property only methods

    def phone_number=(phone_number)
      @will_update = true
      @json = phone_number
    end

    ### Not public announced methods

    ## Common methods

    # @param [String] name Property name
    # @param [String] phone_number phone_number value (optional)
    def initialize(name, will_update: false, base_type: :page, json: nil)
      super name, will_update: will_update, base_type: base_type
      @json = database? ? {} : json
    end

    ## Page property only methods

    # @return [Hash]
    def property_values_json
      assert_page_property __method__
      {@name => {"phone_number" => @json, "type" => "phone_number"}}
    end
  end
end
