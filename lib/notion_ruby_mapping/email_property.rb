# frozen_string_literal: true

module NotionRubyMapping
  # EmailProperty
  class EmailProperty < Property
    include EqualsDoesNotEqual
    include ContainsDoesNotContain
    include StartsWithEndsWith
    include IsEmptyIsNotEmpty
    TYPE = "email"

    # @param [String] name Property name
    # @param [String] email email value (optional)
    def initialize(name, will_update: false, email: nil)
      super name, will_update: will_update
      @email = email
    end
    attr_reader :email

    # @param [Hash] json
    def update_from_json(json)
      @will_update = false
      @email = json["email"]
    end

    # @return [Hash]
    def property_values_json
      {@name => {"email" => @email, "type" => "email"}}
    end

    def email=(email)
      @will_update = true
      @email = email
    end
  end
end
