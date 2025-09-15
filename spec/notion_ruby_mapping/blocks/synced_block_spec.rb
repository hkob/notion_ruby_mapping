# frozen_string_literal: true

require_relative "../../spec_helper"

module NotionRubyMapping
  RSpec.describe SyncedBlock do
    # type = "synced_block"

    context "when synced_block_original" do
      it_behaves_like "retrieve block", described_class, TestConnection.block_id("synced_block_original"), true, {
        "object" => "block",
        "type" => "synced_block",
        "synced_block" => {
          "synced_from" => nil,
        },
      }
    end

    context "when synced_block_referece" do
      it_behaves_like "retrieve block", described_class, TestConnection.block_id("synced_block_copy"), false, {
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
      context "when synced_block_original" do
        let(:target) do
          SyncedBlock.new sub_blocks: [
            BulletedListItemBlock.new("Synced block"),
            DividerBlock.new,
          ]
        end

        it_behaves_like "create child block", described_class,
                        "26ed8e4e98ab8106be91ca502bc63008", "26ed8e4e98ab81b2b8bae83e9ff1ed59"
      end
    end

    context "synced_block_reference" do
      let(:target) { SyncedBlock.new block_id: "4815032e-6f24-43e4-bc8c-9bdc6299b090" }

      it_behaves_like "create child block", described_class,
                      "26ed8e4e98ab81458efbdd137f53f294", "26ed8e4e98ab81398104e772d926f915"
    end

    context "synced_block_reference (url)" do
      let(:url) do
        "https://www.notion.so/hkob/Block-test-page-67cf059ce74646a0b72d481c9ff5d386#4815032e6f2443e4bc8c9bdc6299b090"
      end
      let(:target) { SyncedBlock.new block_id: url }

      it_behaves_like "create child block", described_class,
                      "26ed8e4e98ab81458efbdd137f53f294", "26ed8e4e98ab81398104e772d926f915"
    end
  end
end
