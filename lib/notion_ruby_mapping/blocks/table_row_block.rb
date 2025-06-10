# frozen_string_literal: true

module NotionRubyMapping
  # Notion block
  class TableRowBlock < Block
    # @param [Array<Array<String, TextObject>>] array_array_of_text_objects
    # @param [Integer] table_width
    def initialize(array_array_of_text_objects = [], table_width = 3, json: nil, id: nil, parent: nil)
      super json: json, id: id, parent: parent
      if @json
        @cells = @json[type][:cells].map { |cell| cell.map { |to| RichTextObject.create_from_json to } }
      else
        cc = array_array_of_text_objects.count
        raise StandardError, "table width must be #{table_width} (given array size is #{cc}" unless table_width == cc

        @cells = array_array_of_text_objects.map do |cell|
          Array(cell).map { |text_info| TextObject.text_object text_info }
        end
      end
      @can_have_children = false
    end

    def block_json(not_update: true)
      ans = super
      ans[type] = {cells: @cells.map { |cell| Array(cell).map(&:property_values_json) }}
      ans
    end

    # @return [String (frozen)]
    def type
      :table_row
    end
  end
end
