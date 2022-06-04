# frozen_string_literal: true

module NotionRubyMapping
  # Notion block
  class LinkPreviewBlock < UrlBaseBlock
    def initialize(url = nil, json: nil, id: nil, parent: nil)
      super
      @can_append = false
    end

    # @return [String (frozen)]
    def type
      "link_preview"
    end
  end
end
