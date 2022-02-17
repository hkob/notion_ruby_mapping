# frozen_string_literal: true

module NotionRubyMapping
  # Checkbox property
  class CheckboxProperty < Property
    include EqualsDoesNotEqual
    TYPE = "checkbox"
  end
end
