# frozen_string_literal: true

require_relative "../../spec_helper"

module NotionRubyMapping
  RSpec.describe NumberedListItemBlock do
    type = "numbered_list_item"

    it_behaves_like "retrieve block", described_class, TestConnection.block_id(type), true, {
      "object" => "block",
      "type" => "numbered_list_item",
      "numbered_list_item" => {
        "rich_text" => [
          {
            "type" => "text",
            "text" => {
              "content" => "Numbered list",
              "link" => nil,
            },
            "annotations" => {
              "bold" => false,
              "italic" => false,
              "strikethrough" => false,
              "underline" => false,
              "code" => false,
              "color" => "default",
            },
            "plain_text" => "Numbered list",
            "href" => nil,
          },
        ],
        "color" => "default",
      },
    }

    describe "create_child_block" do
      let(:sub_block) { ParagraphBlock.new "with children" }
      let(:target) { NumberedListItemBlock.new "Numbered list item", color: "red", sub_blocks: sub_block }

      it_behaves_like "create child block", described_class,
                      "d43ea31e441d430fb46ca4d4a16a5309", "832ebcf9ede848eb978da4008b5a56e9"
    end

    describe "save (update)" do
      let(:update_id) { TestConnection.update_block_id(type) }
      let(:target) { described_class.new "old text", id: update_id, color: "green_background" }

      it_behaves_like "update block rich text array", type, "new text"
      it_behaves_like "update block color", type, "orange_background", true
    end
  end
end
