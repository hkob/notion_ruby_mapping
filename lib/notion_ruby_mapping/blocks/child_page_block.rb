# frozen_string_literal: true

module NotionRubyMapping
  # Notion block
  class ChildPageBlock < ChildBaseBlock
    # @return [String (frozen)]
    def type
      "child_page"
    end
  end
end
