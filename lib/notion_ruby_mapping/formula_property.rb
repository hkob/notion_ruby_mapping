# frozen_string_literal: true

module NotionRubyMapping
  # Formula property
  class FormulaProperty < DateBaseProperty
    include ContainsDoesNotContain
    include StartsWithEndsWith
    include GreaterThanLessThan
    TYPE = "formula"

    # @param [String] name
    # @param [Hash] json
    def initialize(name, json: nil)
      super name, will_update: false
      @json = json
    end

    # @param [Hash] json
    def update_from_json(json)
      @will_update = false
      @json = json["formula"]
    end

    # @return [Hash] {} created_time cannot be updated
    def property_values_json
      {}
    end
  end
end
