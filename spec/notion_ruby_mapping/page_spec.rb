# frozen_string_literal: true

require "yaml"
require "json"
require "notion"
require_relative "../spec_helper"

RSpec.describe NotionRubyMapping::Page do
  let(:config) { YAML.load_file "env.yml" }
  let!(:nc) { NotionRubyMapping::NotionCache.instance.create_client config["notion_token"] }

  context "For top page" do
    let(:top_page) { NotionRubyMapping::Page.find config["top_page"] }

    describe "a page" do
      it "receive id" do
        expect(top_page.id).to eq nc.hex_id(config["top_page"])
      end
    end

    describe "Retrieve block children" do
      subject { top_page.children }

      it "count children count" do
        expect(subject.count).to eq 2
      end
    end

    describe "Update icon" do
      subject { top_page.update_icon }
    end
  end

  context "Wrong page" do
    context "wrong format id" do
      subject { NotionRubyMapping::Page.find "AAA" }
      it "Can't receive page" do
        expect(subject).to be_nil
      end
    end

    context "wrong id" do
      subject { NotionRubyMapping::Page.find config["unpermitted_page"] }
      it "Can't receive page" do
        is_expected.to be_nil
      end
    end
  end
end
