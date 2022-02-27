# frozen_string_literal: true

module NotionRubyMapping
  # CreatedTimeProperty
  class CreatedTimeProperty < DateBaseProperty
    TYPE = "created_time"

    # @param [String] name Property name
    # @param [String] created_time created_time value (optional)
    def initialize(name, created_time: nil)
      super name, will_update: false
      @created_time = created_time
    end
    attr_reader :created_time

    # @param [Hash] json
    def update_from_json(json)
      @will_update = false
      @created_time = json["created_time"]
    end

    # @return [Hash] {} created_time cannot be updated
    def property_values_json
      {}
    end
  end
end
