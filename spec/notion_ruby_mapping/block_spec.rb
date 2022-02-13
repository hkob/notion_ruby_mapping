# frozen_string_literal: true

require "yaml"
require "json"
require "notion"
require_relative "../spec_helper"

RSpec.describe NotionRubyMapping::Page do
  let(:config) { YAML.load_file "env.yml" }
  let!(:nc) { NotionRubyMapping::NotionCache.instance.create_client config["notion_token"] }

  context "For H1 block" do
    let(:h1block) { NotionRubyMapping::Block.find config["h1block"] }

    describe "a block" do
      it "receive id" do
        expect(h1block.id).to eq nc.hex_id(config["h1block"])
      end
    end
  end
end
