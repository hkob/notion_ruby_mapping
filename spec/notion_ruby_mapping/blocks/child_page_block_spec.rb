# frozen_string_literal: true

require_relative "../../spec_helper"

module NotionRubyMapping
  RSpec.describe ChildPageBlock do
    type = "child_page"

    it_behaves_like :retrieve_block, described_class, TestConnection::BLOCK_ID_HASH[type.to_sym], false, {
      "object" => "block",
      "type" => "child_page",
      "child_page" => {
        "title" => "Child page",
      },
    }
  end
end
