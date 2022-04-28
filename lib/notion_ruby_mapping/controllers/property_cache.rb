# frozen_string_literal: true

module NotionRubyMapping
  # PropertyCache class
  class PropertyCache
    include Enumerable
    def initialize(json = {}, base_type: :page)
      @properties = {}
      @json = json
      @base_type = base_type
    end
    attr_writer :json

    # @param [String] key
    # @return [Property] Property for key
    def [](key)
      @properties[key] ||= Property.create_from_json key, @json[key], @base_type
    end

    # @param [Array] key
    # @return [Array]
    def values_at(*key)
      generate_all_properties
      @properties.values_at(*key)
    end

    def generate_all_properties
      if @json.empty?
        @properties.values
      else
        @json.keys.map { |key| self[key] }
      end
    end

    # @return [Hash, Enumerator]
    def each(&block)
      return enum_for(:each) unless block_given?

      generate_all_properties.each(&block)
    end

    # @param [Property] property added Property
    def add_property(property)
      @properties[property.name] = property
      self
    end


    def clear_will_update
      @properties.each do |_, property|
        property.clear_will_update
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
  end
end