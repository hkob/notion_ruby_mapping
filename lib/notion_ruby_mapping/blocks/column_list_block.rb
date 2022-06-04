# frozen_string_literal: true

module NotionRubyMapping
  # Notion block
  class ColumnListBlock < Block
    # @param [Array<Array<NotionRubyMapping::Block, Array<NotionRubyMapping::Block>>>] array_of_sub_blocks
    # @return [NotionRubyMapping::Block]
    # @see https://www.notion.so/hkob/ColumnListBlock-78d12860099f4e7d89b65c446bd314ba#6e1c97e1b5da45038232f43994e4d7e5
    def initialize(array_of_sub_blocks = [], json: nil, id: nil, parent: nil)
      super(json: json, id: id, parent: parent)
      unless json
        raise StandardError, "The column_list must have at least 2 columns." if array_of_sub_blocks.count < 2

        @columns = array_of_sub_blocks.map { |sub_blocks| ColumnBlock.new(sub_blocks) }
      end
      @can_have_children = true
    end

    # @return [String (frozen)]
    def type
      "column_list"
    end

    # @param [Boolean] not_update false when update
    # @return [Hash{String (frozen)->Hash}]
    def block_json(not_update: true)
      ans = super
      ans[type] = {}
      ans[type]["children"] = @columns.map(&:block_json) if @columns
      ans
    end
  end
end
