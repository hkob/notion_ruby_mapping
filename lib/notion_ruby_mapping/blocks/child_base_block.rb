# frozen_string_literal: true

module NotionRubyMapping
  # Notion block
  class ChildBaseBlock < Block
    def initialize(json: nil, id: nil, parent: nil)
      super
      @title = @json[type][:title]
      @can_append = false
      @can_append = false
    end

    # @param [Boolean] not_update false when update
    # @return [Hash{String (frozen)->Hash}]
    def block_json(not_update: true)
      ans = super
      ans[type] = {title: @title}
      ans
    end
  end
end
