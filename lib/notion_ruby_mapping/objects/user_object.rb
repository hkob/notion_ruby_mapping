# frozen_string_literal: true

module NotionRubyMapping
  # TextObject
  class UserObject
    # @param [String] user_id
    # @return [TextObject]
    def initialize(user_id: nil, json: {})
      @user_id = NotionCache.instance.hex_id(user_id || json && json["id"])
      @json = json
      @will_update = false
    end
    attr_reader :will_update, :user_id, :json

    # @param [Boolean] dry_run true if dry_run
    def self.all(dry_run: false)
      nc = NotionCache.instance
      if dry_run
        Base.dry_run_script :get, nc.users_path
      else
        nc.users
      end
    end

    # @param [String] user_id
    # @param [Boolean] dry_run true if dry_run
    # @return [NotionRubyMapping::UserObject, String]
    def self.find(user_id, dry_run: false)
      nc = NotionCache.instance
      if dry_run
        Base.dry_run_script :get, nc.user_path(user_id)
      else
        nc.user user_id
      end
    end

    # @param [Boolean] dry_run true if dry_run
    def self.find_me(dry_run: false)
      find "me", dry_run: dry_run
    end

    # @param [UserObject, String] uo
    # @return [UserObject] self or created UserObject
    def self.user_object(user_id_or_uo)
      if user_id_or_uo.is_a? UserObject
        user_id_or_uo
      else
        UserObject.new user_id: user_id_or_uo
      end
    end

    # @return [String (frozen)]
    def inspect
      "#{self.class.name}-#{@user_id}"
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

    def user_id=(new_user_id)
      @user_id = NotionCache.instance.hex_id new_user_id
      @will_update = true
    end
  end
end
