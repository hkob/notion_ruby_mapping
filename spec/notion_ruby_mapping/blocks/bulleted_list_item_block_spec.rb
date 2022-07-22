# frozen_string_literal: true

require_relative "../../spec_helper"

module NotionRubyMapping
  RSpec.describe BulletedListItemBlock do
    type = "bulleted_list_item"

    it_behaves_like :retrieve_block, described_class, TestConnection::BLOCK_ID_HASH[type.to_sym], true, {
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
      it_behaves_like :create_child_block, described_class,
                      "fad5be4ae188407ca30c250be45b2c70", "9ebe49d819df4b4fb56124a2650bf1dd"
    end

    describe "save (update)" do
      let(:update_id) { TestConnection::UPDATE_BLOCK_ID_HASH[type.to_sym] }
      let(:target) { described_class.new "old text", id: update_id, color: "green_background" }

      it_behaves_like :update_block_rich_text_array, type, "new text"
      it_behaves_like :update_block_color, type, "orange_background", true
    end
  end
end
