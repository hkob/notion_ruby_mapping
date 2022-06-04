# frozen_string_literal: true

require_relative "../../spec_helper"

module NotionRubyMapping
  RSpec.describe ToggleHeading3Block do
    type = "heading_3"

    it_behaves_like :retrieve_block, described_class, TestConnection::BLOCK_ID_HASH[:toggle_heading_3], true, {
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
      },
    }

    describe "create_child_block" do
      let(:sub_block) { ParagraphBlock.new "with children" }
      let(:target) do
        ToggleHeading3Block.new "Toggle Heading 3", color: "gray_background", sub_blocks: [
          BulletedListItemBlock.new("inside Toggle Heading 3"),
        ]
      end
      it_behaves_like :create_child_block, described_class,
                      "2fa069b2b2304239803dc39e73fa4bf6", "4cd554bf557d488297ebe322a15b85be"
    end

    describe "save (update)" do
      let(:update_id) { TestConnection::UPDATE_BLOCK_ID_HASH[:toggle_heading_3] }
      let(:target) do
        described_class.new "Toggle Heading 3", color: "blue_background", id: update_id, sub_blocks: [
          BulletedListItemBlock.new("inside Toggle Heading 3"),
        ]
      end

      it_behaves_like :update_block_rich_text_array, type, "New Heading 3"
      it_behaves_like :update_block_color, type, "green_background", true
    end
  end
end
