# frozen_string_literal: true

module NotionRubyMapping
  # Notion block
  class LinkToPageBlock < Block
    # @param [String] page_id
    # @param [String] database_id
    # @see https://www.notion.so/hkob/LinkToPageBlock-e6d09d4742a24fb6bf1101b14a288ff5#d46a2f4288b04cbdbd1b4679f70b7642
    def initialize(page_id: nil, database_id: nil, json: nil, id: nil, parent: nil)
      super(json: json, id: id, parent: parent)
      if @json
        @page_id, @database_id = @json[type].values_at(*%w[page_id database_id])
      else
        @page_id = page_id
        @database_id = database_id
      end
    end

    # @see https://www.notion.so/hkob/LinkToPageBlock-e6d09d4742a24fb6bf1101b14a288ff5#f0ccbad5a94248baa658efc26d9c0ca3
    # @see https://www.notion.so/hkob/LinkToPageBlock-e6d09d4742a24fb6bf1101b14a288ff5#1444263ecc7d402c8a18f4dd32a14956
    attr_reader :database_id, :page_id

    # @param [Boolean] not_update false when update
    # @return [Hash{String (frozen)->Hash}]
    def block_json(not_update: true)
      ans = super
      ans[type] = if @page_id
                    {"type" => "page_id", "page_id" => Base.page_id(@page_id)}
                  else
                    {"type" => "database_id", "database_id" => Base.database_id(@database_id)}
                  end
      ans
    end

    # @return [String (frozen)]
    def type
      "link_to_page"
    end
  end
end
