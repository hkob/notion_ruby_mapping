# frozen_string_literal: true

module NotionRubyMapping
  # UrlProperty
  class UrlProperty < Property
    include EqualsDoesNotEqual
    include ContainsDoesNotContain
    include StartsWithEndsWith
    include IsEmptyIsNotEmpty
    TYPE = "url"

    # @param [String] name Property name
    # @param [String] url url value (optional)
    def initialize(name, will_update: false, url: nil)
      super name, will_update: will_update
      @url = url
    end
    attr_reader :url

    # @param [Hash] json
    def update_from_json(json)
      @will_update = false
      @url = json["url"]
    end

    # @return [Hash]
    def property_values_json
      {@name => {"url" => @url, "type" => "url"}}
    end

    def url=(url)
      @will_update = true
      @url = url
    end
  end
end
