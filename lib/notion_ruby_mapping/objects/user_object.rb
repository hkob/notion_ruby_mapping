# frozen_string_literal: true

module NotionRubyMapping
  # TextObject
  class UserObject
    # @param [String] user_id
    # @return [TextObject]
    def initialize(user_id: nil, json: {})
      @user_id = user_id || json && json["id"]
      @json = json
      @will_update = false
    end
    attr_reader :will_update, :user_id

    # @param [UserObject, String] uo
    # @return [UserObject] self or created UserObject
    def self.user_object(user_id_or_user)
      if user_id_or_user.is_a? UserObject
        user_id_or_user
      else
        UserObject.new user_id: user_id_or_user
      end
    end

    # @return [String]
    def name
      @json["name"]
    end

    # @return [Hash]
    def property_values_json
      {
        "object" => "user",
        "id" => @user_id,
      }
    end
  end
end
