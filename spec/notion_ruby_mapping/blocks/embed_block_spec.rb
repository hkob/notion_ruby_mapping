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
                      "eca4b3fb6ef84ca88ff79311ca775009", "1ff6be7e4997455ca88ce41646ec7440"
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
