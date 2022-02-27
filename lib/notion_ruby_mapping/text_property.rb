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

    # @param [String] name
    # @param [Hash] json
    # @param [Array<RichTextObject>] text_objects
    def initialize(name, will_update: false, json: nil, text_objects: nil)
      raise StandardError, "TextObject is abstract class.  Please use RichTextProperty." if instance_of? TextProperty

      super name, will_update: will_update
      @text_objects = if text_objects
                        text_objects.map { |to_s| RichTextObject.text_object to_s }
                      elsif json
                        json.map { |to| RichTextObject.create_from_json to }
                      else
                        []
                      end
    end
    attr_reader :text_objects

    # @return [TrueClass, FalseClass] will update?
    def will_update
      @will_update || @text_objects.map(&:will_update).any?
    end

    # @param [Proc] block
    # @return [Enumerator]
    def each(&block)
      return enum_for(:each) unless block

      @text_objects.each(&block)
    end

    # @param [String, RichTextObject] to
    # @return [NotionRubyMapping::RichTextObject] added RichTextObject
    def <<(to)
      @will_update = true
      rto = RichTextObject.text_object(to)
      @text_objects << rto
      rto
    end

    # @param [Numeric] index index number
    # @return [RichTextObject] selected RichTextObject
    def [](index)
      @text_objects[index]
    end

    # @param [Numeric] index
    # @return [NotionRubyMapping::RichTextObject] removed RichTextObject
    def delete_at(index)
      @will_update = true
      @text_objects[index]
    end

    # @return [String] full_text
    def full_text
      map(&:text).join ""
    end
  end
end
