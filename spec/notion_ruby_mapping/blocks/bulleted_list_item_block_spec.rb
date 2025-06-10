# frozen_string_literal: true

require_relative "../../spec_helper"

module NotionRubyMapping
  RSpec.describe BulletedListItemBlock do
    type = :bulleted_list_item

    it_behaves_like "retrieve block", described_class, TestConnection::BLOCK_ID_HASH[type.to_sym], true, {
      object: "block",
      type: "bulleted_list_item",
      bulleted_list_item: {
        rich_text: [
          {
            type: "text",
            text: {
              content: "Bulleted list",
              link: nil,
            },
            annotations: {
              bold: false,
              code: false,
              color: "default",
              italic: false,
              strikethrough: false,
              underline: false,
            },
            href: nil,
            plain_text: "Bulleted list",
          },
        ],
        color: "default",
      },
    }

    describe "create_child_block" do
      let(:sub_block) { ParagraphBlock.new "with children" }
      let(:target) { described_class.new "Bullet list item", color: "green", sub_blocks: sub_block }

      it_behaves_like "create child block", described_class,
                      "e9b08f364af846d3a282ce575d2abddf", "a1948b8fbdc544f1a1b3f8992b8100b0"
    end

    describe "save (update)" do
      let(:update_id) { TestConnection::UPDATE_BLOCK_ID_HASH[type.to_sym] }
      let(:target) { described_class.new "old text", id: update_id, color: "green_background" }

      it_behaves_like "update block rich text array", type, "new text"
      it_behaves_like "update block color", type, "orange_background", true
    end
  end
end
