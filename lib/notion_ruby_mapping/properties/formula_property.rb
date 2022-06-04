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
    # @see https://www.notion.so/hkob/FormulaProperty-d6b22ca70822407a9fef0bac8925cd0d#4fda982987a141ec962e4cd76cb81f76
    def formula
      @json
    end

    ## Database property only methods

    # @return [String] formula_expression
    # @see https://www.notion.so/hkob/FormulaProperty-d6b22ca70822407a9fef0bac8925cd0d#a24d2a7b99254d2a9226c00153f1d516
    def formula_expression
      assert_database_property __method__
      @json["expression"]
    end

    # @param [String] f_e
    # @see https://www.notion.so/hkob/FormulaProperty-d6b22ca70822407a9fef0bac8925cd0d#fdb3aaa8d0474440b7ed941673ee13b7
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
