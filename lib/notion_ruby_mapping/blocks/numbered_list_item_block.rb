# frozen_string_literal: true

module NotionRubyMapping
  # Notion block
  class NumberedListItemBlock < TextSubBlockColorBaseBlock
    # @return [String]
    def type
      "numbered_list_item"
    end
  end
end
