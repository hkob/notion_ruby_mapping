# frozen_string_literal: true

module NotionRubyMapping
  # Notion block
  # @param [String] color
  class TableOfContentsBlock < Block
    def initialize(color = "default", json: nil, id: nil, parent: nil)
      super(json: json, id: id, parent: parent)
      if @json
        decode_color
      else
        @color = color
      end
    end

    def color=(new_color)
      @color = new_color
      @payload.add_update_block_key "color"
    end

    # @return [String (frozen)]
    def type
      "table_of_contents"
    end

    # @param [Boolean] not_update false when update
    # @return [Hash{String (frozen)->Hash}]
    def block_json(not_update: true)
      ans = super
      ans[type] = {"color" => @color}
      ans
    end
  end
end
