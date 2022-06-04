# frozen_string_literal: true

module NotionRubyMapping
  # Notion block
  class ParagraphBlock < TextSubBlockColorBaseBlock
    # @return [String (frozen)]
    def type
      "paragraph"
    end
  end
end
