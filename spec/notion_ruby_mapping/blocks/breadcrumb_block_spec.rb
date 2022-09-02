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
                      "4c86e2f2acbe4fad9a906dd17d24d5e6", "f3cbb6708d084b90bf5ed3c63495247a"
    end
  end
end
