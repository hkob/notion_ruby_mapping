# frozen_string_literal: true

module NotionRubyMapping
  # TitleProperty
  class TitleProperty < TextProperty
    TYPE = "title"

    ### Not public announced methods

    ## Common methods

    # @param [Hash] json
    def update_from_json(json)
      @will_update = false
      if database?
        @json = json || {}
      else
        @text_objects = RichTextArray.new "rich_text", json: json["title"]
      end
    end

    ## Page property only methods

    # @return [Hash] created json
    def property_values_json
      assert_page_property __method__
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
