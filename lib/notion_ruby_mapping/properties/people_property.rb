# frozen_string_literal: true

module NotionRubyMapping
  # PeopleProperty class
  class PeopleProperty < MultiProperty
    TYPE = "people"

    ### Public announced methods

    ## Common methods

    # @return [Array, Hash]
    # @see https://www.notion.so/hkob/PeopleProperty-144355d25f0e4feba9ae39fe28ca6ae7#7e3e56c2080d4834902cfa0223e807e5
    def people
      @json
    end

    ## Page property only methods

    # @param [String, NotionRubyMapping::UserObject] user_id_or_uo
    # @return [Array<UserObject>]
    # @see https://www.notion.so/hkob/PeopleProperty-144355d25f0e4feba9ae39fe28ca6ae7#26344b145a254cc58dd845780e0a26ea
    def add_person(user_id_or_uo)
      assert_page_property __method__
      @will_update = true
      @json << UserObject.user_object(user_id_or_uo)
    end

    # @param [Hash] people
    # @return [Array, nil] replaced array
    # @see https://www.notion.so/hkob/PeopleProperty-144355d25f0e4feba9ae39fe28ca6ae7#815acfef9a664e3e8915fb31b8fefc42
    def people=(people)
      assert_page_property __method__
      @will_update = true
      @json = people ? Array(people).map { |uo| UserObject.user_object(uo) } : []
    end

    ### Not public announced methods

    ## Common methods

    def self.people_from_json(json)
      if json.is_a? Array
        json.map { |sub_json| UserObject.new json: sub_json }
      elsif json["object"] == "list"
        List.new(json: json, type: :property, value: self).select { true }
      else
        json["people"].map { |sub_json| UserObject.new json: sub_json }
      end
    end

    # @param [String] name
    # @param [Hash] json
    # @param [Array] people ids for people
    def initialize(name, will_update: false, base_type: :page, json: nil, people: nil, property_id: nil,
                   property_cache: nil, query: nil)
      super name, will_update: will_update, base_type: base_type, property_id: property_id,
                  property_cache: property_cache, query: query
      @json = if database?
                {}
              elsif people
                Array(people).map { |uo| UserObject.user_object(uo) }
              elsif json
                PeopleProperty.people_from_json json
              else
                []
              end
    end

    ## Page property only methods

    # @return [Hash] created json
    def property_values_json
      assert_page_property __method__
      {
        @name => {
          "type" => "people",
          "people" => @json.map(&:property_values_json),
        },
      }
    end

    # @param [Array] json
    # @return [Hash, Array]
    def update_from_json(json)
      @will_update = false
      @json = database? ? {} : PeopleProperty.people_from_json(json)
    end
  end
end
