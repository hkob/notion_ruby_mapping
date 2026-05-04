# frozen_string_literal: true

module NotionRubyMapping
  # CommentObject
  class CommentObject
    # @param [String] text_objects
    def initialize(id: nil, text_objects: nil, json: {})
      nc = NotionCache.instance
      if text_objects
        @id = nc.hex_id id
        @text_objects = RichTextArray.new "rich_text", text_objects: text_objects
        @json = {}
      elsif json
        @json = json
        @id = nc.hex_id json["id"]
        @text_objects = RichTextArray.new "rich_text", json: json["rich_text"]
      else
        raise StandardError, "Either text_objects or json is required CommentObject"
      end
      @will_update = false
    end
    attr_reader :will_update, :text_objects, :json, :id

    def self.find(comment_id)
      new json: NotionCache.instance.comment_request(comment_id)
    end

    def destroy(dry_run: false)
      if dry_run
        Base.dry_run_script :delete, NotionCache.instance.comment_path(id)
      else
        json = NotionCache.instance.destroy_comment_request id
        @text_objects = RichTextArray.new "rich_text", json: json["rich_text"]
        self
      end
    end

    def discussion_id
      NotionCache.instance.hex_id @json["discussion_id"]
    end

    # @return [String] full_text
    def full_text
      @text_objects.full_text
    end

    def markdown=(markdown)
      @markdown = markdown
      @will_update = true
    end

    def rich_text_objects=(text_objects)
      @text_objects.rich_text_objects = text_objects
      @will_update = true
    end

    def save(dry_run: false)
      return unless @will_update

      if dry_run
        json = @markdown ? {"markdown" => @markdown} : {"rich_text" => @text_objects.property_values_json}
        @markdown = nil
        Base.dry_run_script :patch, NotionCache.instance.comment_path(id), json
      else
        json = if @markdown
                 NotionCache.instance.update_comment_request id, markdown: @markdown
               else
                 NotionCache.instance.update_comment_request id, rich_text: @text_objects.property_values_json
               end
        @markdown = nil
        @text_objects = RichTextArray.new "rich_text", json: json["rich_text"]
        @will_update = false
      end
    end
  end
end
