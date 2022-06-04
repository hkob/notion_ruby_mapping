# frozen_string_literal: true

module NotionRubyMapping
  # Notion block
  class ChildDatabaseBlock < ChildBaseBlock
    # @return [String (frozen)]
    def type
      "child_database"
    end
  end
end
