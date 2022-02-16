# frozen_string_literal: true

require_relative "../spec_helper"

module NotionRubyMapping
  RSpec.describe Page do
    let(:config) { YAML.load_file "env.yml" }
    let!(:nc) { NotionCache.instance.create_client config["notion_token"] }

    context "For H1 block" do
      let(:h1block) { Block.find config["h1block"] }

      describe "a block" do
        it "receive id" do
          expect(h1block.id).to eq nc.hex_id(config["h1block"])
        end
      end
    end
  end
end
