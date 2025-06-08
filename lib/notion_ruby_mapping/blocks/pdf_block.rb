# frozen_string_literal: true

module NotionRubyMapping
  # Notion block
  class PdfBlock < FileBaseBlock
    # @return [Symbol]
    def type
      :pdf
    end
  end
end
