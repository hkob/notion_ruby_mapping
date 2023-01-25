# frozen_string_literal: true

require "json"
require_relative "../../spec_helper"

module NotionRubyMapping
  RSpec.describe NotionCache do
    let(:nc) { NotionCache.instance }
    describe "singleton" do
      it "can get hex_id" do
        expect(nc.hex_id("0123-4567-89ab")).to eq "0123456789ab"
      end
    end

    describe "NotionRubyMapping.configure" do
      it "can set notion_token" do
        save_token = nc.notion_token
        expect(nc.notion_token).not_to eq "ABC"
        NotionRubyMapping.configure { |c| c.notion_token = "ABC" }
        expect(nc.notion_token).to eq "ABC"
        # restore original
        NotionRubyMapping.configure { |c| c.notion_token = save_token }
      end

      it "can set wait" do
        expect(nc.wait).to eq 0
        NotionRubyMapping.configure { |c| c.wait = 0.3333 }
        expect(nc.wait).to eq 0.3333
        # restore original
        NotionRubyMapping.configure { |c| c.wait = 0 }
      end

      it "can set debug" do
        expect(nc.debug).to be_falsey
        NotionRubyMapping.configure { |c| c.debug = true }
        expect(nc.debug).to be_truthy
        # restore original
        NotionRubyMapping.configure { |c| c.debug = false }
      end
    end

    describe "append_block_children_block_path" do
      it { expect(nc.append_block_children_block_path("ABC")).to eq "v1/blocks/ABC/children" }
    end

    describe "append_block_children_page_path" do
      it { expect(nc.append_block_children_page_path("ABC")).to eq "v1/blocks/ABC/children" }
    end

    describe "page_path" do
      it { expect(nc.page_path("ABC")).to eq "v1/pages/ABC" }
    end

    describe "database_path" do
      it { expect(nc.database_path("ABC")).to eq "v1/databases/ABC" }
    end

    describe "databases_path" do
      it { expect(nc.databases_path).to eq "v1/databases" }
    end

    describe "block_children_page_path" do
      it { expect(nc.block_children_page_path("ABC")).to eq "v1/blocks/ABC/children" }
      it { expect(nc.block_children_page_path("ABC", "?page_size=100")).to eq "v1/blocks/ABC/children?page_size=100" }
    end

    describe "page_property_path" do
      it { expect(nc.page_property_path("ABC", "DEF")).to eq "v1/pages/ABC/properties/DEF" }
    end

    describe "user_path" do
      it { expect(nc.user_path("ABC")).to eq "v1/users/ABC" }
    end

    describe "search_path" do
      it { expect(nc.search_path).to eq "v1/search" }
    end
  end
end
