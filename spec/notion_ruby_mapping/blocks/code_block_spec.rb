# frozen_string_literal: true

require_relative "../../spec_helper"

module NotionRubyMapping
  RSpec.describe CodeBlock do
    type = "code"
    tc = TestConnection.instance

    it_behaves_like "retrieve block", described_class, TestConnection.block_id(type), false, {
      "object" => "block",
      "type" => "code",
      "code" => {
        "rich_text" => [
          {
            "type" => "text",
            "text" => {
              "content" => "% ls -l",
              "link" => nil,
            },
            "annotations" => {
              "bold" => false,
              "italic" => false,
              "strikethrough" => false,
              "underline" => false,
              "code" => false,
              "color" => "default",
            },
            "href" => nil,
            "plain_text" => "% ls -l",
          },
        ],
        "language" => "shell",
        "caption" => [],
      },
    }

    describe "create from json (without caption)" do
      let(:json) { tc.read_json "retrieve_block_code_block" }
      let(:target) { described_class.new "cb", json: json }

      before { json["code"].delete "caption" }

      subject { target.caption }
      it { expect(subject.full_text).to eq "" }
      it { expect(subject.will_update).to be_falsey }
      it { expect(target.update_block_json).to eq({"code" => {}}) }
    end

    describe "constructor with wrong key caption" do
      let(:wrong_key_caption) { RichTextArray.new "rich_text", text_objects: "list command" }
      let(:target) { CodeBlock.new "%ls -l", caption: wrong_key_caption }

      let(:json) do
        {
          "code" => {
            "caption" => [
              {
                "href" => nil,
                "plain_text" => "list command",
                "text" => {
                  "content" => "list command",
                  "link" => nil,
                },
                "type" => "text",
              },
            ],
            "language" => "shell",
            "rich_text" => [
              {
                "href" => nil,
                "plain_text" => "%ls -l",
                "text" => {
                  "content" => "%ls -l",
                  "link" => nil,
                },
                "type" => "text",
              },
            ],
          },
          "object" => "block",
          "type" => "code",
        }
      end

      it {
        expect(target.block_json).to eq json
      }
    end

    describe "create_child_block" do
      let(:sub_block) { ParagraphBlock.new "with children" }
      let(:target) { described_class.new "% ls -l", caption: "List files", language: "shell" }

      it_behaves_like "create child block", described_class,
                      "26cd8e4e98ab8100bc10f027bbded664", "26cd8e4e98ab81ad9c0eebd8ef8d11b2"
    end

    describe "save (update)" do
      let(:target) { CodeBlock.new "% ls -l", id: update_id, caption: "list files", language: "shell" }
      let(:update_id) { TestConnection.update_block_id(type) }

      context "with language" do
        let(:new_language) { "ruby" }
        let(:json) { {"code" => {"language" => new_language}} }

        before { target.language = new_language }

        it { expect(target.update_block_json).to eq json }

        context "when dry_run" do
          let(:dry_run) { target.save dry_run: true }

          it_behaves_like "dry run", :patch, :block_path, use_id: true, json_method: :update_block_json
        end

        context "when save" do
          it { expect(target.save.language).to eq new_language }
        end
      end

      it_behaves_like "update block rich text array", type, "array = %w[ABC DEF]"
      it_behaves_like "update block caption", type, "set an array"

      context "with language, rich_text and caption" do
        before do
          target.language = "ruby"
          target.rich_text_array.rich_text_objects = "array = %w[ABC DEF]"
          target.caption.rich_text_objects = "set an array"
        end

        let(:json) do
          {
            type => {
              "language" => "ruby",
              "rich_text" => [
                {
                  "type" => "text",
                  "text" => {
                    "content" => "array = %w[ABC DEF]",
                    "link" => nil,
                  },
                  "plain_text" => "array = %w[ABC DEF]",
                  "href" => nil,
                },
              ],
              "caption" => [
                {
                  "type" => "text",
                  "text" => {
                    "content" => "set an array",
                    "link" => nil,
                  },
                  "plain_text" => "set an array",
                  "href" => nil,
                },
              ],
            },
          }
        end

        it { expect(target.update_block_json).to eq json }
      end

      context "with caption by wrong key" do
        before do
          target.caption.rich_text_objects = RichTextArray.new "rich_text", text_objects: "set an array"
        end

        let(:json) do
          {
            type => {
              "caption" => [
                {
                  "type" => "text",
                  "text" => {
                    "content" => "set an array",
                    "link" => nil,
                  },
                  "plain_text" => "set an array",
                  "href" => nil,
                },
              ],
            },
          }
        end

        it { expect(target.update_block_json).to eq json }
      end
    end
  end
end
