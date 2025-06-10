# frozen_string_literal: true

module NotionRubyMapping
  # Notion block
  class SyncedBlock < Block
    # @param [String] block_id
    # @param [NotionRubyMapping::Block, Array<NotionRubyMapping::Block>, nil] sub_blocks
    def initialize(block_id: nil, sub_blocks: nil, json: nil, id: nil, parent: nil)
      super json: json, id: id, parent: parent
      if @json
        synced_from = @json[type][:synced_from]
        @block_id = synced_from && @nc.hex_id(synced_from[:block_id])
      else
        @block_id = Base.block_id block_id
        add_sub_blocks sub_blocks
      end
      @can_have_children = @block_id.nil?
    end

    attr_reader :block_id

    def block_json(not_update: true)
      ans = super
      ans[type] = {synced_from: @block_id ? {type: :block_id, block_id: @nc.hex_id(@block_id)} : nil}
      ans[type][:children] = @sub_blocks.map(&:block_json) if @sub_blocks
      ans
    end

    # @return [Boolean] true if synced_block & block_id is nil
    def synced_block_original?
      @block_id.nil?
    end

    # @return [NotionRubyMapping::SyncedBlock]
    def synced_block_original
      @block_id && Block.find(@block_id)
    end

    # @return [String, nil]
    def synced_block_original_id
      @block_id
    end

    # @return [String (frozen)]
    def type
      :synced_block
    end
  end
end
