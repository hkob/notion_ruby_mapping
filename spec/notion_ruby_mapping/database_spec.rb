# frozen_string_literal: true

require "yaml"
require_relative "../spec_helper"
READ_FROM_FILE = true

module NotionRubyMapping
  RSpec.describe Database do
    let(:config) { YAML.load_file "env.yml" }
    let!(:nc) { NotionCache.instance.create_client config["notion_token"] }

    describe "a database" do
      let(:database) { Database.find config["database"] }

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

    describe "update_icon" do
      let(:database) { Database.new id: config["database"] }
      before { database.set_icon(**params) }
      subject { database.icon }

      context "for emoji icon" do
        let(:params) { {emoji: "😀"} }
        it "update icon (emoji)" do
          is_expected.to eq({"type" => "emoji", "emoji" => "😀"})
        end
      end

      context "for link icon" do
        let(:url) { "https://cdn.profile-image.st-hatena.com/users/hkob/profile.png" }
        let(:params) { {url: url } }
        it "update icon (link)" do
          is_expected.to eq({"type" => "external", "external" => {"url" => url}})
        end
      end
    end
  end
end
