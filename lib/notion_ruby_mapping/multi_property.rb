# frozen_string_literal: true

module NotionRubyMapping
  # MultiSelect property
  class MultiProperty < Property
    include ContainsDoesNotContain
    include IsEmptyIsNotEmpty
  end
end
