# frozen_string_literal: true

module NotionRubyMapping
  # Notion block
  class ChildDatabaseBlock < ChildBaseBlock
    # @return [Symbol]
    def type
      :child_database
    end

    def title
      @json[type][:title]
    end
  end
end
