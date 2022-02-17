# frozen_string_literal: true

require_relative "../spec_helper"

module NotionRubyMapping
  RSpec.describe Page do
    let(:config) { YAML.load_file "env.yml" }
    let!(:nc) { NotionCache.instance.create_client config["notion_token"] }

    describe "find" do
      context "For an existing top page" do
        let(:top_page) { Page.find config["top_page"] }

        it "receive id" do
          expect(top_page.id).to eq nc.hex_id(config["top_page"])
        end
      end

      context "Wrong page" do
        context "wrong format id" do
          subject { Page.find "AAA" }
          it "Can't receive page" do
            expect(subject).to be_nil
          end
        end

        context "wrong id" do
          subject { Page.find config["unpermitted_page"] }
          it "Can't receive page" do
            is_expected.to be_nil
          end
        end
      end
    end

    describe "update_icon" do
      let(:top_page) { Page.new id: config["top_page"] }
      before { top_page.set_icon(**params) }
      subject { top_page.icon }

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

    describe "update" do
      subject { page.update.properties["NumberTitle"].create_json }
      context "Unloaded page" do
        let(:page) { Page.new id: config["first_page"] }
        it "update NumberProperty by add_property" do
          np = NumberProperty.new "NumberTitle", number: 3.14
          page.add_property_for_update np
          is_expected.to eq({"number" => 3.14, "type" => "number"})
        end

        it "update NumberProperty by substitution" do
          page.properties["NumberTitle"].number = 1.41421356
          is_expected.to eq({"number" => 1.41421356, "type" => "number"})
        end
      end

      context "loaded page" do
        let(:page) { Page.find config["first_page"] }
        let(:np) { page.properties["NumberTitle"] }
        it "update NumberProperty by substitution" do
          np.number = 2022
          page.update
          is_expected.to eq({"number" => 2022, "type" => "number"})
        end
      end
    end
  end
end
