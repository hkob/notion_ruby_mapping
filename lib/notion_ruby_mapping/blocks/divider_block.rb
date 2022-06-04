# frozen_string_literal: true

module NotionRubyMapping
  # Notion block
  class DividerBlock < Block
    # @param [Boolean] not_update false when update
    # @return [Hash{String (frozen)->Hash}]
    def block_json(not_update: true)
      ans = super
      ans[type] = {}
      ans
    end

    # @return [String (frozen)]
    def type
      "divider"
    end
  end
end
