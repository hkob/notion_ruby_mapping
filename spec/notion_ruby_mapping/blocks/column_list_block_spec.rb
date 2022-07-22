# frozen_string_literal: true

require_relative "../../spec_helper"

module NotionRubyMapping
  RSpec.describe ColumnListBlock do
    type = "column_list"

    it_behaves_like :retrieve_block, described_class, TestConnection::BLOCK_ID_HASH[type.to_sym], true, {
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
      it_behaves_like :create_child_block, described_class,
                      "6012c23196b64361ac6751caab8ac6e5", "a5f42a9e7d2f47dea3ab5fd431527699"
    end
  end
end
