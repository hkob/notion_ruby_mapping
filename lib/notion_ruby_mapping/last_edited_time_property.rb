# frozen_string_literal: true

module NotionRubyMapping
  # LastEditedTimeProperty
  class LastEditedTimeProperty < DateBaseProperty
    TYPE = "last_edited_time"

    # @param [String] name Property name
    # @param [String] last_edited_time last_edited_time value (optional)
    def initialize(name, last_edited_time: nil)
      super name, will_update: false
      @last_edited_time = last_edited_time
    end
    attr_reader :last_edited_time

    # @param [Hash] json
    def update_from_json(json)
      @will_update = false
      @last_edited_time = json["last_edited_time"]
    end

    # @return [Hash] {} created_time cannot be updated
    def property_values_json
      {}
    end
  end
end
