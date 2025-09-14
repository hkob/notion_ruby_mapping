# frozen_string_literal: true

require_relative "../../spec_helper"

module NotionRubyMapping
  RSpec.describe ColumnBlock do
    type = "column"

    it_behaves_like "retrieve block", described_class, TestConnection.block_id(type), true, {
      "object" => "block",
      "type" => "column",
      "column" => {"width_ratio" => 0.33333333333333337},
    }
  end
end
