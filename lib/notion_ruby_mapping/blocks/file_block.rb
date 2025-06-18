# frozen_string_literal: true

module NotionRubyMapping
  # Notion block
  class FileBlock < FileBaseBlock
    # @return [Symbol]
    def type
      :file
    end
  end
end
