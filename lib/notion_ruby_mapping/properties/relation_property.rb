# frozen_string_literal: true

module NotionRubyMapping
  # MultiSelect property
  class RelationProperty < MultiProperty
    TYPE = "relation"

    ### Public announced methods

    ## Common methods

    # @return [Hash, Array, nil]
    # @see https://www.notion.so/hkob/RelationProperty-f608ab41a1f0476b98456620346fba03#6c14207b2d1340d2bbc08d17eee2cb22
    def relation
      @json
    end

    ## Page property only methods

    # @param [String, Hash] page_id_or_json
    # @see https://www.notion.so/hkob/RelationProperty-f608ab41a1f0476b98456620346fba03#52572d8745ef4b66bc34ba202c84b87c
    def add_relation(page_id_or_json)
      assert_page_property __method__
      @will_update = true
      @json << if page_id_or_json.is_a? String
                 {"id" => page_id_or_json}
               else
                 page_id_or_json
               end
    end

    # @param [String, Array<String>, Hash, Array<Hash>] page_ids_or_jsons
    # @return [Array] settled relation Array
    # @see https://www.notion.so/hkob/RelationProperty-f608ab41a1f0476b98456620346fba03#1025f772ecd64e678912a5036a95eda6
    def relation=(page_ids_or_jsons)
      assert_page_property __method__
      @will_update = true
      page_ids_or_jsons = [page_ids_or_jsons] unless page_ids_or_jsons.is_a? Array

      @json = page_ids_or_jsons.map do |page_id_or_json|
        page_id_or_json.is_a?(String) ? {"id" => page_id_or_json} : page_id_or_json
      end
    end

    ## Database property only methods

    # @return [String] relation database_id
    # @see https://www.notion.so/hkob/RelationProperty-f608ab41a1f0476b98456620346fba03#eb40f1a2ad5c4e368d343870a7e529f9
    def relation_database_id
      assert_database_property __method__
      @json["database_id"]
    end

    # @param [String] database_id
    # @param [String] synced_property_name
    # @see https://www.notion.so/hkob/RelationProperty-f608ab41a1f0476b98456620346fba03#7f5029fb7f6e4c009f22888b233e6f64
    def replace_relation_database(database_id: nil, type: "dual_property")
      assert_database_property __method__
      @will_update = true
      @json["database_id"] = database_id if database_id
      @json["type"] = type
      @json[type] = {}
      @json.delete type == "dual_property" ? "single_property" : "dual_property"
      @json
    end

    ### Not public announced methods

    ## Common methods

    # @param [String, Symbol] name
    # @param [Hash, Array] json
    # @param [String, Array] relation
    def initialize(name, will_update: false, json: nil, relation: nil, base_type: "page", property_id: nil,
                   property_cache: nil, query: nil)
      super name, will_update: will_update, base_type: base_type, property_id: property_id,
                  property_cache: property_cache, query: query
      @json = if database?
                json || {}
              elsif relation
                Array(relation).map { |r| {"id" => r} }
              else
                json || []
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

    def database_id
      @json["database_id"]
    end

    def synced_property_id
      @json["type"] == "dual_property" ? @json["dual_property"]["synced_property_id"] : nil
    end

    def synced_property_name
      @json["type"] == "dual_property" ? @json["dual_property"]["synced_property_name"] : nil
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
      @json
    end
  end
end
