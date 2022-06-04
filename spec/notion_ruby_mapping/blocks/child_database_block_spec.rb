# frozen_string_literal: true

require_relative "../../spec_helper"

module NotionRubyMapping
  RSpec.describe ChildDatabaseBlock do
    type = "child_database"

    it_behaves_like :retrieve_block, described_class, TestConnection::BLOCK_ID_HASH[type.to_sym], false, {
      "object" => "block",
      "type" => "child_database",
      "child_database" => {
        "title" => "Child database",
      },
    }
  end
end
