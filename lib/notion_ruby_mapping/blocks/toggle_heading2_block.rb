# frozen_string_literal: true

module NotionRubyMapping
  # Notion block
  class ToggleHeading2Block < TextSubBlockColorBaseBlock
    # @return [String (frozen)]
    def type
      "heading_2"
    end

    # @param [Boolean] not_update false when update
    # @return [Hash{String (frozen)->Hash}]
    def block_json(not_update: true)
      ans = super
      ans[type]["is_toggleable"] = true
      ans
    end
  end
end
