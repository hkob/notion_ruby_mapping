# frozen_string_literal: true

module NotionRubyMapping
  # RichTextProperty
  class RichTextProperty < TextProperty
    TYPE = "rich_text"

    # @param [Hash] json
    def update_from_json(json)
      @will_update = false
      @text_objects = json["rich_text"].map { |to| RichTextObject.create_from_json to }
    end

    # @return [Hash] created json
    def property_values_json
      text_json = @text_objects.map(&:property_values_json)
      {
        @name => {
          "type" => "rich_text",
          "rich_text" => text_json.empty? ? (@json || []) : text_json,
        },
      }
    end
  end
end
