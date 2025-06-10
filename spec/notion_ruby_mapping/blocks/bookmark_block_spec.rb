# frozen_string_literal: true

require_relative "../../spec_helper"

module NotionRubyMapping
  RSpec.describe BookmarkBlock do
    type = :bookmark

    it_behaves_like "retrieve block", described_class, TestConnection::BLOCK_ID_HASH[type.to_sym], false, {
      object: "block",
      type: "bookmark",
      bookmark: {
        url: "https://hkob.notion.site/",
        caption: [],
      },
    }

    describe "create_child_block" do
      let(:target) { described_class.new "https://www.google.com", caption: "Google" }

      it_behaves_like "create child block", described_class,
                      "06cabb90d4b74152b8c20b8944f48efc", "e03e349f03604acab4d6de579a6138c5"
    end

    describe "save (update)" do
      let(:update_id) { TestConnection::UPDATE_BLOCK_ID_HASH[type.to_sym] }
      let(:target) { described_class.new "url", id: update_id, caption: "caption" }

      it_behaves_like "update block url", type, "https://www.apple.com/"
      it_behaves_like "update block caption", type, "Apple"
    end
  end
end
