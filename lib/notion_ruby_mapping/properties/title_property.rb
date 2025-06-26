# frozen_string_literal: true

module NotionRubyMapping
  # TitleProperty
  class TitleProperty < TextProperty
    TYPE = "title"

    ### Not public announced methods

    ## Common methods

    def self.rich_text_array_from_json(json)
      if json["object"] == "list"
        rich_text_objects = List.new(json: json, type: "property", value: self).select { true }
        RichTextArray.rich_text_array "title", rich_text_objects
      else
        RichTextArray.new "title", json: json["title"]
      end
    end

    # @param [Hash] json
    def update_from_json(json)
      @will_update = false
      if database?
        @json = json || {}
      else
        @text_objects = TitleProperty.rich_text_array_from_json json
      end
    end

    ## Page property only methods

    # @return [FalseClass]
    def clear_will_update
      super
      @text_objects.clear_will_update
      false
    end

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
