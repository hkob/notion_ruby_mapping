# frozen_string_literal: true

require_relative "../../spec_helper"

module NotionRubyMapping
  RSpec.describe LinkToPageBlock do
    type = "link_to_page"

    it_behaves_like :retrieve_block, described_class, TestConnection::BLOCK_ID_HASH[type.to_sym], false, {
      "object" => "block",
      "type" => "link_to_page",
      "link_to_page" => {
        "type" => "page_id",
        "page_id" => "c01166c613ae45cbb96818b4ef2f5a77",
      },
    }

    describe "create_child_block" do
      context "link_to_page for page" do
        let(:target) do
          described_class.new page_id: TestConnection::TOP_PAGE_ID
        end
        it_behaves_like :create_child_block, described_class,
                        "b55e143604f74b118f04b50831eeed15", "2e802947b5f34003ae7b4e8c7ee6205f"
      end

      context "link_to_page for page (url)" do
        let(:target) do
          described_class.new page_id: TestConnection::TOP_PAGE_URL
        end
        it_behaves_like :create_child_block, described_class,
                        "b55e143604f74b118f04b50831eeed15", "2e802947b5f34003ae7b4e8c7ee6205f"
      end

      context "link_to_page for database" do
        let(:target) do
          described_class.new database_id: TestConnection::CREATED_DATABASE_ID
        end
        it_behaves_like :create_child_block, described_class,
                        "e989f5928c7344059ec035304380be24", "669c622118c04bf4b09ba85eefb2b958"
      end

      context "link_to_page for database (url)" do
        let(:target) do
          described_class.new database_id: TestConnection::CREATED_DATABASE_URL
        end
        it_behaves_like :create_child_block, described_class,
                        "e989f5928c7344059ec035304380be24", "669c622118c04bf4b09ba85eefb2b958"
      end
    end
  end
end
