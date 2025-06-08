# frozen_string_literal: true

module NotionRubyMapping
  # CreatedByProperty
  class CreatedByProperty < MultiProperty
    TYPE = :created_by

    ### Public announced methods

    ## Common methods

    # @return [NotionRubyMapping::UserObject, Hash]
    # @see https://www.notion.so/hkob/CreatedByProperty-945fa6be1c014da2b7e55a2b76e37b57#d9c4a8d19b9b4ec5952dc86c9e4a25a8
    def created_by
      @json
    end

    ### Not public announced methods

    ## Common methods

    # @param [String, Symbol] name Property name
    # @param [String] user_id user_id (optional)
    # @param [Hash] json json (optional)
    def initialize(name, will_update: false, base_type: :page, json: nil, user_id: nil, property_id: nil,
                   property_cache: nil)
      super name, will_update: will_update, base_type: base_type, property_id: property_id,
                  property_cache: property_cache
      @json = if database?
                json || {}
              else
                UserObject.new user_id: user_id, json: json
              end
    end

    # @param [Hash] json
    def update_from_json(json)
      @will_update = false
      cb = json[:created_by]
      @json = database? ? cb : UserObject.new(json: cb)
    end

    ## Page property only methods
    # @return [Hash]
    def property_values_json
      assert_page_property __method__
      {}
    end
  end
end
