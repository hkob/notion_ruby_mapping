# frozen_string_literal: true

module NotionRubyMapping
  # Notion Base object (Parent of Page / Database / List)
  class Base
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
      assign.each_slice(2) { |(klass, key)| assign_property(klass, key) }
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
        Block.new json: json
      else
        raise StandardError, json.inspect
      end
    end

    def new_record?
      @new_record
    end

    # @return [NotionRubyMapping::PropertyCache] get or created PropertyCache object
    def properties
      unless @property_cache
        unless @json
          raise StandardError, "Unknown id" if @id.nil?

          reload
        end
        @property_cache = PropertyCache.new json_properties
      end
      @property_cache
    end

    # @return [String] title
    def title
      properties.select { |p| p.is_a? TitleProperty }.map(&:full_text).join ""
    end

    # @return [NotionRubyMapping::Base] reloaded self
    def reload
      update_json reload_json
      self
    end
    
   # @return [NotionRubyMapping::Base]
    def save
      @new_record ? create : update
    end

    # @return [Hash] json properties
    def json_properties
      @json && @json["properties"]
    end

    # @return [NotionRubyMapping::List]
    def children
      @children ||= @nc.block_children(id)
    end

    # @param [Hash] json
    # @return [NotionRubyMapping::Base]
    def update_json(json)
      raise StandardError, json.inspect unless json["object"] != "error" && @json.nil? || @json["type"] == json["type"]

      @json = json
      @id = @nc.hex_id(@json["id"])
      restore_from_json
      self
    end

    def restore_from_json
      @payload.clear
      return if (ps = @json["properties"]).nil?

      properties.json = json_properties
      return unless is_a? Page

      ps.each do |key, json|
        properties[key].update_from_json json
      end
    end

    # @param [String] emoji
    # @param [String] url
    # @return [NotionRubyMapping::Base]
    def set_icon(emoji: nil, url: nil)
      if is_a?(Page) || is_a?(Database)
        @payload.set_icon(emoji: emoji, url: url)
      end
      self
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

    # @return [Hash, nil] obtained Hash
    def icon
      self["icon"]
    end

    # @param [Property, Class] klass
    # @param [String] title
    # @return [Property] generated property
    def assign_property(klass, title)
      @property_cache ||= PropertyCache.new {}

      property = klass.new(title, will_update: true)
      @property_cache.add_property property
      property
    end

    # @return [Hash] created json
    def property_values_json
      @payload.property_values_json @property_cache&.property_values_json
    end
  end
end
