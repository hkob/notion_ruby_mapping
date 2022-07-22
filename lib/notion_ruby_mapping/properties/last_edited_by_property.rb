# frozen_string_literal: true

module NotionRubyMapping
  # LastEditedByProperty
  class LastEditedByProperty < MultiProperty
    TYPE = "last_edited_by"

    ### Public announced methods

    ## Common methods

    # @return [NotionRubyMapping::UserObject, Hash]
    # @see https://www.notion.so/hkob/LastEditedByProperty-18379cbaebda495393445e4152076d66#278312b8cece457aa1f4bdbb9a7af063
    def last_edited_by
      @json
    end

    ### Not public announced methods

    ## Common methods

    # @param [String] name Property name
    # @param [String] user_id user_id (optional)
    # @param [Hash] json json (optional)
    def initialize(name, will_update: false, base_type: :page, json: nil, user_id: nil, property_cache: nil)
      super name, will_update: will_update, base_type: base_type, property_cache: property_cache
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

    ## Page property only methods
    # @return [Hash]
    def property_values_json
      assert_page_property __method__
      {}
    end
  end
end
