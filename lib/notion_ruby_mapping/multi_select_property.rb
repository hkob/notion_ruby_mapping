# frozen_string_literal: true

module NotionRubyMapping
  # MultiSelect property
  class MultiSelectProperty < MultiProperty
    include ContainsDoesNotContain
    include IsEmptyIsNotEmpty
    TYPE = "multi_select"

    # @param [String] name
    # @param [Hash] json
    # @param [Array] multi_select
    def initialize(name, will_update: false, json: nil, multi_select: nil)
      super name, will_update: will_update
      @multi_select = if multi_select
                        Array(multi_select)
                      elsif json.is_a? Array
                        json.map { |ms| ms["name"] }
                      else
                        []
                      end
    end

    # @return [Hash] created json
    def property_values_json
      {
        @name => {
          "type" => "multi_select",
          "multi_select" => @multi_select.map { |v| {"name" => v} },
        },
      }
    end

    # @param [Hash] multi_select
    # @return [Array, nil] settled array
    def multi_select=(multi_select)
      @will_update = true
      @multi_select = multi_select ? Array(multi_select) : []
    end

    # @param [Hash] json
    def update_from_json(json)
      @will_update = false
      @multi_select = json["multi_select"].map { |ms| ms["name"] }
    end
  end
end
