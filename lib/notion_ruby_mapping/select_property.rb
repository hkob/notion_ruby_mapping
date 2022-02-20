# frozen_string_literal: true

module NotionRubyMapping
  # Select property
  class SelectProperty < Property
    include EqualsDoesNotEqual
    include IsEmptyIsNotEmpty
    TYPE = "select"

    # @param [String] name Property name
    # @param [Hash] json
    # @param [String] select String value (optional)
    def initialize(name, json: nil, select: nil)
      super(name, json: json)
      @select = select
    end

    # @return [Hash]
    def create_json
      {"select" => @select ? {"name" => @select} : @json} || {}
    end

    # @param [String] select
    # @return [String] settled value
    def select=(select)
      @will_update = true
      @select = select
    end
  end
end