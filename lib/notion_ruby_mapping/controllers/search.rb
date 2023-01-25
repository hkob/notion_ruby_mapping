module NotionRubyMapping
  class Search

    def initialize(ascending: false, database_only: false, page_only: false, query: nil)
      @ascending = ascending
      @database_only = database_only
      @page_only = page_only
      @query = query
    end

    def exec(dry_run: false)
      if dry_run
        Base.dry_run_script :post, NotionCache.instance.search_path, payload
      else
        response = NotionCache.instance.search payload
        List.new json: response, type: :search, value: self, query: Query.new
      end
    end

    def payload
      ans = {}
      ans["sort"] = {"direction" => "ascending", "timestamp" => "last_edited_time"} if @ascending
      ans["filter"] = {"value" => "database", "property" => "object" } if @database_only
      ans["filter"] = {"value" => "page", "property" => "object" } if @page_only
      ans["query"] = @query if @query
      ans
    end
  end
end