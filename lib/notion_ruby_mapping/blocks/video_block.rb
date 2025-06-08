# frozen_string_literal: true

module NotionRubyMapping
  # Notion block
  class VideoBlock < FileBaseBlock
    # @return [Symbol]
    def type
      :video
    end
  end
end
