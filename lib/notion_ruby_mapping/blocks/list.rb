# frozen_string_literal: true

module NotionRubyMapping
  # Notion List object
  class List < Base
    include Enumerable

    def initialize(json: nil, id: nil, database: nil, parent: nil, property: nil, query: nil)
      super(json: json, id: id)
      @has_more = @json["has_more"]
      @load_all_contents = !@has_more
      @database = database
      @parent = parent
      @property = property
      @query = query
      @index = 0
      @has_content = true
    end
    attr_reader :has_more

    # @return [NotionRubyMapping::List, Enumerator]
    # @see https://www.notion.so/hkob/List-9a0b32335e0d48849a785ce5e162c760#12e1c261a0944a4095776b7515bef4a1
    def each
      return enum_for(:each) unless block_given?

      if @parent
        unless @has_content
          unless @load_all_contents
            @query.start_cursor = nil
            @json = @parent.children @query
            @has_more = @json["has_more"]
          end
          @index = 0
          @has_content = true
        end

        while @has_content
          if @index < results.length
            object = Base.create_from_json(results[@index])
            @index += 1
            yield object
          elsif @has_more
            if @parent
              @query.start_cursor = @json["next_cursor"]
              @json = @parent.children @query
              @index = 0
              @has_more = @json["has_more"]
            else
              @has_content = false
            end
          else
            @has_content = false
          end
        end
      elsif @database
        unless @has_content # re-exec
          unless @load_all_contents
            @query.start_cursor = nil
            @json = @nc.database_query_request @database.id, @query
            @has_more = @json["has_more"]
          end
          @index = 0
          @has_content = true
        end

        while @has_content
          if @index < results.length
            object = Base.create_from_json(results[@index])
            @index += 1
            yield object
          elsif @has_more
            if @database
              @query.start_cursor = @json["next_cursor"]
              @json = @nc.database_query_request @database.id, @query
              @index = 0
              @has_more = @json["has_more"]
            else
              @has_content = false
            end
          else
            @has_content = false
          end
        end
      elsif @property
        while @has_content
          if @index < results.length
            json = results[@index]
            object = case json["type"]
                     when "people"
                       UserObject.new json: json["people"]
                     when "relation"
                       json["relation"]["id"]
                     when "rich_text"
                       RichTextObject.create_from_json json["rich_text"]
                     when "title"
                       RichTextObject.create_from_json json["title"]
                     else
                       json
                     end
            @index += 1
            yield object
          elsif @has_more
            if @property
              @query ||= Query.new
              @query.start_cursor = @json["next_cursor"]
              @json = NotionCache.instance.page_property_request @property.property_cache.page_id, @property.property_id, @query.query_json
              @index = 0
              @has_more = @json["has_more"]
            else
              @has_content = false
            end
          else
            @has_content = false
          end
        end
      end
      self
    end

    private

    # @return [Hash]
    def results
      @json["results"]
    end
  end
end
