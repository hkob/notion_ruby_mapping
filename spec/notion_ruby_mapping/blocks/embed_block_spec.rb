# frozen_string_literal: true

require_relative "../../spec_helper"

module NotionRubyMapping
  RSpec.describe EmbedBlock do
    type = "embed"

    it_behaves_like :retrieve_block, described_class, TestConnection::BLOCK_ID_HASH[:embed_twitter], false, {
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
      it_behaves_like :create_child_block, described_class,
                      "65de2ce6b95d426a8c5db4d673a0e236", "4575a8ad994545bd80451607eaa56599"
    end

    describe "save (update)" do
      let(:update_id) { TestConnection::UPDATE_BLOCK_ID_HASH[type.to_sym] }
      let(:target) do
        described_class.new "https://twitter.com/hkob/status/1507972453095833601",
                            id: update_id, caption: "NotionRubyMapping開発記録(21)"
      end
      it_behaves_like :update_block_url, type, "https://twitter.com/hkob/status/1525470656447811586"
      it_behaves_like :update_block_caption, type, "NotionRubyMapping v0.4.0"
    end
  end
end
