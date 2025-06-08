# frozen_string_literal: true

module NotionRubyMapping
  # Notion block
  class ToggleBlock < TextSubBlockColorBaseBlock
    # @return [Symbol]
    def type
      :toggle
    end
  end
end
