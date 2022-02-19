# frozen_string_literal: true

module NotionRubyMapping
  # Number property
  class NumberProperty < Property
    include EqualsDoesNotEqual
    include GreaterThanLessThan
    include IsEmptyIsNotEmpty
    TYPE = "number"

    # @param [String] name Property name
    # @param [Float] number Number value (optional)
    def initialize(name, number: nil)
      super(name)
      @number = number
    end
    attr_reader :number

    def create_json
      {"type" => "number", "number" => @number}
    end

    def number=(n)
      @will_update = true
      @number = n
    end
  end
end
