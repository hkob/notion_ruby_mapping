# frozen_string_literal: true

require_relative "../../spec_helper"

module NotionRubyMapping
  RSpec.describe Heading3Block do
    type = "heading_3"

    it_behaves_like "retrieve block", described_class, TestConnection.block_id(type), false, {
      "object" => "block",
      "type" => "heading_3",
      "heading_3" => {
        "rich_text" => [
          {
            "type" => "text",
            "text" => {
              "content" => "Heading 3",
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
            "plain_text" => "Heading 3",
            "href" => nil,
          },
        ],
        "color" => "default",
        "is_toggleable" => false,
      },
    }

    describe "create_child_block" do
      let(:sub_block) { ParagraphBlock.new "with children" }
      let(:target) { described_class.new "Heading 3", color: "gray_background" }

      it_behaves_like "create child block", described_class,
                      "0f2dcc71a7bf4c6ea3ee2547684240cb", "5d4cca637cbc451c8d600ca9b8adf2e8"
    end

    describe "save (update)" do
      let(:update_id) { TestConnection.update_block_id(type) }
      let(:target) { described_class.new "Heading 3", color: "blue_background", id: update_id }

      it_behaves_like "update block rich text array", type, "New Heading 3"
      it_behaves_like "update block color", type, "green_background", true
    end
  end
end
