# frozen_string_literal: true

require_relative "../../spec_helper"

module NotionRubyMapping
  RSpec.describe TableBlock do
    type = :table

    context "when table" do
      it_behaves_like "retrieve block", described_class, TestConnection::BLOCK_ID_HASH[type.to_sym], true, {
        object: "block",
        type: "table",
        table: {
          table_width: 2,
          has_column_header: true,
          has_row_header: true,
        },
      }
    end
  end
end
