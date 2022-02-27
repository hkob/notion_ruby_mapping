# frozen_string_literal: true

module NotionRubyMapping
  # Checkbox property
  class CheckboxProperty < Property
    include EqualsDoesNotEqual
    TYPE = "checkbox"

    # @param [String] name Property name
    # @param [Boolean] checkbox Number value (optional)
    def initialize(name, will_update: false, checkbox: false)
      super name, will_update: will_update
      @checkbox = checkbox
    end
    attr_reader :checkbox

    # @param [Boolean] flag
    # @return [TrueClass, FalseClass] settled value
    def checkbox=(flag)
      @will_update = true
      @checkbox = flag
    end

    # @param [Hash] json
    def update_from_json(json)
      @will_update = false
      @checkbox = json["checkbox"]
    end

    # @return [Hash]
    def property_values_json
      {@name => {"checkbox" => @checkbox, "type" => "checkbox"}}
    end
  end
end
