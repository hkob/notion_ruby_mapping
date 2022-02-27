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
    def self.user_object(uo)
      if uo.is_a? UserObject
        uo
      else
        UserObject.new user_id: uo
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
