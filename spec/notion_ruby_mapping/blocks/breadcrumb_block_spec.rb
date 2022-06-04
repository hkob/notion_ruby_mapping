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
                      "e74432d1f10e497f982788d21ab1bccd", "80e7a685230d458f86072cf5187c5132"
    end
  end
end
