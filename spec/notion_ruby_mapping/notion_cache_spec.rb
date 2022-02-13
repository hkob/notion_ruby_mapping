# frozen_string_literal: true

require "json"
require "notion"
require_relative "../spec_helper"

RSpec.describe NotionRubyMapping::NotionCache do
  let(:nc) { NotionRubyMapping::NotionCache.instance }
  describe "singleton" do
    it "can set client" do
      nc.create_client("notion_token")
      expect(nc.client).not_to be_nil
    end

    it "can get hex_id" do
      expect(nc.hex_id("0123-4567-89ab")).to eq "0123456789ab"
    end
  end
end
