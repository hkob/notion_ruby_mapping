# frozen_string_literal: true

module NotionRubyMapping
  # Notion block
  class ParagraphBlock < TextSubBlockColorBaseBlock
    # @return [Symbol]
    def type
      :paragraph
    end
  end
end
