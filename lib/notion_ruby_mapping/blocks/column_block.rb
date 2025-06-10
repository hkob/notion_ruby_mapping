# frozen_string_literal: true

module NotionRubyMapping
  # Notion block
  class ColumnBlock < Block
    # @param [NotionRubyMapping::Block, Array<NotionRubyMapping::Block>, nil] sub_blocks
    # @see https://www.notion.so/hkob/ColumnBlock-91cb314fc6594ff6b0c77c1eae6c7fab#4b4486cdf26a474eab1c92f9c6ea8a91
    def initialize(sub_blocks = [], json: nil, id: nil, parent: nil)
      super(json: json, id: id, parent: parent)
      add_sub_blocks sub_blocks unless json
      @can_have_children = true
      @can_append = false
    end

    # @return [Symbol]
    def type
      :column
    end

    # @param [Boolean] not_update false when update
    # @return [Hash{String (frozen)->Hash}]
    def block_json(not_update: true)
      ans = super
      ans[type] = {}
      ans[type][:children] = @sub_blocks.map(&:block_json) if @sub_blocks
      ans
    end
  end
end
