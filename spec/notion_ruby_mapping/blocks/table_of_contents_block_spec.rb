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
                      "8f1d1f22790b49bc99a1a5a9093e23c0", "9499a95ce62e4a31a6ed62f370951ffc"
    end

    describe "save (update)" do
      let(:update_id) { TestConnection::UPDATE_BLOCK_ID_HASH[type.to_sym] }
      let(:target) { described_class.new "green_background", id: update_id }
      it_behaves_like :update_block_color, type, "orange_background", false
    end
  end
end
