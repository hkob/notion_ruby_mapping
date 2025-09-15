# frozen_string_literal: true

require_relative "../../spec_helper"

module NotionRubyMapping
  RSpec.describe ToggleHeading1Block do
    type = "heading_1"

    it_behaves_like "retrieve block", described_class, TestConnection.block_id("toggle_heading_1"), true, {
      "object" => "block",
      "type" => "heading_1",
      "heading_1" => {
        "rich_text" => [
          {
            "type" => "text",
            "text" => {
              "content" => "Toggle Heading 1",
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
            "plain_text" => "Toggle Heading 1",
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
        described_class.new "Toggle Heading 1", color: "orange_background", sub_blocks: [
          BulletedListItemBlock.new("inside Toggle Heading 1"),
        ]
      end

      it_behaves_like "create child block", described_class,
                      "26ed8e4e98ab815c9df7ed2290d7744a", "26ed8e4e98ab814891e1dd9c66b8836a"
    end

    describe "save (update)" do
      let(:update_id) { TestConnection::UPDATE_BLOCK_ID_HASH[:toggle_heading_1] }
      let(:target) do
        described_class.new "Toggle Heading 1", color: "orange_background", id: update_id, sub_blocks: [
          BulletedListItemBlock.new("inside Toggle Heading 1"),
        ]
      end

      it_behaves_like "update block rich text array", type, "New Heading 1"
      it_behaves_like "update block color", type, "green_background", true
    end
  end
end
