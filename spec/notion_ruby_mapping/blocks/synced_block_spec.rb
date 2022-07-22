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
                        "3e233ded2ad84cf4b1275409e5bc9cb5", "c471e88f01b347bebab4c30eb6b09cc2"
      end
    end

    context "synced_block_reference" do
      let(:target) { SyncedBlock.new block_id: "4815032e-6f24-43e4-bc8c-9bdc6299b090" }
      it_behaves_like :create_child_block, described_class,
                      "5fbed0c64273474b8124e66fedfad64d", "bb7ced572c8e4b38b6fbaa0f27c32d43"
    end
  end
end
