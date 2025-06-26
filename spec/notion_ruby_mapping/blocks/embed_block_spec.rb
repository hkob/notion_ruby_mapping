# frozen_string_literal: true

require_relative "../../spec_helper"

module NotionRubyMapping
  RSpec.describe EmbedBlock do
    type = "embed"

    it_behaves_like "retrieve block", described_class, TestConnection.block_id("embed_twitter"), false, {
      "object" => "block",
      "type" => "embed",
      "embed" => {
        "url" => "https://twitter.com/hkob/status/1517825460025331712",
        "caption" => [],
      },
    }

    describe "create_child_block" do
      let(:target) do
        described_class.new "https://twitter.com/hkob/status/1507972453095833601",
                            caption: "NotionRubyMapping開発記録(21)"
      end

      it_behaves_like "create child block", described_class,
                      "bad633107cbe4fe8868ff59949e17767", "3fbbca4da79641c2bfa9c611c62b60dd"
    end

    describe "save (update)" do
      let(:update_id) { TestConnection.update_block_id(type) }
      let(:target) do
        described_class.new "https://twitter.com/hkob/status/1507972453095833601",
                            id: update_id, caption: "NotionRubyMapping開発記録(21)"
      end

      it_behaves_like "update block url", type, "https://twitter.com/hkob/status/1525470656447811586"
      it_behaves_like "update block caption", type, "NotionRubyMapping v0.4.0"
    end
  end
end
