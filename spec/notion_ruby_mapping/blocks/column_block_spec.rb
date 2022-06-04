# frozen_string_literal: true

require_relative "../../spec_helper"

module NotionRubyMapping
  RSpec.describe ColumnBlock do
    type = "column"

    it_behaves_like :retrieve_block, described_class, TestConnection::BLOCK_ID_HASH[type.to_sym], true, {
      "object" => "block",
      "type" => "column",
      "column" => {},
    }

    # describe "create_child_block" do
    #   let(:target) { described_class.new }
    #   it_behaves_like :create_child_block, described_class,
    #                   "157e2b067a06474c94e99529c0dc1ea6", "fbad10e3131d49848f4ea9f4ce8779aa"
    # end
  end
end
