# frozen_string_literal: true

require_relative "../../spec_helper"

module NotionRubyMapping
  RSpec.describe ColumnBlock do
    type = :column

    it_behaves_like "retrieve block", described_class, TestConnection::BLOCK_ID_HASH[type.to_sym], true, {
      object: "block",
      type: "column",
      column: {},
    }
  end
end
