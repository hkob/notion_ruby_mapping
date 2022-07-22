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
                      "cb7e1bc11a3c40ca87c1cfe31a85fb5b", "9b1157ec6b0247ba8c97c4cc96ee2ea0"
    end
  end
end
