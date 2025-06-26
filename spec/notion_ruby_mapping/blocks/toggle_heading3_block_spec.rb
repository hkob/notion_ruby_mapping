# frozen_string_literal: true

require_relative "../../spec_helper"

module NotionRubyMapping
  RSpec.describe ToggleHeading3Block do
    type = "heading_3"

    it_behaves_like "retrieve block", described_class, TestConnection::BLOCK_ID_HASH[:toggle_heading_3], true, {
      "object" => "block",
      "type" => "heading_3",
      "heading_3" => {
        "rich_text" => [
          {
            "type" => "text",
            "text" => {
              "content" => "Toggle Heading 3",
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
            "plain_text" => "Toggle Heading 3",
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
        ToggleHeading3Block.new "Toggle Heading 3", color: "gray_background", sub_blocks: [
          BulletedListItemBlock.new("inside Toggle Heading 3"),
        ]
      end

      it_behaves_like "create child block", described_class,
                      "f3e307540d8b4268b77ce7f08399c15f", "bdfcf186e57a457c9bd053e1083c9793"
    end

    describe "save (update)" do
      let(:update_id) { TestConnection.update_block_id(:toggle_heading_3) }
      let(:target) do
        described_class.new "Toggle Heading 3", color: "blue_background", id: update_id, sub_blocks: [
          BulletedListItemBlock.new("inside Toggle Heading 3"),
        ]
      end

      it_behaves_like "update block rich text array", type, "New Heading 3"
      it_behaves_like "update block color", type, "green_background", true
    end
  end
end
