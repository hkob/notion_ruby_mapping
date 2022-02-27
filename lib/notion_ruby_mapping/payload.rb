# frozen_string_literal: true

module NotionRubyMapping
  # Payload class
  class Payload
    def initialize
      @json = {}
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

    # @return [Hash] created json
    # @param [Hash] optional_json
    def property_values_json(optional_json = nil)
      @json.merge(optional_json || {})
    end

    # @return [Hash] {}
    def clear
      @json = {}
    end
  end
end
