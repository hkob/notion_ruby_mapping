# frozen_string_literal: true

module NotionRubyMapping
  # LastEditedByProperty
  class LastEditedByProperty < MultiProperty
    TYPE = "last_edited_by"

    ### Public announced methods

    ## Common methods

    # @return [NotionRubyMapping::UserObject, Hash]
    def last_edited_by
      @json
    end

    ### Not public announced methods

    ## Common methods

    # @param [String] name Property name
    # @param [String] user_id user_id (optional)
    # @param [Hash] json json (optional)
    def initialize(name, will_update: false, base_type: :page, json: nil, user_id: nil)
      super name, will_update: will_update, base_type: base_type
      @json = if database?
                json || {}
              else
                UserObject.new user_id: user_id, json: json
              end
    end
    attr_reader :user

    # @param [Hash] json
    def update_from_json(json)
      @will_update = false
      leb = json["last_edited_by"]
      @json = database? ? leb : UserObject.new(json: leb)
    end
  end
end
