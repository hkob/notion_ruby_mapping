# frozen_string_literal: true

require_relative "../../spec_helper"

module NotionRubyMapping
  RSpec.describe CodeBlock do
    type = "code"

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
    end
  end
end
