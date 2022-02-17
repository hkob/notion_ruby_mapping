module NotionRubyMapping
  class PropertyCache
    def initialize(json = {})
      @properties = {}
      @json = json
    end

    # @param [String] key
    # @return [Property] Property for key
    def [](key)
      ans = @properties[key]
      unless ans
        if @json && @json[key]
          @properties[key] = Property.create_from_json key, @json[key]
        end
      end
      @properties[key]
    end

    # @param [Property] property added Property
    # @param [FalseClass] will_update true if the property value will update to Notion
    def add_property(property, will_update: false)
      @properties[property.name] = property
      property.will_update = true if will_update
      self
    end

    # @return [Hash] created json
    def create_json
      @properties.each_with_object({}) do |(key, property), ans|
        if property.will_update
          ans["properties"] ||= {}
          ans["properties"][key] = property.create_json
        end
      end
    end
  end
end
