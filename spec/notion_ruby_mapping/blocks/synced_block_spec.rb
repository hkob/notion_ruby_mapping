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
                        "3ece4c8fb02b4da5a1e18803d6c088e9", "a2a14594e2a24ea0bcc6067f0b0a3a97"
      end
    end

    context "synced_block_reference" do
      let(:target) { SyncedBlock.new block_id: "4815032e-6f24-43e4-bc8c-9bdc6299b090" }
      it_behaves_like :create_child_block, described_class,
                      "51431432c91e4a45a951d12cf53bb0e8", "a8a432be8a3d4fb8b67afefb7ed98c66"
    end
  end
end
