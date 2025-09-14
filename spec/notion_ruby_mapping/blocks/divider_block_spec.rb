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
                      "26dd8e4e98ab81e2b8bad056d5cc3656", "26dd8e4e98ab819ebf5cc62f737acd77"
    end
  end
end
