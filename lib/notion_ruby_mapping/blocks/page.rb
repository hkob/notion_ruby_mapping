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

    def append_comment(text_objects, dry_run: false)
      rto = RichTextArray.new "rich_text", text_objects: text_objects, will_update: true
      json = rto.property_schema_json.merge({"parent" => {"page_id" => @id}})
      if dry_run
        self.class.dry_run_script :post, @nc.comments_path, json
      else
        CommentObject.new json: (@nc.append_comment_request json)
      end
    end

    # @param [String] title
    # @param [Array<String, Property>] assigns
    # @return [NotionRubyMapping::Database]
    # @see https://www.notion.so/hkob/Page-d359650e3ca94424af8359a24147b9a0#71f680d59b874930bf9f488a7cd6a49e
    def build_child_database(title, *assigns)
      db = Database.new json: {"title" => [TextObject.new(title).property_values_json]},
                        assign: assigns, parent: {"type" => "page_id", "page_id" => @id}
      yield db, db.properties if block_given?
      db
    end

    # @param [String] title
    # @param [Array<String, Property>] assigns
    # @return [NotionRubyMapping::Database]
    # @see https://www.notion.so/hkob/Page-d359650e3ca94424af8359a24147b9a0#e3f1d21e0f724f589e48431468772eed
    def create_child_database(title, *assigns, dry_run: false)
      build_child_database(title, *assigns).save dry_run: dry_run
    end

    # @return [String] title
    # @see https://www.notion.so/hkob/Page-d359650e3ca94424af8359a24147b9a0#2ff7209055f346fbbda454cdbb40b1c8
    def title
      tp = properties.select { |p| (p.is_a?(TitleProperty)) || (p.is_a?(Property) && p.property_id == "title") }
      tp.map(&:full_text).join ""
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
