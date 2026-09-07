# frozen_string_literal: true

module NotionRubyMapping
  # Notion table of contents block
  class TableOfContentsBlock < Block
    # @param [String] color block color
    def initialize(color = "default", json: nil, id: nil, parent: nil)
      super(json: json, id: id, parent: parent)
      if @json
        decode_color
      else
        @color = color
      end
    end

    # @param [String] new_color new block color
    def color=(new_color)
      @color = new_color
      @payload.add_update_block_key "color"
    end

    # @return [String] block type
    def type
      "table_of_contents"
    end

    # @param [Boolean] not_update true for a full block payload; false for an update payload
    # @return [Hash{String => Object}] block payload
    def block_json(not_update: true)
      ans = super
      ans[type] = {"color" => @color}
      ans
    end
  end
end
