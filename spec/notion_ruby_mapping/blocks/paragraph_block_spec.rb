# frozen_string_literal: true

require_relative "../../spec_helper"

module NotionRubyMapping
  RSpec.describe ParagraphBlock do
    type = "paragraph"

    it_behaves_like "retrieve block", described_class, TestConnection.block_id(type), true, {
      "object" => "block",
      "type" => "paragraph",
      "paragraph" => {
        "rich_text" => [
          {
            "type" => "text",
            "text" => {
              "content" => "Text",
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
            "plain_text" => "Text",
          },
        ],
        "color" => "default",
      },
    }

    describe "create_child_block" do
      let(:sub_block) { ParagraphBlock.new "with children" }
      let(:target) { ParagraphBlock.new "A sample paragraph", color: "yellow_background", sub_blocks: sub_block }

      it_behaves_like "create child block", described_class,
                      "26ed8e4e98ab81cf8adce9ffc53b5fe9", "26ed8e4e98ab814aa03be2e5c161f81b"
    end

    describe "save (update)" do
      let(:update_id) { TestConnection.update_block_id type }
      let(:target) { described_class.new "old paragraph text", id: update_id, color: "green_background" }

      it_behaves_like "update block rich text array", type, "new paragraph text"
      it_behaves_like "update block color", type, "orange_background", true
    end
  end
end
