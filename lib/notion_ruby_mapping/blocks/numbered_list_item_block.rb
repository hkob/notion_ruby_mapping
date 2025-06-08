# frozen_string_literal: true

module NotionRubyMapping
  # Notion block
  class NumberedListItemBlock < TextSubBlockColorBaseBlock
    # @return [Symbol]
    def type
      :numbered_list_item
    end
  end
end
