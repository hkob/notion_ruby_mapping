# frozen_string_literal: true

module NotionRubyMapping
  # Number property
  class NumberProperty < Property
    include EqualsDoesNotEqual
    include GreaterThanLessThan
    include IsEmptyIsNotEmpty
    TYPE = "number"

    # @param [String] name Property name
    # @param [Hash] json
    # @param [Float] number Number value (optional)
    def initialize(name, json: nil, number: nil)
      super(name, json: json)
      @number = number
    end
    attr_reader :number

    # @return [Hash]
    def create_json
      {"number" => @number || @json}
    end

    def number=(n)
      @will_update = true
      @number = n
    end
  end
end
