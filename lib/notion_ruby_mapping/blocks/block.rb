# frozen_string_literal: true

module NotionRubyMapping
  # Notion block
  class Block < Base
    ### Public announced methods

    # @see https://www.notion.so/hkob/BreadcrumbBlock-3d0905b858524cdd8c868f80fd5d089a#d3b517be0c4b4825bed98206ce3ef41a
    # @see https://www.notion.so/hkob/DividerBlock-d943b964dc4d4eff8f1d24ee0684e29e#f0ac8179c9a044bf95b87de1eb338413
    def initialize(json: nil, id: nil, parent: nil)
      super
      @can_have_children = false
      @can_append = true
    end
    attr_reader :can_have_children, :can_append, :type, :rich_text_array, :url, :caption, :color, :language

    def self.type2class(type, has_children = false)
      @type2class ||= {
        false => {
          "bookmark" => BookmarkBlock,
          "breadcrumb" => BreadcrumbBlock,
          "bulleted_list_item" => BulletedListItemBlock,
          "callout" => CalloutBlock,
          "child_database" => ChildDatabaseBlock,
          "child_page" => ChildPageBlock,
          "code" => CodeBlock,
          "column" => ColumnBlock,
          "column_list" => ColumnListBlock,
          "divider" => DividerBlock,
          "embed" => EmbedBlock,
          "equation" => EquationBlock,
          "file" => FileBlock,
          "heading_1" => Heading1Block,
          "heading_2" => Heading2Block,
          "heading_3" => Heading3Block,
          "image" => ImageBlock,
          "link_preview" => LinkPreviewBlock,
          "link_to_page" => LinkToPageBlock,
          "numbered_list_item" => NumberedListItemBlock,
          "paragraph" => ParagraphBlock,
          "pdf" => PdfBlock,
          "quote" => QuoteBlock,
          "synced_block" => SyncedBlock,
          "table" => TableBlock,
          "table_row" => TableRowBlock,
          "table_of_contents" => TableOfContentsBlock,
          "template" => TemplateBlock,
          "to_do" => ToDoBlock,
          "toggle" => ToggleBlock,
          "video" => VideoBlock,
        },
        true => {
          "heading_1" => ToggleHeading1Block,
          "heading_2" => ToggleHeading2Block,
          "heading_3" => ToggleHeading3Block,
        }
      }
      @klass = @type2class[has_children][type] || @type2class[false][type] || Block
    end

    def self.decode_block(json)
      type2class(json["type"], json["has_children"]).new json: json
    end

    # @see https://www.notion.so/hkob/Block-689ad4cbff50404d8a1baf67b6d6d78d#298916c7c379424682f39ff09ee38544
    # @param [String] id
    # @param [Boolean] dry_run true if dry_run
    # @return [NotionRubyMapping::Block]
    def self.find(id, dry_run: false)
      nc = NotionCache.instance
      block_id = Base.block_id id
      if dry_run
        Base.dry_run_script :get, nc.block_path(block_id)
      else
        nc.block block_id
      end
    end

    # @param [Boolean] dry_run true if dry_run
    # @return [NotionRubyMapping::Block, String]
    # @param [Array<Block>] blocks
    def append_after(*blocks, dry_run: false)
      parent.append_block_children *blocks, after: id, dry_run: dry_run
    end

    # @param [Boolean] not_update false when update
    # @return [Hash{String (frozen)->Hash}]
    def block_json(not_update: true)
      ans = {"type" => type}
      ans["object"] = "block"
      ans["archived"] = true if @archived
      ans
    end

    # @return [Hash{String (frozen)->Array<Hash{String (frozen)->Hash}>}]
    def children_block_json
      {"children" => [block_json]}
    end

    # @return [NotionRubyMapping::RichTextArray]
    def decode_block_caption
      @caption = RichTextArray.new "caption", json: @json[type]["caption"]
    end

    # @return [String]
    def decode_color
      @color = @json[type]["color"]
    end

    # @return [NotionRubyMapping::RichTextArray]
    def decode_block_rich_text_array
      @rich_text_array = RichTextArray.new "rich_text", json: @json[type]["rich_text"]
    end

    # @param [Boolean] dry_run true if dry_run
    # @return [NotionRubyMapping::Base, String]
    def destroy(dry_run: false)
      if dry_run
        Base.dry_run_script :delete, @nc.block_path(@id)
      else
        @nc.destroy_block id
      end
    end

    # @param [Boolean] dry_run true if dry_run
    # @return [NotionRubyMapping::Base, String]
    def update(dry_run: false)
      if dry_run
        dry_run_script :patch, @nc.block_path(@id), :update_block_json
      else
        update_json @nc.update_block_request(@id, update_block_json)
      end
    end

    # @return [Hash]
    def update_block_json
      @payload.update_block_json type, block_json(not_update: false)
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
