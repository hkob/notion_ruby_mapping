# frozen_string_literal: true

module NotionRubyMapping
  # Notion block
  class ToggleBlock < TextSubBlockColorBaseBlock
    # @return [String]
    def type
      "toggle"
    end
  end
end
