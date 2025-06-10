# frozen_string_literal: true

module NotionRubyMapping
  # Notion block
  class BookmarkBlock < UrlCaptionBaseBlock
    # @return [String (frozen)]
    def type
      :bookmark
    end
  end
end
