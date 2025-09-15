# frozen_string_literal: true

require_relative "../../spec_helper"

module NotionRubyMapping
  RSpec.describe ToggleHeading2Block do
    type = "heading_2"

    it_behaves_like "retrieve block", described_class, TestConnection.block_id(:toggle_heading_2), true, {
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
        "is_toggleable" => true,
      },
    }

    describe "create_child_block" do
      let(:sub_block) { ParagraphBlock.new "with children" }
      let(:target) do
        ToggleHeading2Block.new "Toggle Heading 2", color: "blue_background", sub_blocks: [
          BulletedListItemBlock.new("inside Toggle Heading 2"),
        ]
      end

      it_behaves_like "create child block", described_class,
                      "26ed8e4e98ab81d8abb7f843c86971af", "26ed8e4e98ab816db4e2cf45b2f17f29"
    end

    describe "save (update)" do
      let(:update_id) { TestConnection::UPDATE_BLOCK_ID_HASH[:toggle_heading_2] }
      let(:target) do
        described_class.new "Toggle Heading 2", color: "blue_background", id: update_id, sub_blocks: [
          BulletedListItemBlock.new("inside Toggle Heading 2"),
        ]
      end

      it_behaves_like "update block rich text array", type, "New Heading 2"
      it_behaves_like "update block color", type, "green_background", true
    end
  end
end
