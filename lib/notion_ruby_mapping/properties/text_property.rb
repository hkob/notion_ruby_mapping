# frozen_string_literal: true

require "forwardable"

module NotionRubyMapping
  # Text property
  class TextProperty < Property
    TYPE = "text"
    extend Forwardable
    include Enumerable
    include EqualsDoesNotEqual
    include ContainsDoesNotContain
    include StartsWithEndsWith
    include IsEmptyIsNotEmpty

    ### Public announced methods

    ## Page property only methods

    attr_reader :text_objects

    def_delegators :@text_objects, :[], :<<, :each, :full_text, :delete_at

    ### Not public announced methods

    ## Common methods

    # @param [String, Symbol] name
    # @param [Hash, Array] json
    # @param [Array<RichTextObject>] text_objects
    def initialize(name, will_update: false, base_type: "page", json: nil, text_objects: nil, property_id: nil,
                   property_cache: nil, query: nil)
      raise StandardError, "TextObject is abstract class.  Please use RichTextProperty." if instance_of? TextProperty

      super name, will_update: will_update, base_type: base_type, property_id: property_id,
                  property_cache: property_cache, query: query
      @text_objects = if database_or_data_source?
                        json || {}
                      else
                        RichTextArray.new self.class::TYPE, json: json, text_objects: text_objects
                      end
    end

    def self.rich_text_array_from_json(json)
      if json["object"] == "list"
        rich_text_objects = List.new(json: json, type: "property", value: self).select { true }
        RichTextArray.rich_text_array self::TYPE, rich_text_objects
      else
        RichTextArray.new self::TYPE, json: json[self::TYPE]
      end
    end

    # @return [Hash] created json
    def property_values_json
      assert_page_property __method__
      text_json = @text_objects.map(&:property_values_json)
      {
        @name => {
          "type" => self.class::TYPE,
          self.class::TYPE => text_json.empty? ? (@json || []) : text_json,
        },
      }
    end

    # Replaces all rich text objects with a single plain text object.
    #
    # This method does not preserve annotations, links, mentions, or equations.
    #
    # @param [String] text
    # @raise [ArgumentError] if text is nil
    def plain_text=(text)
      assert_page_property __method__
      raise ArgumentError if text.nil?

      @text_objects = RichTextArray.new(
        self.class::TYPE,
        text_objects: text,
      )
      @will_update = true
    end

    # @param [Hash] json
    def update_from_json(json)
      @will_update = false
      if database_or_data_source?
        @json = json[self.class::TYPE] || {}
      else
        @text_objects = self.class.rich_text_array_from_json json
      end
    end

    # Removes all rich text objects.
    #
    # This method makes the property value an empty rich text array.
    def clear
      assert_page_property __method__
      @text_objects.clear
      @will_update = true
    end

    # @return [FalseClass]
    def clear_will_update
      super
      @text_objects.clear_will_update if page?
      false
    end

    # @return [TrueClass, FalseClass] will update?
    def will_update
      @will_update || (page? && @text_objects.will_update)
    end
  end
end
