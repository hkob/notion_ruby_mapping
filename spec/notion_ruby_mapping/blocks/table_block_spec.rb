# frozen_string_literal: true

require_relative "../../spec_helper"

module NotionRubyMapping
  RSpec.describe TableBlock do
    type = "table"

    context "table" do
      it_behaves_like :retrieve_block, described_class, TestConnection::BLOCK_ID_HASH[type.to_sym], true, {
        "object" => "block",
        "type" => "table",
        "table" => {
          "table_width" => 2,
          "has_column_header" => true,
          "has_row_header" => true,
        },
      }
    end

    # describe "create_child_block" do
    #   let(:target) do
    #     TableBlock.new has_column_header: true, has_row_header: true, table_width: 2, table_rows: [
    #       %w[Services Account],
    #       [
    #         "Twitter",
    #         ["hkob\n", TextObject.new("profile", "href" => "https://twitter.com/hkob/")],
    #       ],
    #       [
    #         "GitHub",
    #         ["hkob\n", TextObject.new("repositories", "href" => "https://github.com/hkob/")],
    #       ],
    #     ]
    #   end
    #   it_behaves_like :create_child_block, described_class,
    #     "0f1542b8-08c4-4dc1-99ff-79835d7c4878", "bd148ec6-98bf-418a-9f31-e376f0ae51c1"
    # end
  end
end
