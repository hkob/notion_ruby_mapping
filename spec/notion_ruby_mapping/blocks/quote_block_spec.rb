# frozen_string_literal: true

require_relative "../../spec_helper"

module NotionRubyMapping
  RSpec.describe QuoteBlock do
    type = "quote"

    it_behaves_like "retrieve block", described_class, TestConnection.block_id(type), true, {
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

      it_behaves_like "create child block", described_class,
                      "26ed8e4e98ab8183b580ff82123e723d", "26ed8e4e98ab81889730cc6f07d31972"
    end

    describe "save (update)" do
      let(:update_id) { TestConnection.update_block_id(type) }
      let(:target) { described_class.new "old text", id: update_id, color: "green_background" }

      it_behaves_like "update block rich text array", type, "new text"
      it_behaves_like "update block color", type, "orange_background", true
    end
  end
end
