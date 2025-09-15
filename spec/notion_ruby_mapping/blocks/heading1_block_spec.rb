# frozen_string_literal: true

require_relative "../../spec_helper"

module NotionRubyMapping
  RSpec.describe Heading1Block do
    type = "heading_1"

    it_behaves_like "retrieve block", described_class, TestConnection.block_id(type), false, {
      "object" => "block",
      "type" => "heading_1",
      "heading_1" => {
        "rich_text" => [
          {
            "type" => "text",
            "text" => {
              "content" => "Heading 1",
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
            "plain_text" => "Heading 1",
            "href" => nil,
          },
        ],
        "color" => "default",
        "is_toggleable" => false,
      },
    }

    describe "create_child_block" do
      let(:sub_block) { ParagraphBlock.new "with children" }
      let(:target) { described_class.new "Heading 1", color: "orange_background" }

      it_behaves_like "create child block", described_class,
                      "26dd8e4e98ab8185baa9cfc61562d981", "26dd8e4e98ab81b09bfbe501b3b42dbe"
    end

    describe "save (update)" do
      let(:update_id) { TestConnection.update_block_id(type) }
      let(:target) { described_class.new "Heading 1", color: "orange_background", id: update_id }

      it_behaves_like "update block rich text array", type, "New Heading 1"
      it_behaves_like "update block color", type, "green_background", true
    end
  end
end
