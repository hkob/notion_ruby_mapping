# frozen_string_literal: true

require_relative "../../spec_helper"

module NotionRubyMapping
  RSpec.describe ToggleHeading4Block do
    type = "heading_4"

    it_behaves_like "retrieve block", described_class, TestConnection::BLOCK_ID_HASH[:toggle_heading_4], true, {
      "object" => "block",
      "type" => "heading_4",
      "heading_4" => {
        "rich_text" => [
          {
            "type" => "text",
            "text" => {
              "content" => "Toggle Heading 4",
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
            "plain_text" => "Toggle Heading 4",
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
        ToggleHeading4Block.new "Toggle Heading 4", color: "yellow_background", sub_blocks: [
          BulletedListItemBlock.new("inside Toggle Heading 4"),
        ]
      end

      it_behaves_like "create child block", described_class,
                      "32ad8e4e98ab813f9496d1ffe8a6b351", "32ad8e4e98ab810faed8df938cf3dfb9"
    end

    describe "save (update)" do
      let(:update_id) { TestConnection.update_block_id(:toggle_heading_4) }
      let(:target) do
        described_class.new "Toggle Heading 4", color: "green_background", id: update_id, sub_blocks: [
          BulletedListItemBlock.new("inside Toggle Heading 4"),
        ]
      end

      it_behaves_like "update block rich text array", type, "New Toggle Heading 4"
      it_behaves_like "update block color", type, "green_background", true
    end
  end
end
