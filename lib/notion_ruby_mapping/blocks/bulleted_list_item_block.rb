# frozen_string_literal: true

module NotionRubyMapping
  # Notion block
  class BulletedListItemBlock < TextSubBlockColorBaseBlock
    # @return [String (frozen)]
    def type
      :bulleted_list_item
    end
  end
end
