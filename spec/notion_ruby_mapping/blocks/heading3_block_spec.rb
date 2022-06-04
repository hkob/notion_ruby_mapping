# frozen_string_literal: true

require_relative "../../spec_helper"

module NotionRubyMapping
  RSpec.describe Heading3Block do
    type = "heading_3"

    it_behaves_like :retrieve_block, described_class, TestConnection::BLOCK_ID_HASH[type.to_sym], false, {
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
      },
    }

    describe "create_child_block" do
      let(:sub_block) { ParagraphBlock.new "with children" }
      let(:target) { described_class.new "Heading 3", color: "gray_background" }
      it_behaves_like :create_child_block, described_class,
                      "fbca4d2b8cb4410497f1f461a79e006b", "ee1b1100a9754050abe26b2407e4eb19"
    end

    describe "save (update)" do
      let(:update_id) { TestConnection::UPDATE_BLOCK_ID_HASH[type.to_sym] }
      let(:target) { described_class.new "Heading 3", color: "blue_background", id: update_id }

      it_behaves_like :update_block_rich_text_array, type, "New Heading 3"
      it_behaves_like :update_block_color, type, "green_background", true
    end
  end
end
