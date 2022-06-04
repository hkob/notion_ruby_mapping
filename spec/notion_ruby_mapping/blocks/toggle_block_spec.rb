# frozen_string_literal: true

require_relative "../../spec_helper"

module NotionRubyMapping
  RSpec.describe ToggleBlock do
    type = "toggle"

    it_behaves_like :retrieve_block, described_class, TestConnection::BLOCK_ID_HASH[type.to_sym], true, {
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
      it_behaves_like :create_child_block, described_class,
                      "7c0ea95102814379b01a5d51860b6a8b", "64bfa7fec52547b29e0ffa3c3d461c89"
    end

    describe "save (update)" do
      let(:update_id) { TestConnection::UPDATE_BLOCK_ID_HASH[type.to_sym] }
      let(:target) { described_class.new "Old Toggle", id: update_id, color: "green_background" }

      it_behaves_like :update_block_rich_text_array, type, "New Toggle"
      it_behaves_like :update_block_color, type, "orange_background", true
    end
  end
end
