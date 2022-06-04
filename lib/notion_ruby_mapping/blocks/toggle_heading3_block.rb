# frozen_string_literal: true

module NotionRubyMapping
  # Notion block
  class ToggleHeading3Block < TextSubBlockColorBaseBlock
    # @return [String (frozen)]
    def type
      "heading_3"
    end
  end
end
