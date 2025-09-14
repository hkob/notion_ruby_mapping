# frozen_string_literal: true

require_relative "../../spec_helper"

module NotionRubyMapping
  RSpec.describe ToggleBlock do
    type = "toggle"

    it_behaves_like "retrieve block", described_class, TestConnection.block_id(type), true, {
      "object" => "block",
      "type" => "toggle",
      "toggle" => {
        "rich_text" => [
          {
            "type" => "text",
            "text" => {
              "content" => "Toggle",
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
            "plain_text" => "Toggle",
            "href" => nil,
          },
        ],
        "color" => "default",
      },
    }

    describe "create_child_block" do
      let(:sub_block) { ParagraphBlock.new "with children" }
      let(:target) { ToggleBlock.new "A sample toggle", color: "yellow_background", sub_blocks: sub_block }

      it_behaves_like "create child block", described_class,
                      "26ed8e4e98ab81a787c2cef853157f5b", "26ed8e4e98ab811ba5ede0cc15f93696"
    end

    describe "save (update)" do
      let(:update_id) { TestConnection.update_block_id(type) }
      let(:target) { described_class.new "Old Toggle", id: update_id, color: "green_background" }

      it_behaves_like "update block rich text array", type, "New Toggle"
      it_behaves_like "update block color", type, "orange_background", true
    end
  end
end
