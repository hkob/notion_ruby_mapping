module NotionRubyMapping
  class TemplateObject
    def initialize(json: json)
      @id = json["id"]
      @name = json["name"]
      @is_default = json["is_default"]
    end
    attr_reader :id, :name, :is_default

    # @return [Hash{String->String, Boolean}]
    def property_values_json
      {
        "id" => @id,
        "name" => @name,
        "is_default" => @is_default
      }
    end
  end
end
