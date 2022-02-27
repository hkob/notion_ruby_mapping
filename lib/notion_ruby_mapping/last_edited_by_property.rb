# frozen_string_literal: true

module NotionRubyMapping
  # LastEditedByProperty
  class LastEditedByProperty < MultiProperty
    TYPE = "last_edited_by"

    # @param [String] name Property name
    # @param [String] user_id user_id (optional)
    # @param [Hash] json json (optional)
    def initialize(name, user_id: nil, json: nil)
      super name, will_update: false
      @user = UserObject.new user_id: user_id, json: json
    end
    attr_reader :user

    # @param [Hash] json
    def update_from_json(json)
      @will_update = false
      @user = UserObject.new json: json["last_edited_by"]
    end

    # @return [Hash] {} created_time cannot be updated
    def property_values_json
      {}
    end
  end
end
