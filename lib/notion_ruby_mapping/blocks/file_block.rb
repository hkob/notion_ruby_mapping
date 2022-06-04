# frozen_string_literal: true

module NotionRubyMapping
  # Notion block
  class FileBlock < FileBaseBlock
    # @return [String (frozen)]
    def type
      "file"
    end
  end
end
