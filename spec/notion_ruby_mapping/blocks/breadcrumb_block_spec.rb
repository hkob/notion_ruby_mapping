# frozen_string_literal: true

require_relative "../../spec_helper"

module NotionRubyMapping
  RSpec.describe BreadcrumbBlock do
    type = "breadcrumb"

    it_behaves_like :retrieve_block, described_class, TestConnection::BLOCK_ID_HASH[type.to_sym], false, {
      "object" => "block",
      "type" => type,
      type => {},
    }

    describe "create_child_block" do
      let(:target) { described_class.new }
      it_behaves_like :create_child_block, described_class,
                      "a1903ccce15c409ba31ce4259abdbb9b", "cd9c43aa87e04437907e3fd48efd00c0"
    end
  end
end
