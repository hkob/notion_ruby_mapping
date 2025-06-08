# frozen_string_literal: true

module NotionRubyMapping
  # DiscussionThread
  class DiscussionThread
    # @param [String] discussion_id
    def initialize(discussion_id)
      @discussion_id = discussion_id
      @comments = []
    end
    attr_reader :discussion_id, :comments

    # @param [String] text_objects
    # @param [Boolean] dry_run true if dry_run
    # @return [String, NotionRubyMapping::CommentObject]
    def append_comment(text_objects, dry_run: false)
      rto = RichTextArray.new "rich_text", text_objects: text_objects, will_update: true
      nc = NotionCache.instance
      json = rto.property_schema_json.merge({discussion_id: @discussion_id})
      if dry_run
        Base.dry_run_script :post, nc.comments_path, json
      else
        CommentObject.new json: (nc.append_comment_request json)
      end
    end
  end
end
