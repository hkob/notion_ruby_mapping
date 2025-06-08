# frozen_string_literal: true

require_relative "../../spec_helper"

module NotionRubyMapping
  RSpec.describe Heading2Block do
    type = :heading_2

    it_behaves_like "retrieve block", described_class, TestConnection::BLOCK_ID_HASH[type.to_sym], false, {
      object: "block",
      type: "heading_2",
      heading_2: {
        rich_text: [
          {
            type: "text",
            text: {
              content: "Heading 2",
              link: nil,
            },
            annotations: {
              bold: false,
              italic: false,
              strikethrough: false,
              underline: false,
              code: false,
              color: "default",
            },
            plain_text: "Heading 2",
            href: nil,
          },
        ],
        color: "default",
        is_toggleable: false,
      },
    }

    describe "create_child_block" do
      let(:sub_block) { ParagraphBlock.new "with children" }
      let(:target) { described_class.new "Heading 2", color: "blue_background" }

      it_behaves_like "create child block", described_class,
                      "9714d6719fe3418d88b1212ee7d45d58", "1fbe34f38da7494097db5f4800d7240e"
    end

    describe "save (update)" do
      let(:update_id) { TestConnection::UPDATE_BLOCK_ID_HASH[type.to_sym] }
      let(:target) { described_class.new "Heading 2", color: "blue_background", id: update_id }

      it_behaves_like "update block rich text array", type, "New Heading 2"
      it_behaves_like "update block color", type, "green_background", true
    end
  end
end
