# frozen_string_literal: true

module NotionRubyMapping
  # Notion block
  class EmbedBlock < UrlCaptionBaseBlock
    # @return [String]
    def type
      "embed"
    end
  end
end
