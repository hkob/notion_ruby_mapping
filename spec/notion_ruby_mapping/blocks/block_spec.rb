# frozen_string_literal: true

require_relative "../../spec_helper"

module NotionRubyMapping
  RSpec.describe Page do
    tc = TestConnection.instance
    let!(:nc) { tc.nc }

    context "For H1 block" do
      let(:h1block) { Block.find TestConnection::H1_BLOCK_ID }

      describe "a block" do
        it "receive id" do
          expect(h1block.id).to eq nc.hex_id(TestConnection::H1_BLOCK_ID)
        end
      end
    end
  end
end
