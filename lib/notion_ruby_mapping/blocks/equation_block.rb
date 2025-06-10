# frozen_string_literal: true

module NotionRubyMapping
  # Notion block
  class EquationBlock < Block
    # @param [String, NotionRubyMapping::EquationObject] expression
    # @see https://www.notion.so/hkob/EquationBlock-df0f823dc5ac41b798052f161dd6540c#cfcd2ceb77194c0e915500b429e8b91b
    def initialize(expression = nil, json: nil, id: nil, parent: nil)
      super(json: json, id: id, parent: parent)
      @equation_object = if @json
                           EquationObject.equation_object @json[type][:expression]
                         else
                           EquationObject.equation_object expression
                         end
    end

    # @param [Boolean] not_update false when update
    # @return [Hash{String (frozen)->Hash}]
    def block_json(not_update: true)
      ans = super
      ans[type] = {expression: @equation_object.expression}
      ans
    end

    # @return [String]
    # @see https://www.notion.so/hkob/EquationBlock-df0f823dc5ac41b798052f161dd6540c#da3e9d93ffac4d84854be3342b4bf3fe
    def expression
      @equation_object&.expression
    end

    # @param [String] new_expression
    # @see https://www.notion.so/hkob/EquationBlock-df0f823dc5ac41b798052f161dd6540c#f05e3b2c82914cea9f05e9e6644647e1
    def expression=(new_expression)
      @equation_object = EquationObject.equation_object new_expression
      @payload.add_update_block_key :expression
    end

    # @return [Symbol]
    def type
      :equation
    end
  end
end
