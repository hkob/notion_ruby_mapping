# frozen_string_literal: true

require_relative "../../spec_helper"

module NotionRubyMapping
  RSpec.describe Heading4Block do
    type = "heading_4"

    it_behaves_like "retrieve block", described_class, TestConnection.block_id(type), false, {
      "object" => "block",
      "type" => "heading_4",
      "heading_4" => {
        "rich_text" => [
          {
            "type" => "text",
            "text" => {
              "content" => "Heading 4",
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
            "plain_text" => "Heading 4",
            "href" => nil,
          },
        ],
        "color" => "default",
        "is_toggleable" => false,
      },
    }

    describe "create_child_block" do
      let(:sub_block) { ParagraphBlock.new "with children" }
      let(:target) { described_class.new "Heading 4", color: "yellow_background" }

      it_behaves_like "create child block", described_class,
                      "32ad8e4e98ab810b9039c3cdaf566c42", "32ad8e4e98ab8150a545dd6fa02c14dd"
    end

    describe "save (update)" do
      let(:update_id) { TestConnection.update_block_id(type) }
      let(:target) { described_class.new "Heading 4", color: "blue_background", id: update_id }

      it_behaves_like "update block rich text array", type, "New Heading 4"
      it_behaves_like "update block color", type, "green_background", true
    end
  end
end
