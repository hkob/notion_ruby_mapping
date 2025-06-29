# frozen_string_literal: true

require_relative "../../spec_helper"

module NotionRubyMapping
  RSpec.describe ChildPageBlock do
    type = "child_page"
    block_id = TestConnection.block_id type
    let(:block) { Block.find block_id }

    it_behaves_like "retrieve block", described_class, block_id, false, {
      "object" => "block",
      "type" => "child_page",
      "child_page" => {
        "title" => "Child page",
      },
    }

    context "when title" do
      it { expect(block.title).to eq "Child page" }
    end
  end
end
