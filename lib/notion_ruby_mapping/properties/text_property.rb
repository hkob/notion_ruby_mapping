# frozen_string_literal: true

require "forwardable"

module NotionRubyMapping
  # Text property
  class TextProperty < Property
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
      @text_objects = if database?
                        json || {}
                      else
                        RichTextArray.new "title", json: json, text_objects: text_objects
                      end
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
