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
        "page_id" => "c01166c6-13ae-45cb-b968-18b4ef2f5a77",
      },
    }

    describe "create_child_block" do
      context "link_to_page for page" do
        let(:target) do
          described_class.new page_id: TestConnection::TOP_PAGE_ID
        end
        it_behaves_like :create_child_block, described_class,
                        "4b8f1a98591648079bfc80c902472f29", "f3e70de893374d99bf0765f2688ffecf"
      end

      context "link_to_page for database" do
        let(:target) do
          described_class.new database_id: TestConnection::CREATED_DATABASE_ID
        end
        it_behaves_like :create_child_block, described_class,
                        "094da086f2ac4e309d82facfc04bf67f", "81956e6c3d93430cb10ddc2c77c9d4c8"
      end
    end
  end
end
