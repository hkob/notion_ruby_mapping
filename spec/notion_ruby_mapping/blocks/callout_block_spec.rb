# frozen_string_literal: true

require_relative "../../spec_helper"

module NotionRubyMapping
  RSpec.describe CalloutBlock do
    type = "callout"

    it_behaves_like "retrieve block", described_class, TestConnection.block_id(type), true, {
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
      context "when callout_emoji" do
        let(:sub_block) { ParagraphBlock.new "with children" }
        let(:target) { described_class.new "Emoji callout", emoji: "✅", color: "blue", sub_blocks: sub_block }

        it_behaves_like "create child block", described_class,
                        "26cd8e4e98ab8140b7a1ca62044cd1c5", "26cd8e4e98ab810f9122f43ae1a17649"
      end

      context "callout url" do
        let(:sub_block) { ParagraphBlock.new "with children" }
        let(:target) do
          described_class.new "Url callout", file_url: "https://img.icons8.com/ios-filled/250/000000/mac-os.png",
                                             sub_blocks: sub_block
        end

        it_behaves_like "create child block", described_class,
                        "26cd8e4e98ab81fbbedddee3debd6120", "26cd8e4e98ab810881e3dda5d55aed3b"
      end
    end

    describe "save (update)" do
      let(:update_id) { TestConnection.update_block_id(type) }
      let(:target) { described_class.new "old text", id: update_id, color: "green_background" }

      it_behaves_like "update block rich text array", type, "new text"
      it_behaves_like "update block color", type, "orange_background"

      context "file_url" do
        let(:file_url) { "https://img.icons8.com/ios-filled/250/000000/mac-os.png" }
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

        before { target.file_url = file_url }

        it { expect(target.update_block_json).to eq json }

        context "when dry_run" do
          let(:dry_run) { target.save dry_run: true }

          it_behaves_like "dry run", :patch, :block_path, use_id: true, json_method: :update_block_json
        end

        context "when save" do
          it { expect(target.save.file_url).to eq file_url }
        end
      end

      context "emoji" do
        let(:emoji) { "💡" }
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

        before { target.emoji = emoji }

        it { expect(target.update_block_json).to eq json }

        context "when dry_run" do
          let(:dry_run) { target.save dry_run: true }

          it_behaves_like "dry run", :patch, :block_path, use_id: true, json_method: :update_block_json
        end

        context "when save" do
          it { expect(target.save.emoji).to eq emoji }
        end
      end
    end
  end
end
