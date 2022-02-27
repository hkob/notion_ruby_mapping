# frozen_string_literal: true

module NotionRubyMapping
  # TextObject
  class MentionObject < RichTextObject
    # @return [MentionObject]
    def initialize(options = {})
      super "mention", options
    end

    # @return [String (frozen)]
    def text
      ""
    end

    def partial_property_values_json
      if @options.key? "user_id"
        {
          "type" => "user",
          "user" => {
            "object" => "user",
            "id" => @options["user_id"],
          },
        }
      elsif @options.key? "page_id"
        {
          "type" => "page",
          "page" => {
            "id" => @options["page_id"],
          },
        }
      elsif @options.key? "database_id"
        {
          "type" => "database",
          "database" => {
            "id" => @options["database_id"],
          },
        }
      elsif @options.key? "start"
        {
          "type" => "date",
          "date" => @options.slice("start", "end", "time_zone"),
        }
      else
        raise StandardError, "Irregular mention type"
      end
    end
  end
end
