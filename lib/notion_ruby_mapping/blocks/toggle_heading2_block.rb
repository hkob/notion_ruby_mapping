# frozen_string_literal: true

module NotionRubyMapping
  # Notion block
  class ToggleHeading2Block < TextSubBlockColorBaseBlock
    # @return [String (frozen)]
    def type
      "heading_2"
    end
  end
end
