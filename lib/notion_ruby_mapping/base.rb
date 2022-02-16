# frozen_string_literal: true

module NotionRubyMapping
  # Notion Base object (Parent of Page / Database / List)
  class Base
    def initialize(json: nil, id: nil)
      @nc = NotionCache.instance
      @json = json
      @id = @nc.hex_id(id || @json["id"])
      @payload = nil
      @property_cache = nil
    end
    attr_reader :json, :id

    # @param [Hash, Notion::Messages] json
    # @return [NotionRubyMapping::Base]
    def self.create_from_json(json)
      case json["object"]
      when "page"
        Page.new json: json
      when "database"
        Database.new json: json
      when "list"
        List.new json: json
      when "block"
        Block.new json: json
      else
        throw Notion::Api::Errors::ObjectNotFound
      end
    end

    # @return [NotionRubyMapping::Payload] get or created Payload object
    def payload
      @payload ||= Payload.new
    end

    # @return [NotionRubyMapping::List]
    def children
      @children ||= @nc.block_children(id)
    end

    # @param [Hash] json
    # @return [NotionRubyMapping::Base]
    def update_json(json)
      if @json.nil? || @json["type"] == json["type"]
        @json = json
        @id = @nc.hex_id(@json["id"])
        clear_object
      end
      self
    end

    # @return [NotionRubyMapping::Base]
    def clear_object
      @payload = nil
      @property_cache = nil
      self
    end

    # @param [String] emoji
    # @param [String] url
    # @return [NotionRubyMapping::Base]
    def set_icon(emoji: nil, url: nil)
      if self.is_a?(Page) || self.is_a?(Database)
        payload.set_icon(emoji: emoji, url: url)
        update
      end
      self
    end

    def [](key)
      unless @json
        return nil if @id.nil?

        update_json reload
      end
      case key
      when "properties"
        @property_cache ||= PropertyCache.new
      else
        @json[key]
      end
    end

    def icon
      self["icon"]
    end
  end
end
