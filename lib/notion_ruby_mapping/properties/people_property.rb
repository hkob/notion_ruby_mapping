# frozen_string_literal: true

module NotionRubyMapping
  # PeopleProperty class
  class PeopleProperty < MultiProperty
    TYPE = "people"

    ### Public announced methods

    ## Common methods

    # @return [Array, Hash]
    def people
      @json
    end

    ## Page property only methods

    # @param [String, NotionRubyMapping::UserObject] user_or_user_id
    # @return [Array<UserObject>]
    def add_person(user_or_user_id)
      @will_update = true
      @json << UserObject.user_object(user_or_user_id)
    end

    # @param [Hash] people
    # @return [Array, nil] replaced array
    def people=(people)
      @will_update = true
      @json = people ? Array(people).map { |uo| UserObject.user_object(uo) } : []
    end

    ### Not public announced methods

    ## Common methods

    # @param [String] name
    # @param [Hash] json
    # @param [Array] people ids for people
    def initialize(name, will_update: false, base_type: :page, json: nil, people: nil)
      super name, will_update: will_update, base_type: base_type
      @json = if database?
                {}
              elsif people
                Array(people).map { |uo| UserObject.user_object(uo) }
              elsif json
                json.map { |p| UserObject.new json: p }
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
      @json = database? ? {} : json["people"].map { |p_json| UserObject.new json: p_json }
    end
  end
end
