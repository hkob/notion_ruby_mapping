# frozen_string_literal: true

module NotionRubyMapping
  # Formula property
  class FormulaProperty < DateBaseProperty
    include ContainsDoesNotContain
    include StartsWithEndsWith
    include GreaterThanLessThan
    TYPE = :formula
  end
end
