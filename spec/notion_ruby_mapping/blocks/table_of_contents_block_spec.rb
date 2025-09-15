# frozen_string_literal: true

require_relative "../../spec_helper"

module NotionRubyMapping
  RSpec.describe TableOfContentsBlock do
    type = "table_of_contents"

    it_behaves_like "retrieve block", described_class, TestConnection.block_id(type), false, {
      "object" => "block",
      "type" => "table_of_contents",
      "table_of_contents" => {
        "color" => "gray",
      },
    }

    describe "create_child_block" do
      let(:target) { described_class.new "pink" }

      it_behaves_like "create child block", described_class,
                      "26ed8e4e98ab8110b794ead92f332004", "26ed8e4e98ab8171a1e9e3e14ca0a0d1"
    end

    describe "save (update)" do
      let(:update_id) { TestConnection.update_block_id(type) }
      let(:target) { described_class.new "green_background", id: update_id }

      it_behaves_like "update block color", type, "orange_background", false
    end
  end
end
