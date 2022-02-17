# frozen_string_literal: true

require "yaml"
require "json"
require "notion"
require_relative "../spec_helper"

RSpec.describe NotionRubyMapping::Page do
  let(:config) { YAML.load_file "env.yml" }
  let!(:nc) { NotionRubyMapping::NotionCache.instance.create_client config["notion_token"] }
  let(:top_page) { NotionRubyMapping::Page.find config["top_page"] }

  describe "a list" do
    subject { top_page.children }

    it "count children count" do
      expect(subject.count).to eq 3
    end
  end
end
