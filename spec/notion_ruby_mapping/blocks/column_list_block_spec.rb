# frozen_string_literal: true

require_relative "../../spec_helper"

module NotionRubyMapping
  RSpec.describe ColumnListBlock do
    type = "column_list"

    it_behaves_like "retrieve block", described_class, TestConnection.block_id(type), true, {
      "object" => "block",
      "type" => "column_list",
      "column_list" => {},
    }

    describe "create_child_block" do
      let(:target) do
        described_class.new [
          CalloutBlock.new("Emoji callout", emoji: "✅"),
          CalloutBlock.new("Url callout", file_url: "https://img.icons8.com/ios-filled/250/000000/mac-os.png"),
        ]
      end

      it_behaves_like "create child block", described_class,
                      "26dd8e4e98ab8126b100f9c7260420af", "26dd8e4e98ab815589e1c0b09dc47c21"
    end
  end
end
