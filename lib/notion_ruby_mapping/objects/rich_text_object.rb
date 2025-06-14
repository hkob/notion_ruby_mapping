# frozen_string_literal: true

module NotionRubyMapping
  # RichTextObject
  class RichTextObject
    # @param [Symbol] type
    # @return [TextObject]
    def initialize(type, options = {})
      if instance_of?(RichTextObject)
        raise StandardError,
              "RichTextObject is abstract class.  Please use TextObject."
      end

      @type = type.to_sym
      @options = options
    end
    attr_reader :will_update, :options

    def self.create_from_json(json)
      type = json[:type]&.to_sym
      options = (json[:annotations] || {}).merge(json.slice(:plain_text, :href))
      case type
      when :text
        TextObject.new json[:plain_text], options
      when :equation
        EquationObject.new json[:equation][:expression], options
      when :mention
        mention = json[:mention]
        case mention[:type]&.to_sym
        when :user
          MentionObject.new options.merge({user_id: mention[:user][:id]})
        when :page
          MentionObject.new options.merge({page_id: mention[:page][:id]})
        when :database
          MentionObject.new options.merge({database_id: mention[:database][:id]})
        when :date
          MentionObject.new options.merge(mention[:date].slice(:start, :end, :time_zone))
        when :template_mention
          template_mention = mention[:template_mention]
          case template_mention[:type].to_sym
          when :template_mention_date
            MentionObject.new options.merge({template_mention: template_mention[:template_mention_date]})
          else
            MentionObject.new options.merge({template_mention: template_mention[:template_mention_user]})
          end
        when :link_preview
          MentionObject.new options.merge({link_preview: mention[:link_preview][:url]})
        when :link_mention
          lm_keys = %i[href icon_url link_provider thumbnail_url title]
          MentionObject.new options.merge(mention[:link_mention].slice(*lm_keys))
        else
          raise StandardError, "Unknown mention type: #{mention[:type]}"
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
        type: @type.to_s,
        @type => partial_property_values_json,
        plain_text: @options[:plain_text],
        href: @options[:href],
      }.merge annotations_json
    end

    # @return [FalseClass]
    def clear_will_update
      @will_update = false
    end

    # @param [String] url
    # @return [String] input text
    def href=(url)
      @will_update = true
      @options[:href] = url
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
      @options[:bold] = flag
    end

    # @param [Boolean] flag
    # @return [Boolean] input flag
    def italic=(flag)
      @will_update = true
      @options[:italic] = flag
    end

    # @param [Boolean] flag
    # @return [Boolean] input flag
    def strikethrough=(flag)
      @will_update = true
      @options[:strikethrough] = flag
    end

    # @param [Boolean] flag
    # @return [Boolean] input flag
    def underline=(flag)
      @will_update = true
      @options[:underline] = flag
    end

    # @param [Boolean] flag
    # @return [Boolean] input flag
    def code=(flag)
      @will_update = true
      @options[:code] = flag
    end

    # @param [String] color
    # @return [String] input color
    def color=(color)
      @will_update = true
      @options[:color] = color
    end

    protected

    # @return [Hash, Hash{String (frozen)->Hash}]
    def annotations_json
      annotations = @options.slice(*%i[bold italic strikethrough underline code color])
      annotations.empty? ? {} : {annotations: annotations}
    end
  end
end
