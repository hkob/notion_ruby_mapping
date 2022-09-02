# frozen_string_literal: true

require_relative "../../spec_helper"

module NotionRubyMapping
  RSpec.describe QuoteBlock do
    type = "quote"

    it_behaves_like :retrieve_block, described_class, TestConnection::BLOCK_ID_HASH[type.to_sym], true, {
      "object" => "block",
      "type" => "quote",
      "quote" => {
        "rich_text" => [
          {
            "type" => "text",
            "text" => {
              "content" => "Quote",
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
            "plain_text" => "Quote",
            "href" => nil,
          },
        ],
        "color" => "default",
      },
    }

    describe "create_child_block" do
      let(:sub_block) { ParagraphBlock.new "with children" }
      let(:target) { QuoteBlock.new "A sample quote", color: "purple", sub_blocks: sub_block }
      it_behaves_like :create_child_block, described_class,
                      "a443a7f6a8f34d4880034363ca04381d", "4451e0f902ee4b888e9667761f5a52b2"
    end

    describe "save (update)" do
      let(:update_id) { TestConnection::UPDATE_BLOCK_ID_HASH[type.to_sym] }
      let(:target) { described_class.new "old text", id: update_id, color: "green_background" }

      it_behaves_like :update_block_rich_text_array, type, "new text"
      it_behaves_like :update_block_color, type, "orange_background", true
    end
  end
end
