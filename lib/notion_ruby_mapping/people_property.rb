# frozen_string_literal: true

module NotionRubyMapping
  # PeopleProperty class
  class PeopleProperty < MultiProperty
    TYPE = "people"

    # @param [String] name
    # @param [Hash] json
    # @param [Array] people ids for people
    def initialize(name, will_update: false, json: nil, people: nil)
      super name, will_update: will_update
      @people = if people
                  Array(people).map { |uo| UserObject.user_object(uo) }
                elsif json
                  json.map { |p| UserObject.new json: p }
                else
                  []
                end
    end

    # @return [Hash] created json
    def property_values_json
      {
        @name => {
          "type" => "people",
          "people" => @people.map(&:property_values_json),
        },
      }
    end

    # @param [Hash] json
    def update_from_json(json)
      @will_update = false
      @people = json["people"].map { |pjson| UserObject.new json: pjson }
    end

    # @param [Hash] people
    # @return [Array, nil] settled array
    def people=(people)
      @will_update = true
      @people = people ? Array(people).map { |uo| UserObject.user_object(uo) } : []
    end
  end
end
