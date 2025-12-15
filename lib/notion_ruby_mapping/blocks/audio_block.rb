# frozen_string_literal: true

module NotionRubyMapping
  # Notion block
  class AudioBlock < FileBaseBlock
    # @return [String]
    def type
      "audio"
    end
  end
end
