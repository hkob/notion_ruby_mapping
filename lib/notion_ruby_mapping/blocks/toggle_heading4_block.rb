# frozen_string_literal: true

module NotionRubyMapping
  # Notion block
  class ToggleHeading4Block < TextSubBlockColorBaseBlock
    # @return [String]
    def type
      "heading_4"
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
