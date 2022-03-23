# frozen_string_literal: true

module NotionRubyMapping
  # Payload class
  class Payload
    def initialize(json)
      @json = json || {}
    end

    # @param [String] emoji
    # @param [String] url
    # @return [NotionRubyMapping::Payload] updated Payload
    def set_icon(emoji: nil, url: nil)
      payload = if emoji
                  {"type" => "emoji", "emoji" => emoji}
                elsif url
                  {"type" => "external", "external" => {"url" => url}}
                else
                  {}
                end
      @json["icon"] = payload
      self
    end

    # @param [Hash] json
    def merge_property(json)
      @json["properties"] ||= {}
      @json["properties"].merge!(json)
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

    # @return [Hash] created json
    # @param [Object] others
    def update_property_schema_json(*others)
      others.compact.reduce({}) { |hash, o| hash.merge o.update_property_schema_json }.merge @json
    end

    # @return [Hash] {}
    def clear
      @json = {}
    end
  end
end
