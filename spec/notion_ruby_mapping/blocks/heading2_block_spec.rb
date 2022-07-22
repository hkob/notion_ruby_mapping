# frozen_string_literal: true

require_relative "../../spec_helper"

module NotionRubyMapping
  RSpec.describe Heading2Block do
    type = "heading_2"

    it_behaves_like :retrieve_block, described_class, TestConnection::BLOCK_ID_HASH[type.to_sym], false, {
      "object" => "block",
      "type" => "heading_2",
      "heading_2" => {
        "rich_text" => [
          {
            "type" => "text",
            "text" => {
              "content" => "Heading 2",
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
            "plain_text" => "Heading 2",
            "href" => nil,
          },
        ],
        "color" => "default",
      },
    }

    describe "create_child_block" do
      let(:sub_block) { ParagraphBlock.new "with children" }
      let(:target) { described_class.new "Heading 2", color: "blue_background" }
      it_behaves_like :create_child_block, described_class,
                      "1316d6f5ca1a49e398cfa47add6fdc3a", "680b55f830424d3aba3f8c28646ccb13"
    end

    describe "save (update)" do
      let(:update_id) { TestConnection::UPDATE_BLOCK_ID_HASH[type.to_sym] }
      let(:target) { described_class.new "Heading 2", color: "blue_background", id: update_id }

      it_behaves_like :update_block_rich_text_array, type, "New Heading 2"
      it_behaves_like :update_block_color, type, "green_background", true
    end
  end
end
