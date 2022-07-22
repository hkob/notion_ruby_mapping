# frozen_string_literal: true

module NotionRubyMapping
  # PropertyCache class
  class PropertyCache
    include Enumerable
    def initialize(json = {}, base_type: :page, page_id: nil)
      @properties = {}
      @json = json
      @base_type = base_type
      @page_id = page_id
    end
    attr_writer :json
    attr_reader :page_id

    # @param [String] key
    # @return [Property] Property for key
    # @see https://www.notion.so/hkob/PropertyCache-2451fa64a814432db4809831cc77ba25#9709e2b2a7a0479f9951291a501f65c8
    def [](key)
      @properties[key] ||= Property.create_from_json key, @json[key], @base_type, self
    end

    # @param [Property] property added Property
    def add_property(property)
      @properties[property.name] = property
      property.property_cache = self
      self
    end

    def clear_will_update
      @properties.each do |_, property|
        property.clear_will_update
      end
    end

    # @return [Hash, Enumerator]
    def each(&block)
      return enum_for(:each) unless block_given?

      generate_all_properties.each(&block)
    end

    def generate_all_properties
      if @json.empty?
        @properties.values
      else
        @json.keys.map { |key| self[key] }
      end
    end

    # @return [Hash] created property values json
    def property_values_json
      @properties.each_with_object({}) do |(_, property), ans|
        if property.will_update
          ans["properties"] ||= {}
          ans["properties"].merge! property.property_values_json
        end
      end
    end

    # @return [Hash] created property schema json
    def property_schema_json
      @properties.each_with_object({}) do |(_, property), ans|
        if property.will_update
          ans["properties"] ||= {}
          ans["properties"].merge! property.property_schema_json
        end
      end
    end

    # @return [Hash] created update property schema json
    def update_property_schema_json
      @properties.each_with_object({}) do |(_, property), ans|
        if property.will_update
          ans["properties"] ||= {}
          ans["properties"].merge! property.update_property_schema_json
        end
      end
    end

    # @param [Array] key
    # @return [Array]
    # @see https://www.notion.so/hkob/PropertyCache-2451fa64a814432db4809831cc77ba25#6eb10d1d85784063a30feb225f47ede3
    def values_at(*key)
      generate_all_properties
      @properties.values_at(*key)
    end
  end
end
