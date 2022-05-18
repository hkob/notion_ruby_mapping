# frozen_string_literal: true

module NotionRubyMapping
  # Notion block
  class Block < Base
    ### Public announced methods

    def initialize(json: nil, id: nil, parent: nil)
      super
      @can_have_children = false
      @can_append = true
    end
    attr_reader :can_have_children, :can_append, :type

    # @see https://www.notion.so/hkob/Block-689ad4cbff50404d8a1baf67b6d6d78d#298916c7c379424682f39ff09ee38544
    # @param [String] id
    # @return [NotionRubyMapping::Block]
    def self.find(id, dry_run: false)
      nc = NotionCache.instance
      if dry_run
        Base.dry_run_script :get, nc.block_path(id)
      else
        nc.block id
      end
    end

    # @return [Hash{String (frozen)->String (frozen) | Array}, nil]
    def block_json
      ans = {"type" => @type}
      ans["object"] = "block"
      ans["archived"] = true if @archived
      ans["has_children"] = true if @has_children
      case @type
      when "bookmark", "embed"
        @caption.will_update = true
        ans[@type] = @caption.update_property_schema_json
        ans[@type]["url"] = @url
      when "breadcrumb", "divider"
        ans[@type] = {}
      when "callout"
        @rich_text_array.will_update = true
        ans[@type] = @rich_text_array.update_property_schema_json
        ans[@type]["color"] = @color
        ans[@type]["icon"] = @emoji.property_values_json if @emoji
        ans[@type]["icon"] = @file.property_values_json if @file
        ans[@type]["children"] = @sub_blocks.map(&:block_json) if @sub_blocks
      when "child_database", "child_page"
        ans[@type] = {"title" => @title}
      when "code"
        @rich_text_array.will_update = true
        @caption.will_update = true
        ans[@type] = @rich_text_array.update_property_schema_json.merge @caption.update_property_schema_json
        ans[@type]["language"] = @language
      when "column"
        ans[@type] = {}
        ans[@type]["children"] = @sub_blocks.map(&:block_json) if @sub_blocks
        @can_append = false
      when "column_list"
        ans[@type] = {}
        ans[@type]["children"] = @columns.map(&:block_json) if @columns
      when "paragraph", "bulleted_list_item", "heading_1", "heading_2", "heading_3", "numbered_list_item", "quote",
        "toggle"
        @rich_text_array.will_update = true
        ans[@type] = @rich_text_array.update_property_schema_json
        ans[@type]["color"] = @color
        ans[@type]["children"] = @sub_blocks.map(&:block_json) if @sub_blocks
      when "equation"
        ans[@type] = {"expression" => @equation_object.expression}
      when "file", "image", "pdf", "video"
        @caption.will_update = true if @caption
        ans[@type] = @file_object.property_values_json
        ans[@type].merge! @caption.update_property_schema_json if @caption
      when "link_preview"
        ans[@type] = {"url" => @url}
      when "link_to_page"
        ans[@type] = if @page_id
                       {"type" => "page_id", "page_id" => @page_id}
                     else
                       {"type" => "database_id", "database_id" => @database_id}
                     end
      when "synced_block"
        ans[@type] = {"synced_from" => @block_id ? {"type" => "block_id", "block_id" => @block_id} : nil}
        ans[@type]["children"] = @sub_blocks.map(&:block_json) if @sub_blocks
      when "table"
        ans[@type] = {
          "has_column_header" => @has_column_header,
          "has_row_header" => @has_row_header,
          "table_width" => @table_width,
        }
        ans[@type]["children"] = @table_rows.map(&:block_json) if @table_rows
      when "table_of_contents"
        ans[@type] = {"color" => @color}
      when "table_row"
        ans[@type] = {"cells" => @cells.map { |cell| Array(cell).map(&:property_values_json) }}
      when "template"
        @rich_text_array.will_update = true
        ans[@type] = @rich_text_array.update_property_schema_json
        ans[@type]["children"] = @sub_blocks.map(&:block_json) if @sub_blocks
      when "to_do"
        @rich_text_array.will_update = true
        ans[@type] = @rich_text_array.update_property_schema_json
        ans[@type]["checked"] = @checked
        ans[@type]["color"] = @color
        ans[@type]["children"] = @sub_blocks.map(&:block_json) if @sub_blocks
      else
        print "not yet implemented"
      end
      ans
    end

    # @param [Sting] url
    # @param [RichTextArray, String, Array<String>, RichTextObject, Array<RichTextObject>] caption
    # @return [NotionRubyMapping::Block]
    # @see https://www.notion.so/hkob/Block-689ad4cbff50404d8a1baf67b6d6d78d#ff5299524c434c27bd79e4d942922928
    def bookmark(url, caption: [])
      @type = __method__.to_s
      @url = url
      @caption = RichTextArray.rich_text_array "caption", caption
      self
    end

    # @return [NotionRubyMapping::Block]
    # @see https://www.notion.so/hkob/Block-689ad4cbff50404d8a1baf67b6d6d78d#f0a9dc4e0823485abe5b76051053e877
    def breadcrumb
      @type = __method__.to_s
      self
    end

    # @param [RichTextArray, String, Array<String>, RichTextObject, Array<RichTextObject>] text_info
    # @param [String] color
    # @param [NotionRubyMapping::Block, Array<NotionRubyMapping::Block>, nil] sub_blocks
    # @return [NotionRubyMapping::Block]
    # @see https://www.notion.so/hkob/Block-689ad4cbff50404d8a1baf67b6d6d78d#a97ff4121e724ee1aa45e194d0a76099
    def bulleted_list_item(text_info, sub_blocks: nil, color: "default")
      @type = __method__.to_s
      rich_text_array_and_color "rich_text", text_info, color
      add_sub_blocks sub_blocks
      self
    end

    # @param [RichTextArray, String, Array<String>, RichTextObject, Array<RichTextObject>] text_info
    # @param [String] emoji
    # @param [String] file_url
    # @param [String] color
    # @param [NotionRubyMapping::Block, Array<NotionRubyMapping::Block>, nil] sub_blocks
    # @return [NotionRubyMapping::Block]
    # @see https://www.notion.so/hkob/Block-689ad4cbff50404d8a1baf67b6d6d78d#39b874d7b97749a49eebb9a5f48747a1
    def callout(text_info, emoji: nil, file_url: nil, sub_blocks: nil, color: "default")
      @type = __method__.to_s
      rich_text_array_and_color "rich_text", text_info, color
      @emoji = EmojiObject.emoji_object emoji if emoji
      @file = FileObject.file_object file_url if file_url
      add_sub_blocks sub_blocks
      self
    end

    # @return [Hash{String (frozen)->Array<Hash{String (frozen)->Hash}>}]
    def children_block_json
      {"children" => [block_json]}
    end

    # @param [RichTextArray, String, Array<String>, RichTextObject, Array<RichTextObject>] text_info
    # @param [RichTextArray, String, Array<String>, RichTextObject, Array<RichTextObject>] caption
    # @param [String] language
    # @return [NotionRubyMapping::Block]
    # @see https://www.notion.so/hkob/Block-689ad4cbff50404d8a1baf67b6d6d78d#90f1ebf5ca3f4b479471e6a76ef8c169
    def code(text_info, caption: [], language: "shell")
      @type = __method__.to_s
      rich_text_array_and_color "rich_text", text_info
      @caption = RichTextArray.rich_text_array "caption", caption
      @language = language
      self
    end

    # @return [NotionRubyMapping::Block]
    # @param [NotionRubyMapping::Block, Array<NotionRubyMapping::Block>, nil] sub_blocks
    # @note created by column_list only
    def column(sub_blocks)
      @type = __method__.to_s
      add_sub_blocks sub_blocks
      self
    end

    # @param [Array<Array<NotionRubyMapping::Block, Array<NotionRubyMapping::Block>>>] array_of_sub_blocks
    # @return [NotionRubyMapping::Block]
    # @see https://www.notion.so/hkob/Block-689ad4cbff50404d8a1baf67b6d6d78d#5413288d6d2b4f0f8fe331b0e8e643ca
    def column_list(array_of_sub_blocks)
      @type = __method__.to_s
      raise StandardError, "The column_list must have at least 2 columns." if array_of_sub_blocks.count < 2

      @columns = array_of_sub_blocks.map { |sub_blocks| Block.new.column(sub_blocks) }
      self
    end

    # @return [NotionRubyMapping::Block]
    def decode_block
      @type = @json["type"]
      sub_json = @json[@type]
      case @type
      when "bookmark", "embed"
        @url = sub_json["url"]
        decode_block_caption
      when "bulleted_list_item", "paragraph", "numbered_list_item", "toggle", "heading_1", "heading_2", "heading_3"
        decode_block_rich_text_array
        decode_color
        @can_have_children = true
      when "quote"
        decode_block_rich_text_array
        decode_color
        @can_have_children = true
      when "callout"
        decode_block_rich_text_array
        decode_color
        @can_have_children = true
      when "child_database", "child_page"
        @title = sub_json["title"]
        @can_append = false
      when "code"
        decode_block_rich_text_array
        decode_block_caption
        @language = sub_json["language"] || "shell"
      when "equation"
        @equation_object = EquationObject.equation_object sub_json["expression"]
      when "file", "image", "pdf", "video"
        @file_object = FileObject.new json: sub_json
        decode_block_caption
        @can_append = @file_object.external?
      when "link_preview"
        @url = sub_json["url"]
        @can_append = false
      when "link_to_page"
        @page_id, @database_id = sub_json.values_at(*%w[page_id database_id])
      when "synced_block"
        @block_id = sub_json["synced_from"] && sub_json["synced_from"]["block_id"]
        @can_have_children = @block_id.nil?
      when "table"
        @has_column_header = sub_json["has_column_header"]
        @has_row_header = sub_json["has_row_header"]
        @table_width = sub_json["table_width"]
        @can_have_children = true
      when "table_of_contents"
        decode_color
      when "table_row"
        print sub_json["cells"]
        @cells = sub_json["cells"].map { |cell| cell.map { |to| RichTextObject.create_from_json to } }
      when "template"
        decode_block_rich_text_array
        @can_have_children = true
      when "to_do"
        decode_block_rich_text_array
        decode_color
        @checked = sub_json["checked"]
        @can_have_children = true
      else
        print "not yet implemented"
      end
      @has_children = @json["has_children"] == "true"
      @archived = @json["archived"] == "true"
      self
    end

    # @return [NotionRubyMapping::RichTextArray]
    def decode_block_caption
      @caption = RichTextArray.new "caption", json: @json[@type]["caption"]
    end

    # @return [String]
    def decode_color
      @color = @json[@type]["color"]
    end

    # @return [NotionRubyMapping::RichTextArray]
    def decode_block_rich_text_array
      @rich_text_array = RichTextArray.new "rich_text", json: @json[@type]["rich_text"]
    end

    # @param [Boolean] dry_run
    # @return [NotionRubyMapping::Base, String]
    def destroy(dry_run: false)
      if dry_run
        Base.dry_run_script :delete, @nc.block_path(@id)
      else
        @nc.destroy_block id
      end
    end

    # @return [NotionRubyMapping::Block]
    # @see https://www.notion.so/hkob/Block-689ad4cbff50404d8a1baf67b6d6d78d#fe58d26468e04b38b8ae730e4f0c74ae
    def divider
      @type = __method__.to_s
      self
    end

    # @param [String] url
    # @param [RichTextArray, String, Array<String>, RichTextObject, Array<RichTextObject>] caption
    # @see https://www.notion.so/hkob/Block-689ad4cbff50404d8a1baf67b6d6d78d#1a69571806c24035b93adec8c8480d87
    def embed(url, caption: [])
      @type = __method__.to_s
      @url = url
      @caption = RichTextArray.rich_text_array "caption", caption
      self
    end

    # @param [String, NotionRubyMapping::EquationObject] expression
    # @return [NotionRubyMapping::Block]
    # @see https://www.notion.so/hkob/Block-689ad4cbff50404d8a1baf67b6d6d78d#7e284283779c443a9e26a7bfd10f1b98
    def equation(expression)
      @type = __method__.to_s
      @equation_object = EquationObject.equation_object expression
      self
    end

    # @param [String] url
    # @param [RichTextArray, String, Array<String>, RichTextObject, Array<RichTextObject>] caption
    # @see https://www.notion.so/hkob/Block-689ad4cbff50404d8a1baf67b6d6d78d#6177fa62ef1e408ca498ebe8d8580d65
    def file(url, caption: [])
      @type = __method__.to_s
      @file_object = FileObject.file_object url
      @caption = RichTextArray.rich_text_array "caption", caption
      self
    end

    # @param [RichTextArray, String, Array<String>, RichTextObject, Array<RichTextObject>] text_info
    # @param [String] color
    # @return [NotionRubyMapping::Block]
    def heading_1(text_info, color: "default")
      @type = __method__.to_s
      rich_text_array_and_color "rich_text", text_info, color
      @can_have_children = true
      self
    end

    # @param [RichTextArray, String, Array<String>, RichTextObject, Array<RichTextObject>] text_info
    # @param [String] color
    # @return [NotionRubyMapping::Block]
    def heading_2(text_info, color: "default")
      @type = __method__.to_s
      rich_text_array_and_color "rich_text", text_info, color
      @can_have_children = true
      self
    end

    # @param [RichTextArray, String, Array<String>, RichTextObject, Array<RichTextObject>] text_info
    # @param [String] color
    # @return [NotionRubyMapping::Block]
    def heading_3(text_info, color: "default")
      @type = __method__.to_s
      rich_text_array_and_color "rich_text", text_info, color
      @can_have_children = true
      self
    end

    # @param [String] url
    # @param [RichTextArray, String, Array<String>, RichTextObject, Array<RichTextObject>] caption
    # @see https://www.notion.so/hkob/Block-689ad4cbff50404d8a1baf67b6d6d78d#7aad77515ce14e3bbc7e0a7a5427820b
    def image(url, caption: [])
      @type = __method__.to_s
      @file_object = FileObject.file_object url
      @caption = RichTextArray.rich_text_array "caption", caption
      self
    end

    # @param [String] page_id
    # @param [String] database_id
    # @return [NotionRubyMapping::Block]
    # @see https://www.notion.so/hkob/Block-689ad4cbff50404d8a1baf67b6d6d78d#aabda81c11a949d5ba2e73cf9b50d0ad
    def link_to_page(page_id: nil, database_id: nil)
      raise StandardError, "page_id or database_id is required." if page_id.nil? && database_id.nil?

      @type = __method__.to_s
      @page_id = page_id
      @database_id = database_id
      self
    end

    # @param [RichTextArray, String, Array<String>, RichTextObject, Array<RichTextObject>] text_info
    # @param [NotionRubyMapping::Block, Array<NotionRubyMapping::Block>, nil] sub_blocks
    # @param [String] color
    # @return [NotionRubyMapping::Block]
    # @see https://www.notion.so/hkob/Block-689ad4cbff50404d8a1baf67b6d6d78d#186bfd02b51946bcbc732063e6c3af1c
    def numbered_list_item(text_info, sub_blocks: nil, color: "default")
      @type = __method__.to_s
      rich_text_array_and_color "rich_text", text_info, color
      add_sub_blocks sub_blocks
      self
    end

    # @param [RichTextArray, String, Array<String>, RichTextObject, Array<RichTextObject>] text_info
    # @param [NotionRubyMapping::Block, Array<NotionRubyMapping::Block>, nil] sub_blocks
    # @param [String] color
    # @return [NotionRubyMapping::Block]
    # @see https://www.notion.so/hkob/Block-689ad4cbff50404d8a1baf67b6d6d78d#f3c4fd6a1578429680a5921cbe03c560
    def paragraph(text_info, sub_blocks: nil, color: "default")
      @type = __method__.to_s
      rich_text_array_and_color "rich_text", text_info, color
      add_sub_blocks sub_blocks
      self
    end

    # @param [String] url
    # @see https://www.notion.so/hkob/Block-689ad4cbff50404d8a1baf67b6d6d78d#cd22a466ded048f686ad1f201588d42a
    def pdf(url)
      @type = __method__.to_s
      @file_object = FileObject.file_object url
      self
    end

    # @param [RichTextArray, String, Array<String>, RichTextObject, Array<RichTextObject>] text_info
    # @param [NotionRubyMapping::Block, Array<NotionRubyMapping::Block>, nil] sub_blocks
    # @param [String] color
    # @return [NotionRubyMapping::Block]
    # @see https://www.notion.so/hkob/Block-689ad4cbff50404d8a1baf67b6d6d78d#0a1ed3fc49d544d18606b84d59727b27
    def quote(text_info, sub_blocks: nil, color: "default")
      @type = __method__.to_s
      rich_text_array_and_color "rich_text", text_info, color
      add_sub_blocks sub_blocks
      self
    end

    # @param [Array<Block>] sub_blocks
    # @param [String] block_id
    # @see https://www.notion.so/hkob/Block-689ad4cbff50404d8a1baf67b6d6d78d#69fa1e60d151454aac3c7209a1c41793
    def synced_block(sub_blocks: nil, block_id: nil)
      raise StandardError, "blocks or block_id cannot set at the same time." if !sub_blocks.nil? && !block_id.nil?

      @type = __method__.to_s
      @sub_blocks = Array(sub_blocks) if sub_blocks
      @block_id = block_id
      @can_have_children = @block_id.nil?
      self
    end

    # @return [Boolean] true if synced_block & block_id is nil
    def synced_block_original?
      @type == "synced_block" && @block_id.nil?
    end

    def table(table_width:, has_column_header: false, has_row_header: false, table_rows: nil)
      @type = __method__.to_s
      @table_width = table_width
      @has_column_header = has_column_header
      @has_row_header = has_row_header
      if table_rows
        @table_rows = table_rows.map do |table_row|
          Block.new.table_row table_row, @table_width
        end
      end
      self
    end

    # @param [String] color
    # @return [NotionRubyMapping::Block]
    # @see https://www.notion.so/hkob/Block-689ad4cbff50404d8a1baf67b6d6d78d#272b41e76bef4f3d8e7386369475910e
    def table_of_contents(color: "default")
      @type = __method__.to_s
      @color = color
      self
    end

    # @param [Array<String, Array<String>, TextObject, Array<TextObject>>] array_array_of_text_objects
    # @return [NotionRubyMapping::Block]
    def table_row(array_array_of_text_objects, table_width)
      @type = __method__.to_s
      cc = array_array_of_text_objects.count
      raise StandardError, "table width must be #{table_width} (given array size is #{cc}" unless table_width == cc

      @cells = array_array_of_text_objects.map do |cell|
        Array(cell).map { |text_info| TextObject.text_object text_info }
      end
      self
    end

    # @param [RichTextArray, String, Array<String>, RichTextObject, Array<RichTextObject>] text_info
    # @param [NotionRubyMapping::Block, Array<NotionRubyMapping::Block>, nil] sub_blocks
    # @return [NotionRubyMapping::Block]
    # @see https://www.notion.so/hkob/Block-689ad4cbff50404d8a1baf67b6d6d78d#840eefedd571423e8532ab9042cc0fc1
    def template(text_info, sub_blocks: nil)
      @type = __method__.to_s
      rich_text_array_and_color "rich_text", text_info, nil
      add_sub_blocks sub_blocks
      self
    end

    # @param [RichTextArray, String, Array<String>, RichTextObject, Array<RichTextObject>] text_info
    # @param [Boolean] checked
    # @param [NotionRubyMapping::Block, Array<NotionRubyMapping::Block>, nil] sub_blocks
    # @param [String] color
    # @return [NotionRubyMapping::Block]
    # @see https://www.notion.so/hkob/Block-689ad4cbff50404d8a1baf67b6d6d78d#386e74f3760b43b49a1c3316532f252d
    def to_do(text_info, checked: false, sub_blocks: nil, color: "default")
      @type = __method__.to_s
      rich_text_array_and_color "rich_text", text_info, color
      add_sub_blocks sub_blocks
      @checked = checked
      self
    end

    # @param [RichTextArray, String, Array<String>, RichTextObject, Array<RichTextObject>] text_info
    # @param [Boolean] checked
    # @param [String] color
    # @return [NotionRubyMapping::Block]
    # @see https://www.notion.so/hkob/Block-689ad4cbff50404d8a1baf67b6d6d78d#5a156ee95d0f4a7a83689f7ce5830296
    def toggle(text_info, checked: false, sub_blocks: nil, color: "default")
      @type = __method__.to_s
      rich_text_array_and_color "rich_text", text_info, color
      @checked = checked
      add_sub_blocks sub_blocks
      self
    end

    # @param [RichTextArray, String, Array<String>, RichTextObject, Array<RichTextObject>] text_info
    # @param [NotionRubyMapping::Block, Array<NotionRubyMapping::Block>, nil] sub_blocks
    # @param [String] color
    # @return [NotionRubyMapping::Block]
    # @see
    def toggle_heading_1(text_info, sub_blocks:, color: "default")
      heading_1 text_info, color: color
      add_sub_blocks sub_blocks
      self
    end

    # @param [RichTextArray, String, Array<String>, RichTextObject, Array<RichTextObject>] text_info
    # @param [NotionRubyMapping::Block, Array<NotionRubyMapping::Block>, nil] sub_blocks
    # @param [String] color
    # @return [NotionRubyMapping::Block]
    def toggle_heading_2(text_info, sub_blocks:, color: "default")
      heading_2 text_info, color: color
      add_sub_blocks sub_blocks
      self
    end

    # @param [RichTextArray, String, Array<String>, RichTextObject, Array<RichTextObject>] text_info
    # @param [NotionRubyMapping::Block, Array<NotionRubyMapping::Block>, nil] sub_blocks
    # @param [String] color
    # @return [NotionRubyMapping::Block]
    def toggle_heading_3(text_info, sub_blocks:, color: "default")
      heading_3 text_info, color: color
      add_sub_blocks sub_blocks
      self
    end

    # @param [String] url
    # @see https://www.notion.so/hkob/Block-689ad4cbff50404d8a1baf67b6d6d78d#7aad77515ce14e3bbc7e0a7a5427820b
    def video(url)
      @type = __method__.to_s
      @file_object = FileObject.file_object url
      self
    end

    protected

    def add_sub_blocks(sub_blocks)
      @sub_blocks = Array(sub_blocks) if sub_blocks
      @can_have_children = true
    end

    # @param [String] type
    # @param [String] color
    def rich_text_array_and_color(type, text_info, color = "default")
      @rich_text_array = RichTextArray.rich_text_array type, text_info
      @color = color
      self
    end
  end
end
