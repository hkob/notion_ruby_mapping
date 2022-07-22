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
                      "e4bc8ce47085476da82a1e4819197255", "f2910ffa9ac647d89cb590a1ceb338ad"
    end

    describe "save (update)" do
      let(:update_id) { TestConnection::UPDATE_BLOCK_ID_HASH[type.to_sym] }
      let(:target) { described_class.new "url", id: update_id, caption: "caption" }

      it_behaves_like :update_block_url, type, "https://www.apple.com/"
      it_behaves_like :update_block_caption, type, "Apple"
    end
  end
end
