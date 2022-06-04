# frozen_string_literal: true

module NotionRubyMapping
  # Notion block
  class ImageBlock < FileBaseBlock
    # @return [String (frozen)]
    def type
      "image"
    end
  end
end
