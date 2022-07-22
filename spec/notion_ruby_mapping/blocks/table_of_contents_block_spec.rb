# frozen_string_literal: true

require_relative "../../spec_helper"

module NotionRubyMapping
  RSpec.describe TableOfContentsBlock do
    type = "table_of_contents"

    it_behaves_like :retrieve_block, described_class, TestConnection::BLOCK_ID_HASH[type.to_sym], false, {
      "object" => "block",
      "type" => "table_of_contents",
      "table_of_contents" => {
        "color" => "gray",
      },
    }

    describe "create_child_block" do
      let(:target) { described_class.new "pink" }
      it_behaves_like :create_child_block, described_class,
                      "7abcb4bd3b8d4b27a1ebb045ea207eb0", "b5892610e94e496fa79e26f3ba09bf61"
    end

    describe "save (update)" do
      let(:update_id) { TestConnection::UPDATE_BLOCK_ID_HASH[type.to_sym] }
      let(:target) { described_class.new "green_background", id: update_id }
      it_behaves_like :update_block_color, type, "orange_background", false
    end
  end
end
