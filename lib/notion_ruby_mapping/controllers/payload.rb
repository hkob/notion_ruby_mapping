# frozen_string_literal: true

module NotionRubyMapping
  # Payload class
  class Payload
    def initialize(json)
      @json = json || {}
      @update_block_key = []
    end

    # @param [Symbol] key
    def add_update_block_key(key)
      @update_block_key << key
    end

    # @return [Hash] {}
    def clear
      @update_block_key = []
      @json = {}
    end

    def description=(text_objects)
      rta = RichTextArray.rich_text_array :description, text_objects
      @json.merge!(rta.update_property_schema_json(true))
    end

    # @param [Boolean] flag
    def is_inline=(flag)
      @json[:is_inline] = flag
    end

    # @param [Hash] json
    def merge_property(json)
      @json[:properties] ||= {}
      @json[:properties].merge!(json)
    end

    # @return [Hash] created json
    # @param [Object] others
    def property_values_json(*others)
      others.compact.reduce({}) { |hash, o| hash.merge o.property_values_json }.merge @json
    end

    # @return [Hash] created json
    # @param [Object] others
    def property_schema_json(*others)
      others.compact.reduce({}) { |hash, o| hash.merge o.property_schema_json }.merge @json
    end

    # @param [String] emoji
    # @param [String] url
    # @return [NotionRubyMapping::Payload] updated Payload
    def set_icon(emoji: nil, url: nil)
      payload = if emoji
                  {type: "emoji", emoji: emoji}
                elsif url
                  {type: "external", external: {url: url}}
                else
                  {}
                end
      @json[:icon] = payload
      self
    end

    def update_block_json(type, json)
      sub_json = json[type]
      ans = {type => sub_json.slice(*@update_block_key)}
      ans[type][:caption] = sub_json[:caption] if sub_json[:caption]
      ans[type][:rich_text] = sub_json[:rich_text] if sub_json[:rich_text]
      ans
    end

    # @return [Hash] created json
    # @param [Object] others
    def update_property_schema_json(*others)
      @json.merge(others.compact.reduce({}) { |hash, o| hash.merge o.update_property_schema_json })
    end
  end
end
