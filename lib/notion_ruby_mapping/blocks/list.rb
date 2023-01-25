# frozen_string_literal: true

module NotionRubyMapping
  # Notion List object
  class List < Base
    include Enumerable

    def initialize(json: nil, id: nil, type: nil, value: nil, query: nil)
      super(json: json, id: id)
      @has_more = @json["has_more"]
      @load_all_contents = !@has_more

      case type
      when :comment_parent
        @comment_parent = value
      when :database
        @database = value
      when :parent
        @parent = value
      when :property
        @property = value
      when :user_object
        @user_object = true
      when :search
        @search = value
      end
      @query = query
      @index = 0
      @has_content = true
    end
    attr_reader :has_more

    # @return [NotionRubyMapping::List, Enumerator]
    # @see https://www.notion.so/hkob/List-9a0b32335e0d48849a785ce5e162c760#12e1c261a0944a4095776b7515bef4a1
    def each(&block)
      return enum_for(:each) if block.nil?
      if @parent
        each_sub base: @page,
                 query: -> { @parent.children @query },
                 create_object: ->(json) { Base.create_from_json json },
                 &block
      elsif @database
        each_sub base: @database,
                 query: -> { @nc.database_query_request @database.id, @query },
                 create_object: ->(json) { Base.create_from_json json },
                 &block
      elsif @property
        each_sub base: @property,
                 query: -> do
                   @nc.page_property_request @property.property_cache.page_id,
                                             @property.property_id,
                                             @query.query_json
                 end,
                 create_object: ->(json) do
                   case json["type"]
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
                 end,
                 &block
      elsif @comment_parent
        each_sub base: @comment_parent,
                 query: -> { @nc.retrieve_comments_request @comment_parent.id, @query },
                 create_object: ->(json) { CommentObject.new json: json },
                 &block
      elsif @user_object
        each_sub base: @user_object,
                 query: -> { @nc.users_request @query.query_json },
                 create_object: ->(json) { UserObject.new json: json },
                 &block
      elsif @search
        each_sub base: @search,
                 query: -> { @nc.search @search.payload.merge(@query.query_json) },
                 create_object: ->(json) { Base.create_from_json json },
                 &block
      end
      self
    end

    private

    # @param [NotionRubyMapping::Page, NotionRubyMapping::Block] base page or block
    # @param [Proc] query
    # @param [Proc] create_object
    # @param [Proc] block
    def each_sub(base:, query:, create_object:, &block)
      unless @has_content
        unless @load_all_contents
          @query.start_cursor = nil
          @json = query.call
          @has_more = @json["has_more"]
        end
        @index = 0
        @has_content = true
      end

      while @has_content
        if @index < results.length
          object = create_object.call results[@index]
          @index += 1
          block.call object
        elsif @has_more
          if base
            @query.start_cursor = @json["next_cursor"]
            @json = query.call
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

    # @return [Hash]
    def results
      @json["results"]
    end
  end
end
