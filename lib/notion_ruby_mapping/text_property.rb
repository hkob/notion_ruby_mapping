# frozen_string_literal: true

module NotionRubyMapping
  # Text property
  class TextProperty < Property
    include EqualsDoesNotEqual
    include ContainsDoesNotContain
    include StartsWithEndsWith
    include IsEmptyIsNotEmpty
  end
end
