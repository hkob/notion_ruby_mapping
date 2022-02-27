# frozen_string_literal: true

module NotionRubyMapping
  # MultiSelect property
  class RelationProperty < MultiProperty
    TYPE = "relation"

    # @param [String] name
    # @param [Hash] json
    # @param [String, Array<String>] relation
    def initialize(name, will_update: false, json: nil, relation: nil)
      super name, will_update: will_update
      @relation = if relation
                    Array(relation)
                  elsif json
                    json.map { |r| r["id"] }
                  else
                    []
                  end
    end

    # @param [String, Array<String>] relation a id or Array of id
    # @return [Array<String>] settled relation Array
    def relation=(relation)
      @will_update = true
      @relation = Array(relation)
    end

    # @param [Hash] json
    def update_from_json(json)
      @will_update = false
      @relation = json["relation"].map { |r| r["id"] }
    end

    # @return [Hash] created json
    def property_values_json
      {
        @name => {
          "type" => "relation",
          "relation" => @relation.map { |rid| {"id" => rid} },
        },
      }
    end
  end
end
