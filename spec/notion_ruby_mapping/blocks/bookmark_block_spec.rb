# frozen_string_literal: true

require_relative "../../spec_helper"

module NotionRubyMapping
  RSpec.describe BookmarkBlock do
    type = "bookmark"

    it_behaves_like "retrieve block", described_class, TestConnection.block_id(type), false, {
      "object" => "block",
      "type" => "bookmark",
      "bookmark" => {
        "url" => "https://hkob.notion.site/",
        "caption" => [],
      },
    }

    describe "create_child_block" do
      let(:target) { described_class.new "https://www.google.com", caption: "Google" }

      it_behaves_like "create child block", described_class,
                      "26cd8e4e98ab81c086c2cc723840e075", "26cd8e4e98ab81749758ed9124b7eef0"
    end

    describe "save (update)" do
      let(:update_id) { TestConnection.update_block_id(type) }
      let(:target) { described_class.new "url", id: update_id, caption: "caption" }

      it_behaves_like "update block url", type, "https://www.apple.com/"
      it_behaves_like "update block caption", type, "Apple"
    end
  end
end
