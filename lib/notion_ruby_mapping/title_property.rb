# frozen_string_literal: true

module NotionRubyMapping
  # TitleProperty
  class TitleProperty < TextProperty
    TYPE = "title"

    # @param [Hash] json
    def update_from_json(json)
      @will_update = false
      @text_objects = json["title"].map { |to| RichTextObject.create_from_json to }
    end

    # @return [Hash] created json
    def property_values_json
      text_json = map(&:property_values_json)
      {
        @name => {
          "type" => "title",
          "title" => text_json.empty? ? @json : text_json,
        },
      }
    end
  end
end
