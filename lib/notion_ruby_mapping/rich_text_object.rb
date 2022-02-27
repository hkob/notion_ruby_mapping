# frozen_string_literal: true

module NotionRubyMapping
  # RichTextObject
  class RichTextObject
    # @param [String] type
    # @return [TextObject]
    def initialize(type, options = {})
      if instance_of?(RichTextObject)
        raise StandardError,
              "RichTextObject is abstract class.  Please use TextObject."
      end

      @type = type
      @options = options
    end

    def self.create_from_json(json)
      type = json["type"]
      options = (json["annotations"] || {}).merge(json.slice("plain_text", "href"))
      case type
      when "text"
        TextObject.new json["plain_text"], options
      when "mention"
        mention = json["mention"]
        case mention["type"]
        when "user"
          MentionObject.new options.merge({"user_id" => mention["user"]["id"]})
        when "page"
          MentionObject.new options.merge({"page_id" => mention["page"]["id"]})
        when "database"
          MentionObject.new options.merge({"database_id" => mention["database"]["id"]})
        when "date"
          MentionObject.new options.merge(mention["date"].slice("start", "end", "time_zone"))
        else
          raise StandardError, json
        end
      else
        raise StandardError, json
      end
    end

    # @param [RichTextObject, String] to
    # @return [NotionRubyMapping::RichTextObject] RichTextObject
    def self.text_object(to)
      if to.is_a? RichTextObject
        to
      else
        TextObject.new to
      end
    end

    # @return [Hash{String (frozen)->Object}]
    def property_values_json
      {
        "type" => @type,
        @type => partial_property_values_json,
        "plain_text" => @options["plain_text"],
        "href" => @options["href"],
      }.merge annotations_json
    end

    protected

    # @return [Hash] options
    attr_reader :options

    # @return [Hash, Hash{String (frozen)->Hash}]
    def annotations_json
      annotations = @options.slice(*%w[bold italic strikethrough underline code color])
      annotations.empty? ? {} : {"annotations" => annotations}
    end
  end
end
