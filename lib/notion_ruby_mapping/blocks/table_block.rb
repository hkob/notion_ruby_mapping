# frozen_string_literal: true

module NotionRubyMapping
  # Notion block
  class TableBlock < Block
    # @param [Integer] table_width
    # @param [Boolean] has_column_header
    # @param [Boolean] has_row_header
    # @param [Array<Array<Object>>] table_rows
    # @param [Hash] json
    # @param [Integer] id
    # @param [Integer] parent
    def initialize(table_width: nil, has_column_header: false, has_row_header: false, table_rows: nil, json: nil, id: nil,
                   parent: nil)
      super json: json, id: id, parent: parent
      if @json
        sub_json = @json[type]
        @has_column_header = sub_json["has_column_header"]
        @has_row_header = sub_json["has_row_header"]
        @table_width = sub_json["table_width"]
      else
        @table_width = table_width
        @has_column_header = has_column_header
        @has_row_header = has_row_header
        if table_rows
          @table_rows = table_rows.map do |table_row|
            TableRowBlock.new table_row, @table_width
          end
        end
      end
      @can_have_children = true
    end

    def block_json(not_update: true)
      ans = super
      ans[type] = {
        "has_column_header" => @has_column_header,
        "has_row_header" => @has_row_header,
        "table_width" => @table_width,
      }
      ans[type]["children"] = @table_rows.map(&:block_json) if @table_rows
      ans
    end

    # @return [String (frozen)]
    def type
      "table"
    end
  end
end
