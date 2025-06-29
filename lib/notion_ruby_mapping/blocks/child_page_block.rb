# frozen_string_literal: true

module NotionRubyMapping
  # Notion block
  class ChildPageBlock < ChildBaseBlock
    # @return [String]
    def type
      "child_page"
    end

    def title
      @json[type]["title"]
    end
  end
end
