# frozen_string_literal: true

require "json"
require_relative "../spec_helper"

module NotionRubyMapping
  RSpec.describe NotionCache do
    let(:nc) { NotionCache.instance }
    describe "singleton" do
      it "can get hex_id" do
        expect(nc.hex_id("0123-4567-89ab")).to eq "0123456789ab"
      end
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
  end
end
