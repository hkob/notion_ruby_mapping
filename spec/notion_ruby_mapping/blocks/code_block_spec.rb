# frozen_string_literal: true

require_relative "../../spec_helper"

module NotionRubyMapping
  RSpec.describe CodeBlock do
    type = "code"

    it_behaves_like :retrieve_block, described_class, TestConnection::BLOCK_ID_HASH[type.to_sym], false, {
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
      it_behaves_like :create_child_block, described_class,
                      "12c157112a3c48a59056d628cabcc71f", "5eabb547a2664a8b9a3d88a3eb8d0d69"
    end

    describe "save (update)" do
      let(:target) { CodeBlock.new "% ls -l", id: update_id, caption: "list files", language: "shell" }
      let(:update_id) { TestConnection::UPDATE_BLOCK_ID_HASH[type.to_sym] }

      context "language" do
        let(:new_language) { "ruby" }
        before { target.language = new_language }
        let(:json) { {"code" => {"language" => new_language}} }
        it { expect(target.update_block_json).to eq json }
        context "dry_run" do
          let(:dry_run) { target.save dry_run: true }
          it_behaves_like :dry_run, :patch, :block_path, use_id: true, json_method: :update_block_json
        end

        context "save" do
          it { expect(target.save.language).to eq new_language }
        end
      end

      it_behaves_like :update_block_rich_text_array, type, "array = %w[ABC DEF]"
      it_behaves_like :update_block_caption, type, "set an array"
    end
  end
end
