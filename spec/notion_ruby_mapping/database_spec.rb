# frozen_string_literal: true

require "yaml"
require_relative "../spec_helper"
READ_FROM_FILE = true

module NotionRubyMapping
  RSpec.describe Database do
    let(:config) { YAML.load_file "env.yml" }
    let!(:nc) { NotionCache.instance.create_client config["notion_token"] }
    let(:database) { Database.find config["database"] }

    describe "a database" do
      it "receive id" do
        expect(database.id).to eq nc.hex_id(config["database"])
      end
    end

    describe "query" do
      subject { Database.query(config["database"], query) }
      context "no filter, no sort" do
        let(:query) { nil }
        it "count page count" do
          expect(subject.count).to eq 3
        end
      end

      context "text filter, ascending title" do
        let(:query) { TitleProperty.new("Title").filter_starts_with("A") }
        it "count page count" do
          expect(subject.count).to eq 1
        end
      end
    end
  end
end
