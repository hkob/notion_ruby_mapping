# frozen_string_literal: true

require_relative "../../spec_helper"

module NotionRubyMapping
  RSpec.describe BulletedListItemBlock do
    type = "bulleted_list_item"

    it_behaves_like "retrieve block", described_class, TestConnection.block_id(type), true, {
      "object" => "block",
      "type" => "bulleted_list_item",
      "bulleted_list_item" => {
        "rich_text" => [
          {
            "type" => "text",
            "text" => {
              "content" => "Bulleted list",
              "link" => nil,
            },
            "annotations" => {
              "bold" => false,
              "code" => false,
              "color" => "default",
              "italic" => false,
              "strikethrough" => false,
              "underline" => false,
            },
            "href" => nil,
            "plain_text" => "Bulleted list",
          },
        ],
        "color" => "default",
      },
    }

    describe "create_child_block" do
      let(:sub_block) { ParagraphBlock.new "with children" }
      let(:target) { described_class.new "Bullet list item", color: "green", sub_blocks: sub_block }

      it_behaves_like "create child block", described_class,
                      "26cd8e4e98ab817bae85ed8c26e284e3", "26cd8e4e98ab81108e56d02b052efeab"
    end

    describe "save (update)" do
      let(:update_id) { TestConnection.update_block_id(type) }
      let(:target) { described_class.new "old text", id: update_id, color: "green_background" }

      it_behaves_like "update block rich text array", type, "new text"
      it_behaves_like "update block color", type, "orange_background", true
    end
  end
end
