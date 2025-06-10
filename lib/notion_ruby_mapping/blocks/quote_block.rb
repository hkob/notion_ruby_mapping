# frozen_string_literal: true

module NotionRubyMapping
  # Notion block
  class QuoteBlock < TextSubBlockColorBaseBlock
    # @return [String (frozen)]
    def type
      :quote
    end
  end
end
