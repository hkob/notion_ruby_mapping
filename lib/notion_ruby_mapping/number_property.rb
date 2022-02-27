# frozen_string_literal: true

module NotionRubyMapping
  # Number property
  class NumberProperty < Property
    include EqualsDoesNotEqual
    include GreaterThanLessThan
    include IsEmptyIsNotEmpty
    TYPE = "number"

    # @param [String] name Property name
    # @param [Float, Integer] number Number value (optional)
    def initialize(name, will_update: false, number: nil)
      super name, will_update: will_update
      @number = number
    end
    attr_reader :number

    # @param [Hash] json
    def update_from_json(json)
      @will_update = false
      @number = json["number"]
    end

    # @return [Hash]
    def property_values_json
      {@name => {"number" => @number, "type" => "number"}}
    end

    def number=(num)
      @will_update = true
      @number = num
    end
  end
end
