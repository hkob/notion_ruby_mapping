# frozen_string_literal: true

module NotionRubyMapping
  # Notion List object
  class List < Base
    include Enumerable

    def initialize(json: nil, id: nil, database: nil, query: nil)
      super(json: json, id: id)
      @has_more = @json["has_more"]
      @load_all_contents = !@has_more
      @database = database
      @query = query
      @index = 0
      @has_content = true
    end
    attr_reader :has_more

    ### Public announced methods

    def each
      return enum_for(:each) unless block_given?

      if @database
        unless @has_content # re-exec
          unless @load_all_contents
            @query.start_cursor = nil
            @json = @database.query_database @query
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
              @json = @database.query_database @query
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
    end

    private

    # @return [Hash]
    def results
      @json["results"]
    end
  end
end
