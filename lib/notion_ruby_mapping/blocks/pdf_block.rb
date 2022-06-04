# frozen_string_literal: true

module NotionRubyMapping
  # Notion block
  class PdfBlock < FileBaseBlock
    # @return [String (frozen)]
    def type
      "pdf"
    end
  end
end
