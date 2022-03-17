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
        when "template_mention"
          template_mention = mention["template_mention"]
          case template_mention["type"]
          when "template_mention_date"
            MentionObject.new options.merge({"template_mention" => template_mention["template_mention_date"]})
          else
            MentionObject.new options.merge({"template_mention" => template_mention["template_mention_user"]})
          end
        else
          raise StandardError, "Unknown mention type: #{mention["type"]}"
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

    # @param [String, RichTextObject] value
    # @return [String] input text
    def plain_text=(value)
      text(value)
    end

    # @param [Boolean] flag
    # @return [Boolean] input flag
    def bold=(flag)
      @will_update = true
      @options["bold"] = flag
    end

    # @param [Boolean] flag
    # @return [Boolean] input flag
    def italic=(flag)
      @will_update = true
      @options["italic"] = flag
    end

    # @param [Boolean] flag
    # @return [Boolean] input flag
    def strikethrough=(flag)
      @will_update = true
      @options["strikethrough"] = flag
    end

    # @param [Boolean] flag
    # @return [Boolean] input flag
    def underline=(flag)
      @will_update = true
      @options["underline"] = flag
    end

    # @param [Boolean] flag
    # @return [Boolean] input flag
    def code=(flag)
      @will_update = true
      @options["code"] = flag
    end

    # @param [String] color
    # @return [String] input color
    def color=(color)
      @will_update = true
      @options["color"] = color
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
