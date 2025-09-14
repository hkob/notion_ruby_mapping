# frozen_string_literal: true

module NotionRubyMapping
  # Notion data_source
  class DataSource < Base
    ### Public announced methods

    # @param [String] id
    # @param [Boolean] dry_run true if dry_run
    # @return [NotionRubyMapping::DataSource, String]
    # @see https://www.notion.so/hkob/DataSource-1462b24502424539a4231bedc07dc2f5#58ba9190fd544432a9e2a5823d6c33b7
    def self.find(id, dry_run: false)
      nc = NotionCache.instance
      data_source_id = Base.data_source_id id
      if dry_run
        dry_run_script :get, nc.data_source_path(data_source_id)
      else
        nc.data_source data_source_id
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
    # @see https://www.notion.so/hkob/DataSource-1462b24502424539a4231bedc07dc2f5#c9d24269123c444295af88b9b27074a9
    def add_property(klass, title)
      prop = assign_property klass, title
      yield prop if block_given?
      @payload.merge_property prop.property_schema_json
      prop.clear_will_update
      prop
    end

    # @param [Array<Property, Class, String>] assign
    # @return [NotionRubyMapping::Base]
    # @see https://www.notion.so/hkob/DataSource-1462b24502424539a4231bedc07dc2f5#c217ce78020a4de79b720790fce3092d
    def build_child_page(*assign)
      assign = properties.map { |p| [p.class, p.name] }.flatten if assign.empty?
      page = Page.new assign: assign, parent: {"data_source_id" => @id}
      pp = page.properties
      pp.clear_will_update
      yield page, pp if block_given?
      page
    end

    # @param [Array<Property, Class, String>] assign
    # @param [Boolean] dry_run true if dry_run
    # @return [NotionRubyMapping::Base]
    # @see https://www.notion.so/hkob/DataSource-1462b24502424539a4231bedc07dc2f5#c217ce78020a4de79b720790fce3092d
    def create_child_page(*assign, dry_run: false)
      assign = properties.map { |p| [p.class, p.name] }.flatten if assign.empty?
      page = Page.new assign: assign, parent: {"data_source_id" => @id}
      pp = page.properties
      pp.clear_will_update
      yield page, pp if block_given?
      page.save dry_run: dry_run
    end

    # @return [NotionRubyMapping::RichTextArray]
    # @see https://www.notion.so/hkob/DataSource-1462b24502424539a4231bedc07dc2f5#217a7d988c404d68b270c4874a9117b4
    def data_source_title
      @data_source_title ||= RichTextArray.new "title", json: (self["title"]), will_update: new_record?
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

    # @return [Hash] created json for property schemas (for create data_source)
    def property_schema_json
      @payload.property_schema_json @property_cache, data_source_title
    end

    # @return [Hash] created json for property values
    def property_values_json
      @payload.property_values_json @property_cache, data_source_title
    end

    # @param [NotionRubyMapping::Query] query object
    # @param [Boolean] dry_run true if dry_run
    # @return [NotionRubyMapping::List, String]
    # @see https://www.notion.so/hkob/DataSource-1462b24502424539a4231bedc07dc2f5#6bd9acf62c454f64bc555c8828057e6b
    def query_data_source(query = Query.new, dry_run: false)
      if dry_run
        Base.dry_run_script :post, @nc.query_data_source_path(@id), query.query_json
      else
        response = @nc.data_source_query_request @id, query
        List.new json: response, type: "data_source", value: self, query: query
      end
    end

    # @param [Array] property_names
    # @return [Array<NotionRubyMapping::Property>]
    # @see https://www.notion.so/hkob/DataSource-1462b24502424539a4231bedc07dc2f5#5d15354be2604141adfbf78d14d49942
    def remove_properties(*property_names)
      property_names.map { |n| properties[n] }.each(&:remove)
    end

    # @param [String] old_property_name
    # @param [String] new_property_name
    # @return [NotionRubyMapping::DataSource]
    def rename_property(old_property_name, new_property_name)
      properties[old_property_name].new_name = new_property_name
      self
    end

    # @return [Hash] created json for property schemas (for update data_source)
    def update_property_schema_json
      @payload.update_property_schema_json @property_cache, data_source_title
    end

    protected

    # @param [Boolean] dry_run true if dry_run
    def create(dry_run: false)
      if dry_run
        dry_run_script :post, @nc.data_sources_path, :property_schema_json
      else
        json = @nc.create_data_source_request(property_schema_json)
        @new_record = false
        update_json json
      end
    end

    # @return [Hash]
    def reload_json
      @nc.data_source_request @id
    end

    # @param [Boolean] dry_run true if dry_run
    # @return [NotionRubyMapping::Base, String]
    def update(dry_run: false)
      if dry_run
        dry_run_script :patch, @nc.data_source_path(@id), :update_property_schema_json
      else
        payload = update_property_schema_json
        begin
          update_json @nc.update_data_source_request(@id, payload)
        rescue StandardError => e
          raise StandardError, "#{e.message} by #{payload}"
        end
      end
    end
  end
end
