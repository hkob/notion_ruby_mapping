# frozen_string_literal: true

require_relative "../../spec_helper"

module NotionRubyMapping
  RSpec.describe SyncedBlock do
    # type = "synced_block"

    context "synced_block_original" do
      it_behaves_like :retrieve_block, described_class, TestConnection::BLOCK_ID_HASH[:synced_block_original], true, {
        "object" => "block",
        "type" => "synced_block",
        "synced_block" => {
          "synced_from" => nil,
        },
      }
    end

    context "synced_block_referece" do
      it_behaves_like :retrieve_block, described_class, TestConnection::BLOCK_ID_HASH[:synced_block_copy], false, {
        "object" => "block",
        "type" => "synced_block",
        "synced_block" => {
          "synced_from" => {
            "type" => "block_id",
            "block_id" => "4815032e6f2443e4bc8c9bdc6299b090",
          },
        },
      }
    end

    describe "create_child_block" do
      context "synced_block_original" do
        let(:target) do
          SyncedBlock.new sub_blocks: [
            BulletedListItemBlock.new("Synced block"),
            DividerBlock.new,
          ]
        end
        it_behaves_like :create_child_block, described_class,
                        "cffee2b0d26e473d8e01b09275c0b507", "592a5415ba26434e874f5909556b62a8"
      end
    end

    context "synced_block_reference" do
      let(:target) { SyncedBlock.new block_id: "4815032e-6f24-43e4-bc8c-9bdc6299b090" }
      it_behaves_like :create_child_block, described_class,
                      "af49674dbe70415f9fe3d605853e5a4b", "4f53a3b52f674dd6aed544fe9e9b9180"
    end

    context "synced_block_reference (url)" do
      let(:url) {
        "https://www.notion.so/hkob/Block-test-page-67cf059ce74646a0b72d481c9ff5d386#4815032e6f2443e4bc8c9bdc6299b090"
      }
      let(:target) { SyncedBlock.new block_id: url }

      it_behaves_like :create_child_block, described_class,
                      "af49674dbe70415f9fe3d605853e5a4b", "4f53a3b52f674dd6aed544fe9e9b9180"
    end
  end
end
