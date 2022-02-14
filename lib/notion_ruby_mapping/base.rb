# frozen_string_literal: true

module NotionRubyMapping
  # Notion Base object (Parent of Page / Database / List)
  class Base
    def initialize(json: nil, id: nil)
      @nc = NotionCache.instance
      @json = json
      @id = @nc.hex_id(id || @json["id"])
    end
    attr_reader :json, :id

    # @param [Object] json
    # @return [NotionRubyMapping::Block, NotionRubyMapping::List, NotionRubyMapping::Database, NotionRubyMapping::Page]
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

    # @return [NotionRubyMapping::List]
    def children
      @children ||= @nc.block_children(id)
    end

    def update_json(json)
      if @json.nil? || @json["type"] == json["type"]
        @json = json
        clear_object
      end
    end

    def clear_object
    end

    def set_icon(emoji: nil, url: nil)
      if self.is_a?(Page) || self.is_a?(Database)
        payload = emoji ? {type: :emoji, emoji: emoji} : {type: :external, external: {url: url}}
        update_json(update(id, {icon: payload}))
      end
      self
    end

    def icon
      @json["icon"]
    end
  end
end
