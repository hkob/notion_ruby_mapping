# frozen_string_literal: true

module NotionRubyMapping
  # Base class for multi-value properties
  class MultiProperty < Property
    include ContainsDoesNotContain
    include IsEmptyIsNotEmpty
  end
end
