# frozen_string_literal: true

module NotionRubyMapping
  # PhoneNumberProperty
  class PhoneNumberProperty < Property
    include EqualsDoesNotEqual
    include ContainsDoesNotContain
    include StartsWithEndsWith
    include IsEmptyIsNotEmpty
    TYPE = "phone_number"

    # @param [String] name Property name
    # @param [String] phone_number phone_number value (optional)
    def initialize(name, will_update: false, phone_number: nil)
      super name, will_update: will_update
      @phone_number = phone_number
    end
    attr_reader :phone_number

    # @param [Hash] json
    def update_from_json(json)
      @will_update = false
      @phone_number = json["phone_number"]
    end

    # @return [Hash]
    def property_values_json
      {@name => {"phone_number" => @phone_number, "type" => "phone_number"}}
    end

    def phone_number=(phone_number)
      @will_update = true
      @phone_number = phone_number
    end
  end
end
