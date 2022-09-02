# frozen_string_literal: true

require_relative "../../spec_helper"

module NotionRubyMapping
  RSpec.describe CalloutBlock do
    type = "callout"

    it_behaves_like :retrieve_block, described_class, TestConnection::BLOCK_ID_HASH[type.to_sym], true, {
      "object" => "block",
      "type" => "callout",
      "callout" => {
        "rich_text" => [
          {
            "type" => "text",
            "text" => {
              "content" => "Callout",
              "link" => nil,
            },
            "annotations" => {
              "bold" => false,
              "code" => false,
              "color" => "default",
              "italic" => false,
              "strikethrough" => false,
              "underline" => false,
            },
            "href" => nil,
            "plain_text" => "Callout",
          },
        ],
        "color" => "gray_background",
      },
    }

    describe "create_child_block" do
      context "callout_emoji" do
        let(:sub_block) { ParagraphBlock.new "with children" }
        let(:target) { described_class.new "Emoji callout", emoji: "✅", color: "blue", sub_blocks: sub_block }
        it_behaves_like :create_child_block, described_class,
                        "f0585d1274fc45e784697d675ef54d3f", "dbf81dfcd4fa4c459a16476efd4cc5ec"
      end

      context "callout url" do
        let(:sub_block) { ParagraphBlock.new "with children" }
        let(:target) do
          described_class.new "Url callout", file_url: "https://img.icons8.com/ios-filled/250/000000/mac-os.png",
                                             sub_blocks: sub_block
        end
        it_behaves_like :create_child_block, described_class,
                        "dbafbbdc77064057a3a5ee3c25fb63ae", "b4e37e50928e490a943a401712d5d3ea"
      end
    end

    describe "save (update)" do
      let(:update_id) { TestConnection::UPDATE_BLOCK_ID_HASH[type.to_sym] }
      let(:target) { described_class.new "old text", id: update_id, color: "green_background" }

      it_behaves_like :update_block_rich_text_array, type, "new text"
      it_behaves_like :update_block_color, type, "orange_background"

      context "file_url" do
        let(:file_url) { "https://img.icons8.com/ios-filled/250/000000/mac-os.png" }
        before { target.file_url = file_url }
        let(:json) do
          {
            "callout" => {
              "icon" => {
                "type" => "external",
                "external" => {
                  "url" => file_url,
                },
              },
            },
          }
        end
        it { expect(target.update_block_json).to eq json }
        context "dry_run" do
          let(:dry_run) { target.save dry_run: true }
          it_behaves_like :dry_run, :patch, :block_path, use_id: true, json_method: :update_block_json
        end

        context "save" do
          it { expect(target.save.file_url).to eq file_url }
        end
      end

      context "emoji" do
        let(:emoji) { "💡" }
        before { target.emoji = emoji }
        let(:json) do
          {
            "callout" => {
              "icon" => {
                "type" => "emoji",
                "emoji" => "💡",
              },
            },
          }
        end
        it { expect(target.update_block_json).to eq json }
        context "dry_run" do
          let(:dry_run) { target.save dry_run: true }
          it_behaves_like :dry_run, :patch, :block_path, use_id: true, json_method: :update_block_json
        end

        context "save" do
          it { expect(target.save.emoji).to eq emoji }
        end
      end
    end
  end
end
