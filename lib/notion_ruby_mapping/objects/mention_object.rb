# frozen_string_literal: true

module NotionRubyMapping
  # TextObject
  class MentionObject < RichTextObject
    # @return [MentionObject]
    def initialize(options = {})
      super "mention", options
      return unless (url = options["link_preview"])

      @options["href"] = url
      @options["plain_text"] = url
    end

    # @return [String, NilClass]
    def page_id
      @options["page_id"]
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
      elsif @options.key? "template_mention"
        sub = case @options["template_mention"]
              when "today"
                @options["plain_text"] = "@Today"
                {
                  "type" => "template_mention_date",
                  "template_mention_date" => "today",
                }
              when "now"
                @options["plain_text"] = "@Now"
                {
                  "type" => "template_mention_date",
                  "template_mention_date" => "now",
                }
              else
                @options["plain_text"] = "@Me"
                {
                  "type" => "template_mention_user",
                  "template_mention_user" => "me",
                }
              end
        {
          "type" => "template_mention",
          "template_mention" => sub,
        }
      elsif @options.key? "link_preview"
        {
          "type" => "link_preview",
          "link_preview" => {
            "url" => @options["link_preview"],
          },
        }
      else
        raise StandardError, "Irregular mention type: #{@options.keys}"
      end
    end
  end
end
