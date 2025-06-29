# frozen_string_literal: true

require_relative "../../spec_helper"

module NotionRubyMapping
  RSpec.describe ToDoBlock do
    type = "to_do"

    it_behaves_like "retrieve block", described_class, TestConnection.block_id(type), true, {
      "object" => "block",
      "type" => "to_do",
      "to_do" => {
        "rich_text" => [],
        "checked" => false,
        "color" => "default",
      },
    }

    describe "create_child_block" do
      let(:sub_block) { ParagraphBlock.new "with children" }
      let(:target) { ToDoBlock.new "A sample To-Do", color: "brown_background", sub_blocks: sub_block }

      it_behaves_like "create child block", described_class,
                      "5740ea0a03724a06ba61db99de46f737", "5a3bb51ab3444761b428f965be859529"
    end

    describe "save (update)" do
      let(:update_id) { TestConnection.update_block_id(type) }
      let(:target) { described_class.new "old To Do", id: update_id, color: "green_background" }

      it_behaves_like "update block rich text array", type, "new To Do"
      it_behaves_like "update block color", type, "orange_background", true

      context "checked" do
        before { target.checked = true }

        let(:json) { {type => {"checked" => true}} }

        it { expect(target.update_block_json).to eq json }

        context "dry_run" do
          let(:dry_run) { target.save dry_run: true }

          it_behaves_like "dry run", :patch, :block_path, use_id: true, json_method: :update_block_json
        end

        context "save" do
          it { expect(target.save.checked).to eq true }
        end
      end
    end
  end
end
