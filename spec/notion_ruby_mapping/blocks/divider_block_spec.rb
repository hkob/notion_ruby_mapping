# frozen_string_literal: true

require_relative "../../spec_helper"

module NotionRubyMapping
  RSpec.describe DividerBlock do
    type = "divider"

    it_behaves_like :retrieve_block, described_class, TestConnection::BLOCK_ID_HASH[type.to_sym], false, {
      "object" => "block",
      "type" => "divider",
      "divider" => {},
    }

    describe "create_child_block" do
      let(:target) { p described_class.new }
      it_behaves_like :create_child_block, described_class,
                      "f7392c519a1248909e3db8447f21750f", "ade41d26091643608e493649b52d0bd1"
    end
  end
end
