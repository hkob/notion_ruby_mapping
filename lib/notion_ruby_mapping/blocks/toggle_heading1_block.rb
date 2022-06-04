# frozen_string_literal: true

module NotionRubyMapping
  # Notion block
  class ToggleHeading1Block < TextSubBlockColorBaseBlock
    # @return [String (frozen)]
    def type
      "heading_1"
    end
  end
end
