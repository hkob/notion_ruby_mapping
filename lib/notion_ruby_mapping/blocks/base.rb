# frozen_string_literal: true

module NotionRubyMapping
  # Notion Base object (Parent of Page / Database / List)
  # The Public API method has a link to the API references.
  class Base
    # @param [Hash, nil] json
    # @param [String, nil] id
    # @param [Array<Property, Class, String>] assign
    def initialize(json: nil, id: nil, assign: [], parent: nil)
      @nc = NotionCache.instance
      @json = json
      @id = @nc.hex_id(id || json && @json["id"])
      @new_record = true unless parent.nil?
      raise StandardError, "Unknown id" if !is_a?(List) && !is_a?(Block) && @id.nil? && parent.nil?

      @payload = Payload.new(!is_a?(Block) && parent && {"parent" => parent})
      @property_cache = nil
      @created_time = nil
      @last_edited_time = nil
      return if assign.empty?

      assign.each_slice(2) { |(klass, key)| assign_property(klass, key) }
      @json ||= {}
    end
    attr_reader :json, :id

    # @param [Hash, Notion::Messages] json
    # @return [NotionRubyMapping::Base]
    def self.create_from_json(json)
      case json["object"]
      when "page"
        Page.new json: json
      when "database"
        Database.new json: json
      when "list"
        List.new json: json
      when "block"
        Block.new(json: json).decode_block
      else
        raise StandardError, json.inspect
      end
    end

    # @param [Object] method
    # @param [Object] path
    # @param [nil] json
    def self.dry_run_script(method, path, json = nil)
      shell = [
        "#!/bin/sh\ncurl #{method == :get ? "" : "-X #{method.to_s.upcase}"} 'https://api.notion.com/#{path}'",
        "  -H 'Notion-Version: 2022-02-22'",
        "  -H 'Authorization: Bearer '\"$NOTION_API_KEY\"''",
      ]
      shell << "  -H 'Content-Type: application/json'" if %i[post patch].include?(method)
      shell << "  --data '#{JSON.generate json}'" if json
      shell.join(" \\\n")
    end

    # @param [String] key
    # @return [NotionRubyMapping::PropertyCache, Hash] obtained Page value or PropertyCache
    def [](key)
      unless @json
        raise StandardError, "Unknown id" if @id.nil?

        reload
      end
      case key
      when "properties"
        properties
      else
        @json[key]
      end
    end

    # @param [Array<Block>] blocks
    # @param [Boolean] dry_run
    # @return [NotionRubyMapping::Block, String]
    # @see https://www.notion.so/hkob/Page-d359650e3ca94424af8359a24147b9a0#44bbf83d852c419485c5efe9fe1558fb
    # @see https://www.notion.so/hkob/Block-689ad4cbff50404d8a1baf67b6d6d78d#2c47f7fedae543cf8566389ba1677132
    def append_block_children(*blocks, dry_run: false)
      raise StandardError, "This block can have no children." unless page? || (block? && can_have_children)

      only_one = blocks.length == 1
      json = {
        "children" => Array(blocks).map do |block|
          assert_parent_children_pair block
          block.block_json
        end,
      }
      if dry_run
        path = @nc.append_block_children_page_path(id)
        self.class.dry_run_script :patch, path, json
      else
        response = @nc.append_block_children_request @id, json
        raise StandardError, response unless response["results"]

        answers = response["results"].map { |sub_json| Block.new json: sub_json }
        only_one ? answers.first : answers
      end
    end

    # @param [NotionRubyMapping::Block] block
    def assert_parent_children_pair(block)
      raise StandardError, "the argument is not a block." unless block.block?

      raise StandardError, "#{type} cannot have children." if block? && !@can_have_children

      return if block.can_append

      bt = block.type
      raise StandardError, "Internal file block can not append." if bt == "file"

      raise StandardError, "Column block can only append column_list block" unless bt == "column" &&
                                                                                   block? && type == "columu_list"
    end

    # @param [NotionRubyMapping::Property] klass
    # @param [String] title
    # @return [NotionRubyMapping::Property] generated property
    def assign_property(klass, title)
      @property_cache ||= PropertyCache.new({}, base_type: database? ? :database : :page)
      property = if database?
                   klass.new(title, will_update: new_record?, base_type: :database)
                 else
                   klass.new(title, will_update: true, base_type: :page)
                 end
      @property_cache.add_property property
      property
    end

    # @return [TrueClass, FalseClass] true if Block object
    def block?
      is_a? Block
    end

    # @param [NotionRubyMapping::Query] query
    # @param [Boolean] dry_run
    # @return [NotionRubyMapping::List, String]
    def children(query = Query.new, dry_run: false)
      if dry_run
        path = @nc.block_children_page_path(id) + query.query_string
        self.class.dry_run_script :get, path
      elsif @children
        @children
      else
        response = @nc.block_children_request @id, query.query_string
        @children = List.new json: response, parent: self, query: query
      end
    end

    # @return [NotionRubyMapping::Block]
    def create_child_breadcrumb
      raise StandardError unless page? || (block? && can_have_children)

      Block.new(parent: self).breadcrumb
    end

    # @return [NotionRubyMapping::CreatedTimeProperty]
    def created_time
      @created_time ||= CreatedTimeProperty.new("__timestamp__", json: self["created_time"])
    end

    # @return [TrueClass, FalseClass] true if Database object
    def database?
      is_a? Database
    end

    # @return [Hash, nil] obtained Hash
    # @see https://www.notion.so/hkob/Page-d359650e3ca94424af8359a24147b9a0#e13d526bd709451e9b06fd32e8d07fcd
    def icon
      self["icon"]
    end

    # @return [String (frozen)]
    def inspect
      "#{self.class.name}-#{@id}"
    end

    # @return [Hash] json properties
    def json_properties
      @json && @json["properties"]
    end

    # @return [NotionRubyMapping::LastEditedTimeProperty]
    def last_edited_time
      @last_edited_time ||= LastEditedTimeProperty.new("__timestamp__", json: self["last_edited_time"])
    end

    # @return [Boolean] true if new record
    # @see https://www.notion.so/hkob/Page-d359650e3ca94424af8359a24147b9a0#307af6e40d3840c59f8a82513a572d51
    def new_record?
      @new_record
    end

    # @return [TrueClass, FalseClass] true if Page object
    def page?
      is_a? Page
    end

    # @return [NotionRubyMapping::PropertyCache] get or created PropertyCache object
    # @see https://www.notion.so/hkob/Page-d359650e3ca94424af8359a24147b9a0#8f0b28e09dd74e2a9ff06126c48d64d4
    def properties
      unless @property_cache
        unless @json
          raise StandardError, "Unknown id" if @id.nil?

          reload
        end
        @property_cache = PropertyCache.new json_properties, base_type: database? ? :database : :page
      end
      @property_cache
    end

    # @return [Hash] created json for update page
    def property_values_json
      @payload.property_values_json @property_cache
    end

    # @return [NotionRubyMapping::Base] reloaded self
    def reload
      update_json reload_json
      self
    end

    # @return [NotionRubyMapping::Base]
    def restore_from_json
      return if (ps = @json["properties"]).nil?

      properties.json = json_properties
      return unless is_a?(Page) || is_a?(Database)

      ps.each do |key, json|
        properties[key].update_from_json json
      end
      self
    end

    # @param [Boolean] dry_run
    # @return [NotionRubyMapping::Base, String]
    # @see https://www.notion.so/hkob/Page-d359650e3ca94424af8359a24147b9a0#277085c8439841c798a4b94eae9a7326
    def save(dry_run: false)
      if dry_run
        @new_record ? create(dry_run: true) : update(dry_run: true)
      else
        @new_record ? create : update
        @property_cache.clear_will_update
        @payload.clear
        self
      end
    end

    # @param [String] emoji
    # @param [String] url
    # @return [NotionRubyMapping::Base]
    # @see https://www.notion.so/hkob/Page-d359650e3ca94424af8359a24147b9a0#62eea67af7824496820c6bb903503540
    # @see https://www.notion.so/hkob/Page-d359650e3ca94424af8359a24147b9a0#e13d526bd709451e9b06fd32e8d07fcd
    def set_icon(emoji: nil, url: nil)
      @payload.set_icon(emoji: emoji, url: url) if page? || database?
      self
    end

    # @return [FalseClass] return false except block
    def synced_block_original?
      false
    end

    # @param [Hash] json
    # @return [NotionRubyMapping::Base]
    def update_json(json)
      raise StandardError, json.inspect unless json["object"] != "error" && (@json.nil? || @json["type"] == json["type"])

      @json = json
      @id = @nc.hex_id(@json["id"])
      restore_from_json
      self
    end

    ### Not public announced methods

    protected

    def dry_run_script(method, path, json_method)
      self.class.dry_run_script method, path, send(json_method)
    end
  end
end
