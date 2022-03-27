# frozen_string_literal: true

module NotionRubyMapping
  # Notion Base object (Parent of Page / Database / List)
  class Base
    #### Public announced methods

    # @param [Hash, nil] json
    # @param [String, nil] id
    # @param [Array<Property, Class, String>] assign
    def initialize(json: nil, id: nil, assign: [], parent: nil)
      @nc = NotionCache.instance
      @json = json
      @id = @nc.hex_id(id || json && @json["id"])
      @new_record = true unless parent.nil?
      raise StandardError, "Unknown id" if !is_a?(List) && @id.nil? && parent.nil?

      @payload = Payload.new(parent && {"parent" => parent})
      @property_cache = nil
      @created_time = nil
      @last_edited_time = nil
      return if assign.empty?

      assign.each_slice(2) { |(klass, key)| assign_property(klass, key) }
      @json ||= {}
    end
    attr_reader :json, :id

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

    # @return [NotionRubyMapping::CreatedTimeProperty]
    def created_time
      @created_time ||= CreatedTimeProperty.new("__timestamp__")
    end

    # @return [TrueClass, FalseClass] true if Database object
    def database?
      is_a? Database
    end

    # @return [Hash, nil] obtained Hash
    def icon
      self["icon"]
    end

    # @return [NotionRubyMapping::LastEditedTimeProperty]
    def last_edited_time
      @last_edited_time ||= LastEditedTimeProperty.new("__timestamp__")
    end

    # @return [Boolean] true if new record
    def new_record?
      @new_record
    end

    # @return [TrueClass, FalseClass] true if Page object
    def page?
      is_a? Page
    end

    # @return [NotionRubyMapping::PropertyCache] get or created PropertyCache object
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

    # @return [NotionRubyMapping::Base, String]
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
    def set_icon(emoji: nil, url: nil)
      @payload.set_icon(emoji: emoji, url: url) if page? || database?
      self
    end

    # @return [String] title
    def title
      properties.select { |p| p.is_a? TitleProperty }.map(&:full_text).join ""
    end

    ### Not public announced methods

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
        Block.new json: json
      else
        raise StandardError, json.inspect
      end
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

    # @return [NotionRubyMapping::List]
    def children
      @children ||= @nc.block_children(id)
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

    # @param [Hash] json
    # @return [NotionRubyMapping::Base]
    def update_json(json)
      raise StandardError, json.inspect unless json["object"] != "error" && (@json.nil? || @json["type"] == json["type"])

      @json = json
      @id = @nc.hex_id(@json["id"])
      restore_from_json
      self
    end

    # protected
    # @return [Hash] json properties
    def json_properties
      @json && @json["properties"]
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
      shell << "  -H 'Content-Type: application/json'" unless path == :get
      shell << "  --data '#{JSON.generate json}'" if json
      shell.join(" \\\n")
    end

    protected

    def dry_run_script(method, path, json_method)
      self.class.dry_run_script method, path, send(json_method)
    end
  end
end
