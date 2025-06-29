# frozen_string_literal: true

require_relative "../../spec_helper"

module NotionRubyMapping
  RSpec.describe DividerBlock do
    type = "divider"

    it_behaves_like "retrieve block", described_class, TestConnection.block_id(type), false, {
      "object" => "block",
      "type" => "divider",
      "divider" => {},
    }

    describe "create_child_block" do
      let(:target) { described_class.new }

      it_behaves_like "create child block", described_class,
                      "b493b0522d2a4c5f82df40fc1c2ebbca", "d1c01e29873343bfad6ef4df4dea45bc"
    end
  end
end
