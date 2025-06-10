# frozen_string_literal: true

require_relative "../../spec_helper"

module NotionRubyMapping
  RSpec.describe ChildDatabaseBlock do
    type = :child_database
    block_id = TestConnection::BLOCK_ID_HASH[type.to_sym]

    it_behaves_like "retrieve block", described_class, block_id, false, {
      object: "block",
      type: "child_database",
      child_database: {
        title: "Child database",
      },
    }

    context "when title" do
      let(:block) { Block.find block_id }

      it { expect(block.title).to eq "Child database" }
    end
  end
end
