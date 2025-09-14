# frozen_string_literal: true

module NotionRubyMapping
  # Notion database
  class Database < Base
    ### Public announced methods

    # @param [String] id
    # @param [Boolean] dry_run true if dry_run
    # @return [NotionRubyMapping::Database, String]
    # @see https://www.notion.so/hkob/Database-1462b24502424539a4231bedc07dc2f5#58ba9190fd544432a9e2a5823d6c33b7
    def self.find(id, dry_run: false)
      nc = NotionCache.instance
      database_id = Base.database_id id
      if dry_run
        dry_run_script :get, nc.database_path(database_id)
      else
        nc.database database_id
      end
    end

    # @param [String] key
    # @return [NotionRubyMapping::PropertyCache, Hash] obtained Page value or PropertyCache
    def [](key)
      get key
    end

    # @param [Class] klass
    # @param [String] title
    # @return [NotionRubyMapping::Property]
    # @see https://www.notion.so/hkob/Database-1462b24502424539a4231bedc07dc2f5#c9d24269123c444295af88b9b27074a9
    def add_property(klass, title)
      prop = assign_property klass, title
      yield prop if block_given?
      @payload.merge_property prop.property_schema_json
      prop.clear_will_update
      prop
    end

    # @param [String] title
    # @param [Array<String, Property>] assigns
    # @return [NotionRubyMapping::DataSource]
    # @see https://www.notion.so/hkob/Page-d359650e3ca94424af8359a24147b9a0#71f680d59b874930bf9f488a7cd6a49e
    def build_child_data_source(title, *assigns)
      ds = DataSource.new json: {"title" => [TextObject.new(title).property_values_json]},
                          assign: assigns, parent: {"type" => "database_id", "database_id" => @id}
      yield ds, ds.properties if block_given?
      ds
    end

    # @param [String] title
    # @param [Array<String, Property>] assigns
    # @param [Boolean] dry_run true if dry_run
    # @return [NotionRubyMapping::DataSource, String]
    # @see https://www.notion.so/hkob/Page-d359650e3ca94424af8359a24147b9a0#e3f1d21e0f724f589e48431468772eed
    def create_child_data_source(title, *assigns, dry_run: false)
      ds = DataSource.new json: {"title" => [TextObject.new(title).property_values_json]},
                          assign: assigns, parent: {"type" => "database_id", "database_id" => @id}
      yield ds, ds.properties if block_given?
      ds.save dry_run: dry_run
    end

    # @param [Array<Property, Class, String>] assign
    # @return [NotionRubyMapping::Base]
    # @see https://www.notion.so/hkob/DataSource-1462b24502424539a4231bedc07dc2f5#c217ce78020a4de79b720790fce3092d
    def build_child_page(*assign)
      unless data_sources.length == 1
        raise StandardError, "Database #{id} is linked with multiple data_sources, use data_source.build_child_page"
      end

      data_sources.first.build_child_page(*assign) do |page, pp|
        yield page, pp if block_given?
      end
    end

    # @param [Array<Property, Class, String>] assign
    # @param [Boolean] dry_run true if dry_run
    # @return [NotionRubyMapping::Base]
    # @see https://www.notion.so/hkob/DataSource-1462b24502424539a4231bedc07dc2f5#c217ce78020a4de79b720790fce3092d
    def create_child_page(*assign, dry_run: false)
      assign = properties.map { |p| [p.class, p.name] }.flatten if assign.empty?
      page = Page.new assign: assign, parent: {"database_id" => @id}
      pp = page.properties
      pp.clear_will_update
      yield page, pp if block_given?
      page.save dry_run: dry_run
    end

    # @return [NotionRubyMapping::RichTextArray]
    # @see https://www.notion.so/hkob/Database-1462b24502424539a4231bedc07dc2f5#217a7d988c404d68b270c4874a9117b4
    def database_title
      @database_title ||= RichTextArray.new "title", json: (self["title"]), will_update: new_record?
    end

    def data_sources
      return @data_sources if @data_sources

      reload if @json.nil? || !@json.key?("data_sources")
      @data_sources = @json["data_sources"].map do |json|
        DataSource.find json["id"]
      end
    end

    # @return [NotionRubyMapping::RichTextArray]
    def description
      RichTextArray.new "description", json: self["description"]
    end

    # @param [RichTextArray, String, Array<String>, RichTextObject, Array<RichTextObject>] text_info
    def description=(text_info)
      @payload.description = text_info
    end

    # @return [Boolean]
    def is_inline
      self["is_inline"]
    end

    # @param [Boolean] flag
    def is_inline=(flag)
      @payload.is_inline = flag
    end

    # @return [Hash] created json for property schemas (for create database)
    def property_schema_json
      @payload.property_schema_json @property_cache, database_title
    end

    # @return [Hash] created json for property values
    def property_values_json
      @payload.property_values_json @property_cache, database_title
    end

    # @param [Array] property_names
    # @return [Array<NotionRubyMapping::Property>]
    # @see https://www.notion.so/hkob/Database-1462b24502424539a4231bedc07dc2f5#5d15354be2604141adfbf78d14d49942
    def remove_properties(*property_names)
      property_names.map { |n| properties[n] }.each(&:remove)
    end

    # @param [String] old_property_name
    # @param [String] new_property_name
    # @return [NotionRubyMapping::Database]
    def rename_property(old_property_name, new_property_name)
      properties[old_property_name].new_name = new_property_name
      self
    end

    # @return [Hash] created json for property schemas (for update database)
    def update_property_schema_json
      @payload.update_property_schema_json @property_cache, database_title
    end

    protected

    # @param [Boolean] dry_run true if dry_run
    def create(dry_run: false)
      if dry_run
        dry_run_script :post, @nc.databases_path, :property_schema_json
      else
        json = @nc.create_database_request(property_schema_json)
        @new_record = false
        update_json json
      end
    end

    # @return [Hash]
    def reload_json
      @nc.database_request @id
    end

    # @param [Boolean] dry_run true if dry_run
    # @return [NotionRubyMapping::Base, String]
    def update(dry_run: false)
      if dry_run
        dry_run_script :patch, @nc.database_path(@id), :update_property_schema_json
      else
        payload = update_property_schema_json
        begin
          update_json @nc.update_database_request(@id, payload)
        rescue StandardError => e
          raise StandardError, "#{e.message} by #{payload}"
        end
      end
    end
  end
end
