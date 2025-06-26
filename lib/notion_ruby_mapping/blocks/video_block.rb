# frozen_string_literal: true

module NotionRubyMapping
  # Notion block
  class VideoBlock < FileBaseBlock
    # @return [String]
    def type
      "video"
    end
  end
end
