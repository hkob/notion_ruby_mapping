# frozen_string_literal: true

module NotionRubyMapping
  # CreatedByProperty
  class CreatedByProperty < MultiProperty
    TYPE = "created_by"

    # @param [String] name Property name
    # @param [String] user_id user_id (optional)
    # @param [Hash] json json (optional)
    def initialize(name, json: nil, user_id: nil)
      super name, will_update: false
      @user = UserObject.new user_id: user_id, json: json
    end
    attr_reader :user

    # @param [Hash] json
    def update_from_json(json)
      @will_update = false
      @user = UserObject.new json: json["created_by"]
    end

    # @return [Hash] {} created_time cannot be updated
    def property_values_json
      {}
    end
  end
end
