module NotionRubyMapping
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
    # @param optional [Hash] optional_json
    def create_json(optional_json = nil)
      @json.merge(optional_json || {})
    end
  end
end
