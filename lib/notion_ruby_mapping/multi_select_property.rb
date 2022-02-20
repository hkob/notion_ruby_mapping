# frozen_string_literal: true

module NotionRubyMapping
  # MultiSelect property
  class MultiSelectProperty < MultiProperty
    TYPE = "multi_select"

    # @param [String] name
    # @param [Hash] json
    # @param [Array] multi_select
    def initialize(name, json: nil, multi_select: nil)
      super(name, json: json)
      @multi_select = multi_select ? Array(multi_select) : nil
    end

    # @return [Hash] created json
    def create_json
      {"multi_select" => @multi_select ? (@multi_select.map { |v| {"name" => v} }) : @json} || {}
    end

    # @param [Hash] multi_select
    # @return [Array, nil] settled array
    def multi_select=(multi_select)
      @will_update = true
      @multi_select = multi_select ? Array(multi_select) : nil
    end
  end
end
