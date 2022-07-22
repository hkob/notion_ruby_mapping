# frozen_string_literal: true

require_relative "../../spec_helper"

module NotionRubyMapping
  RSpec.describe ToggleHeading2Block do
    type = "heading_2"

    it_behaves_like :retrieve_block, described_class, TestConnection::BLOCK_ID_HASH[:toggle_heading_2], true, {
      "object" => "block",
      "type" => "heading_2",
      "heading_2" => {
        "rich_text" => [
          {
            "type" => "text",
            "text" => {
              "content" => "Toggle Heading 2",
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
            "plain_text" => "Toggle Heading 2",
            "href" => nil,
          },
        ],
        "color" => "default",
      },
    }

    describe "create_child_block" do
      let(:sub_block) { ParagraphBlock.new "with children" }
      let(:target) do
        ToggleHeading2Block.new "Toggle Heading 2", color: "blue_background", sub_blocks: [
          BulletedListItemBlock.new("inside Toggle Heading 2"),
        ]
      end

      it_behaves_like :create_child_block, described_class,
                      "560b1bfdb9f94c779c10ed703c18dfac", "db0a7c5155e34af3ae64b1679accb37a"
    end

    describe "save (update)" do
      let(:update_id) { TestConnection::UPDATE_BLOCK_ID_HASH[:toggle_heading_2] }
      let(:target) do
        described_class.new "Toggle Heading 2", color: "blue_background", id: update_id, sub_blocks: [
          BulletedListItemBlock.new("inside Toggle Heading 2"),
        ]
      end

      it_behaves_like :update_block_rich_text_array, type, "New Heading 2"
      it_behaves_like :update_block_color, type, "green_background", true
    end
  end
end
