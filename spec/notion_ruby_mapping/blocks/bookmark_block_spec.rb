# frozen_string_literal: true

require_relative "../../spec_helper"

module NotionRubyMapping
  RSpec.describe BookmarkBlock do
    type = "bookmark"

    it_behaves_like :retrieve_block, described_class, TestConnection::BLOCK_ID_HASH[type.to_sym], false, {
      "object" => "block",
      "type" => type,
      "bookmark" => {
        "url" => "https://hkob.notion.site/",
        "caption" => [],
      },
    }

    describe "create_child_block" do
      let(:target) { described_class.new "https://www.google.com", caption: "Google" }
      it_behaves_like :create_child_block, described_class,
                      "d58295d7a7f6439ab93b143e967b0b1d", "ea528b3d18314f07b807034b5b9f0f46"
    end

    describe "save (update)" do
      let(:update_id) { TestConnection::UPDATE_BLOCK_ID_HASH[type.to_sym] }
      let(:target) { described_class.new "url", id: update_id, caption: "caption" }

      it_behaves_like :update_block_url, type, "https://www.apple.com/"
      it_behaves_like :update_block_caption, type, "Apple"
    end
  end
end
