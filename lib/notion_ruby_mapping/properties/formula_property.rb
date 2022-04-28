# frozen_string_literal: true

module NotionRubyMapping
  # Formula property
  class FormulaProperty < DateBaseProperty
    include ContainsDoesNotContain
    include StartsWithEndsWith
    include GreaterThanLessThan
    TYPE = "formula"

    ### Public announced methods

    ## Common methods

    # @return [Hash]
    def formula
      @json
    end

    ## Database property only methods

    def formula_expression
      assert_database_property __method__
      @json["expression"]
    end

    # @param [String] formula
    def formula_expression=(f_e)
      assert_database_property __method__
      @will_update = true
      @json["expression"] = f_e
    end

    ### Not public announced methods

    ## Common methods

    # @param [String] name
    # @param [Hash] json
    def initialize(name, will_update: false, base_type: :page, json: nil, formula: nil)
      super name, will_update: will_update, base_type: base_type
      @json = json || {}
      return unless database?

      @json["expression"] = formula if formula
    end

    ## Database property only methods

    # @return [Hash]
    def update_property_schema_json
      assert_database_property __method__
      ans = super
      return ans if ans != {} || !@will_update

      ans[@name] ||= {}
      ans[@name]["formula"] = @json
      ans
    end

    protected

    ## Database property only methods

    # @return [Hash]
    def property_schema_json_sub
      {"expression" => formula_expression}
    end
  end
end
