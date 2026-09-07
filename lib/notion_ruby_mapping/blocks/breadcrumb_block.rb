# frozen_string_literal: true

module NotionRubyMapping
  # Notion breadcrumb block
  class BreadcrumbBlock < Block
    # @return [String] block type
    def type
      "breadcrumb"
    end

    # @param [Boolean] not_update true for a full block payload; false for an update payload
    # @return [Hash{String => Object}] block payload
    def block_json(not_update: true)
      ans = super
      ans[type] = {}
      ans
    end
  end
end
