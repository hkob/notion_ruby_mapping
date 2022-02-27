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
    def initialize(name, will_update: false, json: nil, select: nil)
      super name, will_update: will_update
      @select = select || json && json["name"]
    end

    # @param [Hash] json
    def update_from_json(json)
      @will_update = false
      @select = json["select"]["name"]
    end

    # @return [Hash]
    def property_values_json
      {@name => {"type" => "select", "select" => (@select ? {"name" => @select} : @json)}}
    end

    # @param [String] select
    # @return [String] settled value
    def select=(select)
      @will_update = true
      @select = select
    end
  end
end
