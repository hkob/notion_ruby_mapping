# frozen_string_literal: true

module NotionRubyMapping
  # Notion database
  class Database < Base
    ### Public announced methods

    # @param [String] id
    # @return [NotionRubyMapping::Database, String]
    def self.find(id, dry_run: false)
      nc = NotionCache.instance
      if dry_run
        dry_run_script :get, nc.database_path(id)
      else
        nc.database id
      end
    end

    # @return [NotionRubyMapping::Property]
    # @param [Class] klass
    # @param [String] title
    def add_property(klass, title)
      prop = assign_property klass, title
      yield prop if block_given?
      @payload.merge_property prop.property_schema_json
      prop.clear_will_update
      prop
    end

    # @param [Array<Property, Class, String>] assign
    # @return [NotionRubyMapping::Base]
    def create_child_page(*assign)
      assign = properties.map { |p| [p.class, p.name ] }.flatten if assign.empty?
      Page.new assign: assign, parent: {"database_id" => @id}
    end

    # @return [NotionRubyMapping::RichTextArray]
    def database_title
      @database_title ||= RichTextArray.new "title", json: (self["title"]), will_update: new_record?
    end

    def property_schema_json
      @payload.property_schema_json @property_cache, database_title
    end

    # @return [Hash] created json for update database
    def property_values_json
      @payload.property_values_json @property_cache, database_title
    end

    # @param [NotionRubyMapping::Query] query object
    # @return [NotionRubyMapping::List, String]
    def query_database(query = Query.new, dry_run: false)
      if dry_run
        Base.dry_run_script :post, @nc.query_database_path(@id), query.query_json
      else
        response = @nc.database_query @id, query
        List.new json: response, database: self, query: query
      end
    end

    # @param [Array] names
    # @return [Array<NotionRubyMapping::Property>]
    def remove_properties(*names)
      names.map { |n| properties[n] }.each(&:remove)
    end

    # @return [Hash] created json for update database
    def update_property_schema_json
      @payload.update_property_schema_json @property_cache, database_title
    end

    protected

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

    # @return [NotionRubyMapping::Base, String]
    def update(dry_run: false)
      if dry_run
        dry_run_script :patch, @nc.database_path(@id), :update_property_schema_json
      else
        update_json @nc.update_database_request(@id, update_property_schema_json)
      end
    end
  end
end
