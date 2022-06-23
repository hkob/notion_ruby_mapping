# frozen_string_literal: true

module NotionRubyMapping
  # RichTextObject
  class RichTextArray
    include Enumerable

    # @param [Array] json
    def initialize(key, json: nil, text_objects: nil, will_update: false)
      @key = key
      @rich_text_objects = if json
                             create_from_json(json)
                           elsif text_objects
                             Array(text_objects).map do |to|
                               RichTextObject.text_object to
                             end
                           else
                             []
                           end
      @will_update = will_update
    end
    attr_writer :will_update

    def self.rich_text_array(key, text_objects = nil)
      if text_objects.nil?
        RichTextArray.new key
      elsif text_objects.is_a? RichTextArray
        text_objects
      else
        RichTextArray.new key, text_objects: text_objects
      end
    end

    # @param [String, RichTextObject] to
    # @return [NotionRubyMapping::RichTextObject] added RichTextObject
    def <<(to)
      @will_update = true
      rto = RichTextObject.text_object(to)
      @rich_text_objects << rto
      rto
    end

    # @param [Numeric] index index number
    # @return [RichTextObject] selected RichTextObject
    def [](index)
      @rich_text_objects[index]
    end

    # @param [Array] json
    # @return [Array] RichTextArray
    def create_from_json(json = [])
      json.map { |rt_json| RichTextObject.create_from_json rt_json }
    end

    # @param [Numeric] index
    # @return [NotionRubyMapping::RichTextObject] removed RichTextObject
    def delete_at(index)
      @will_update = true
      @rich_text_objects.delete_at index
    end

    # @param [Proc] block
    # @return [Enumerator]
    def each(&block)
      return enum_for(:each) unless block

      @rich_text_objects.each(&block)
    end

    # @return [String]
    def full_text
      map(&:text).join ""
    end

    # @param [RichTextArray, String, Array<String>, RichTextObject, Array<RichTextObject>] text_info
    def rich_text_objects=(text_info)
      @will_update = true
      @rich_text_objects = if text_info.is_a? RichTextArray
                             text_info.filter { true }
                           else
                             Array(text_info).map do |to|
                               RichTextObject.text_object to
                             end
                           end
    end

    def property_values_json
      will_update ? @rich_text_objects.map(&:property_values_json) : []
    end

    def property_schema_json
      will_update ? {@key => @rich_text_objects.map(&:property_values_json)} : {}
    end

    def update_property_schema_json(flag = false)
      flag || will_update ? {@key => @rich_text_objects.map(&:property_values_json)} : {}
    end

    # @return [TrueClass, FalseClass] true if it will update
    def will_update
      @will_update || @rich_text_objects.map(&:will_update).any?
    end
  end
end
