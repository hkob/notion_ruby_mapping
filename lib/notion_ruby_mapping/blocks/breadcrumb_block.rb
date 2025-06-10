# frozen_string_literal: true

module NotionRubyMapping
  # Notion block
  class BreadcrumbBlock < Block
    # @return [String (frozen)]
    def type
      :breadcrumb
    end

    # @param [Boolean] not_update false when update
    # @return [Hash{String (frozen)->Hash}]
    def block_json(not_update: true)
      ans = super
      ans[type] = {}
      ans
    end
  end
end
