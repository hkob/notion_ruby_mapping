# frozen_string_literal: true

module NotionRubyMapping
  # Notion Base object (Parent of Page / Database / List)
  class Base
    def initialize(json)
      @nc = NotionCache.instance
      @json = json
      @id = @nc.hex_id @json["id"]
    end
    attr_reader :json, :id

    # @param [Object] json
    # @return [NotionRubyMapping::Block, NotionRubyMapping::List, NotionRubyMapping::Database, NotionRubyMapping::Page]
    def self.create_from_json(json)
      case json["object"]
      when "page"
        Page.new json
      when "database"
        Database.new json
      when "list"
        List.new json
      when "block"
        Block.new json
      else
        throw Notion::Api::Errors::ObjectNotFound
      end
    end

    # @return [NotionRubyMapping::List]
    def children
      @children ||= @nc.block_children(id)
    end
  end
end
