# frozen_string_literal: true

module NotionRubyMapping
  # EquationObject
  class EquationObject < RichTextObject
    # @param [String] expression
    # @return [TextObject]
    def initialize(expression, options = {})
      super "equation", {"plain_text" => expression}.merge(options)
      @expression = expression
      @will_update = false
    end
    attr_reader :will_update, :expression

    # @param [EquationObject, String] uo
    # @return [EquationObject] self or created EquationObject
    # @see https://www.notion.so/hkob/EquationObject-cd50126fce544ad5bb76463a4269859b#45b0b0810d8647a1968a5e4293920aeb
    def self.equation_object(expression_or_eo)
      if expression_or_eo.is_a? EquationObject
        expression_or_eo
      else
        EquationObject.new expression_or_eo
      end
    end

    # @param [String] expression
    # @see https://www.notion.so/hkob/EquationObject-cd50126fce544ad5bb76463a4269859b#155800e2c69d4676a2d74572ed8f0de8
    def expression=(expression)
      @expression = expression
      @options["plain_text"] = expression
      @will_update = true
    end

    # @return [String (frozen)]
    def text
      @expression
    end

    protected

    # @return [Hash{String (frozen)->String}]
    def partial_property_values_json
      {
        "expression" => @expression,
      }
    end
  end
end
