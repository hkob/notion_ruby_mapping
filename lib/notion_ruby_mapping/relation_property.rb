# frozen_string_literal: true

module NotionRubyMapping
  # MultiSelect property
  class RelationProperty < MultiProperty
    TYPE = "relation"

    ### Public announced methods

    ## Common methods

    # @return [Hash, Array]
    def relation
      @json
    end

    ## Database property only methods

    # @return [String] relation database_id
    def relation_database_id
      assert_database_property __method__
      @json["database_id"]
    end

    # @param [String] database_id
    # @param [String] synced_property_name
    def replace_relation_database(database_id: nil, synced_property_name: nil)
      assert_database_property __method__
      @will_update = true
      @json["database_id"] = database_id if database_id
      @json["synced_property_name"] = synced_property_name if synced_property_name
      @json
    end

    ### Not public announced methods

    ## Common methods

    # @param [String] name
    # @param [Hash, Array] json
    # @param [String, Array] relation
    def initialize(name, will_update: false, json: nil, relation: nil, base_type: :page)
      super name, will_update: will_update, base_type: base_type
      @json = if database?
                json || {}
              elsif relation
                Array(relation).map { |r| {"id" => r} }
              elsif json
                json
              else
                []
              end
    end

    ## Database property only methods

    # @return [Hash]
    def update_property_schema_json
      assert_database_property __method__
      ans = super
      return ans if ans != {} || !@will_update

      ans[@name] ||= {}
      ans[@name]["relation"] = @json
      ans
    end

    ## Page property only methods

    # @param [String, Array<String>] relation a id or Array of id
    # @return [Array] settled relation Array
    def relation=(page_ids)
      assert_page_property __method__
      @will_update = true
      @json = Array(page_ids).map { |r| {"id" => r} }
    end

    # @return [Hash] created json
    def property_values_json
      assert_page_property __method__
      {
        @name => {
          "type" => "relation",
          "relation" => @json,
        },
      }
    end

    protected

    ## Database property only methods

    # @return [Hash]
    def property_schema_json_sub
      {"database_id" => relation_database_id}
    end
  end
end
