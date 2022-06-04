# frozen_string_literal: true

module NotionRubyMapping
  # Notion page object
  class Page < Base
    ### Public announced methods

    # @param [String] id
    # @return [NotionRubyMapping::Page, String]
    # @see https://www.notion.so/hkob/Page-d359650e3ca94424af8359a24147b9a0#7d868b8b81c3473082bbdc7370813a4a
    def self.find(id, dry_run: false)
      nc = NotionCache.instance
      if dry_run
        Base.dry_run_script :get, nc.page_path(id)
      else
        nc.page id
      end
    end

    # @param [String] key
    # @return [NotionRubyMapping::PropertyCache, Hash] obtained Page value or PropertyCache
    def [](key)
      get key
    end

    # @param [String] title
    # @param [Array<String, Property>] assigns
    # @return [NotionRubyMapping::Database]
    # @see https://www.notion.so/hkob/Page-d359650e3ca94424af8359a24147b9a0#2e8ca5408afb4f83a92b7b84c0dc9903
    def build_child_database(title, *assigns)
      db = Database.new json: {"title" => [TextObject.new(title).property_values_json]},
                        assign: assigns, parent: {"type" => "page_id", "page_id" => @id}
      yield db, db.properties if block_given?
      db
    end

    def create_child_database(title, *assigns, dry_run: false)
      build_child_database title, *assigns
      db = Database.new json: {"title" => [TextObject.new(title).property_values_json]},
                        assign: assigns, parent: {"type" => "page_id", "page_id" => @id}
      yield db, db.properties
      db.save dry_run: dry_run
    end

    # @return [String] title
    # @see https://www.notion.so/hkob/Page-d359650e3ca94424af8359a24147b9a0#2ff7209055f346fbbda454cdbb40b1c8
    def title
      properties.select { |p| p.is_a? TitleProperty }.map(&:full_text).join ""
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
