# frozen_string_literal: true

require_relative "../../spec_helper"

module NotionRubyMapping
  RSpec.describe LinkToPageBlock do
    type = "link_to_page"

    it_behaves_like "retrieve block", described_class, TestConnection.block_id(type), false, {
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

        it_behaves_like "create child block", described_class,
                        "943c521713ce408481d2bdc6c4f5fe38", "f6489b0b85234c1793946d996b2cb9f3"
      end

      context "link_to_page for page (url)" do
        let(:target) do
          described_class.new page_id: TestConnection::TOP_PAGE_URL
        end

        it_behaves_like "create child block", described_class,
                        "943c521713ce408481d2bdc6c4f5fe38", "f6489b0b85234c1793946d996b2cb9f3"
      end

      context "link_to_page for database" do
        let(:target) do
          described_class.new database_id: TestConnection::CREATED_DATABASE_ID
        end

        it_behaves_like "create child block", described_class,
                        "2dfb62446fa844b9aaa085e74389a7d8", "7b1a7fe42fd945b18efab54330533d8b"
      end

      context "link_to_page for database (url)" do
        let(:target) do
          described_class.new database_id: TestConnection::CREATED_DATABASE_URL
        end

        it_behaves_like "create child block", described_class,
                        "2dfb62446fa844b9aaa085e74389a7d8", "7b1a7fe42fd945b18efab54330533d8b"
      end
    end
  end
end
