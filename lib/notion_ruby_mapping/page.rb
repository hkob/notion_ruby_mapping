# frozen_string_literal: true

module NotionRubyMapping
  # Notion page object
  class Page < Base
    ### Public announced methods

    # @param [String] id
    # @return [NotionRubyMapping::Page, String]
    def self.find(id, dry_run: false)
      nc = NotionCache.instance
      if dry_run
        Base.dry_run_script :get, nc.page_path(id)
      else
        nc.page id
      end
    end

    def create_child_database(title, *assign)
      Database.new json: {"title" => [TextObject.new(title).property_values_json]},
                   assign: assign, parent: {"type" => "page_id", "page_id" => @id}
    end

    protected

    # @return [NotionRubyMapping::Base, String]
    def create(dry_run: false)
      if dry_run
        dry_run_script :post, @nc.pages_path, :property_values_json
      else
        @new_record = false
        update_json @nc.create_page_request(property_values_json)
      end
    end

    # @return [Hash]
    def reload_json
      @nc.page_request @id
    end

    # @return [NotionRubyMapping::Base, String]
    def update(dry_run: false)
      if dry_run
        dry_run_script :patch, @nc.page_path(@id), :property_values_json
      else
        update_json @nc.update_page_request(@id, property_values_json)
      end
    end
  end
end
