# frozen_string_literal: true

require_relative "../../spec_helper"

module NotionRubyMapping
  RSpec.describe NumberedListItemBlock do
    type = "numbered_list_item"

    it_behaves_like :retrieve_block, described_class, TestConnection::BLOCK_ID_HASH[type.to_sym], true, {
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
      it_behaves_like :create_child_block, described_class,
                      "97d2b76fb42f4d2f9aa4f05eadda2c98", "c17d8067f4184bf7a2765cc361607217"
    end

    describe "save (update)" do
      let(:update_id) { TestConnection::UPDATE_BLOCK_ID_HASH[type.to_sym] }
      let(:target) { described_class.new "old text", id: update_id, color: "green_background" }

      it_behaves_like :update_block_rich_text_array, type, "new text"
      it_behaves_like :update_block_color, type, "orange_background", true
    end
  end
end
