# frozen_string_literal: true

module NotionRubyMapping
  # Represents a Notion file block.
  class FileBlock < FileBaseBlock
    # Returns the Notion block type.
    #
    # @return [String] `"file"`
    def type
      "file"
    end
  end
end
