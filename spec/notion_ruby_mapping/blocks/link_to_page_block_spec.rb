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
                        "26ed8e4e98ab811b8c7ddec5fced2b3c", "26ed8e4e98ab815d9a78dfc66f60f888"
      end

      context "link_to_page for page (url)" do
        let(:target) do
          described_class.new page_id: TestConnection::TOP_PAGE_URL
        end

        it_behaves_like "create child block", described_class,
                        "26ed8e4e98ab811b8c7ddec5fced2b3c", "26ed8e4e98ab815d9a78dfc66f60f888"
      end

      context "link_to_page for database" do
        let(:target) do
          described_class.new database_id: TestConnection::CREATED_DATABASE_ID
        end

        it_behaves_like "create child block", described_class,
                        "26ed8e4e98ab8108beb5e6326b7ba2e3", "26ed8e4e98ab81a9bdf6f36e6b1dfe9c"
      end

      context "link_to_page for database (url)" do
        let(:target) do
          described_class.new database_id: TestConnection::CREATED_DATABASE_URL
        end

        it_behaves_like "create child block", described_class,
                        "26ed8e4e98ab8108beb5e6326b7ba2e3", "26ed8e4e98ab81a9bdf6f36e6b1dfe9c"
      end
    end
  end
end
