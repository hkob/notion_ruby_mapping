# frozen_string_literal: true

module NotionRubyMapping
  # RichTextProperty
  class RichTextProperty < TextProperty
    TYPE = :rich_text

    ### Not public announced methods

    ## Common methods

    # @param [Hash] json
    def update_from_json(json)
      @will_update = false
      if database?
        @json = json[:rich_text] || {}
      else
        @text_objects = RichTextArray.new :rich_text, json: json[:rich_text]
      end
    end

    ## Page property only methods

    # @return [Hash] created json
    def property_values_json
      assert_page_property __method__
      text_json = @text_objects.map(&:property_values_json)
      {
        @name => {
          type: "rich_text",
          rich_text: text_json.empty? ? (@json || []) : text_json,
        },
      }
    end
  end
end
