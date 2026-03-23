# frozen_string_literal: true

module NotionRubyMapping
  # Notion page object
  class Page < Base
    ### Public announced methods

    # @param [String] id
    # @param [Boolean] dry_run true if dry_run
    # @return [NotionRubyMapping::Page, String]
    # @see https://www.notion.so/hkob/Page-d359650e3ca94424af8359a24147b9a0#7d868b8b81c3473082bbdc7370813a4a
    def self.find(id, dry_run: false)
      nc = NotionCache.instance
      page_id = Base.page_id id
      if dry_run
        Base.dry_run_script :get, nc.page_path(page_id)
      else
        nc.page page_id
      end
    end

    # @param [String] key
    # @return [NotionRubyMapping::PropertyCache, Hash] obtained Page value or PropertyCache
    def [](key)
      get key
    end

    # @param [Boolean] dry_run true if dry_run
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
    # @param [Boolean] dry_run true if dry_run
    # @return [NotionRubyMapping::Database, String]
    # @see https://www.notion.so/hkob/Page-d359650e3ca94424af8359a24147b9a0#e3f1d21e0f724f589e48431468772eed
    def create_child_database(title, *assigns, dry_run: false)
      db = Database.new json: {"title" => [TextObject.new(title).property_values_json]},
                        assign: assigns, parent: {"type" => "page_id", "page_id" => @id}
      yield db, db.properties if block_given?
      db.save dry_run: dry_run
    end

    # @return [NotionRubyMapping::Base]
    # @param [String, NilClass] template_page
    # @param [String, NilClass] position
    # @param [String, NilClass] markdown
    def build_child_page(template_page: nil, position: nil, markdown: nil)
      page = Page.new assign: [TitleProperty, "title"], parent: {"type" => "page_id", "page_id" => @id},
                      template_page: template_page, position: position, markdown: markdown
      pp = page.properties
      pp.clear_will_update
      yield page, pp if block_given?
      page
    end

    # @param [Boolean] dry_run true if dry_run
    # @return [NotionRubyMapping::Base]
    # @param [String, NilClass] template_page
    # @param [String, NilClass] position
    # @param [String, NilClass] markdown
    def create_child_page(template_page: nil, position: nil, markdown: nil, dry_run: false)
      page = Page.new assign: [TitleProperty, "title"], parent: {"type" => "page_id", "page_id" => @id},
                      template_page: template_page, position: position, markdown: markdown
      pp = page.properties
      pp.clear_will_update
      yield page, pp if block_given?
      page.save dry_run: dry_run
    end

    # @param [String] markdown
    # @param [String, NilClass] after
    # @param [Boolean] dry_run
    # @return [String, NotionRubyMapping::Base]
    def insert_markdown(markdown, after: nil, dry_run: false)
      json = {"type" => "insert_content", "insert_content" => {"content" => markdown}}
      json["insert_content"]["after"] = after if after
      if dry_run
        self.class.dry_run_script :patch, @nc.markdown_page_path(@id), json
      else
        update_json @nc.markdown_page_request(@id, json)
      end
    end

    # @param [Page, DataSource] page_or_data_source
    # @param [Boolean] dry_run true if dry_run
    # @return [NotionRubyMapping::Page, String]
    def move_to(page_or_data_source, dry_run: false)
      key = page_or_data_source.is_a?(Page) ? "page_id" : "data_source_id"
      json = {"parent" => {"type" => key, key => page_or_data_source.id}}
      if dry_run
        self.class.dry_run_script :post, @nc.move_page_path(@id), json
      else
        update_json @nc.move_page_request(@id, json)
      end
    end

    # @return [String] 公開URL
    def public_url
      @json["public_url"]
    end

    # @param [String] replace
    # @param [String] replace_range
    # @param [Boolean] dry_run
    # @return [String, NotionRubyMapping::Base]
    def replace_markdown(replace, replace_range, allow_deleting_content: nil, dry_run: false)
      json = {"type" => "replace_content_range",
              "replace_content_range" => {"content" => replace, "content_range" => replace_range}}
      json["replace_content_range"]["allow_deleting_content"] = true if allow_deleting_content
      if dry_run
        self.class.dry_run_script :patch, @nc.markdown_page_path(@id), json
      else
        update_json @nc.markdown_page_request(@id, json)
      end
    end

    # @return [String] title
    # @see https://www.notion.so/hkob/Page-d359650e3ca94424af8359a24147b9a0#2ff7209055f346fbbda454cdbb40b1c8
    def title
      tp = properties.select { |p| p.is_a?(TitleProperty) || (p.is_a?(Property) && p.property_id == :title) }
      tp.map(&:full_text).join ""
    end

    # @return [String] URL
    def url
      @json["url"]
    end

    protected

    # @param [Boolean] dry_run true if dry_run
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

    # @param [Boolean] dry_run true if dry_run
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
