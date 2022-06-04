# frozen_string_literal: true

require_relative "../../spec_helper"

module NotionRubyMapping
  RSpec.describe ToDoBlock do
    type = "to_do"

    it_behaves_like :retrieve_block, described_class, TestConnection::BLOCK_ID_HASH[type.to_sym], true, {
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
      it_behaves_like :create_child_block, described_class,
                      "8c31e497e6504468a62b7f0f8788a6b4", "2e0af12a1a6c4b6d814f99ebf3358a2d"
    end

    describe "save (update)" do
      let(:update_id) { TestConnection::UPDATE_BLOCK_ID_HASH[type.to_sym] }
      let(:target) { described_class.new "old To Do", id: update_id, color: "green_background" }

      it_behaves_like :update_block_rich_text_array, type, "new To Do"
      it_behaves_like :update_block_color, type, "orange_background", true

      context "checked" do
        before { target.checked = true }
        let(:json) { {type => {"checked" => true}} }
        it { expect(target.update_block_json).to eq json }
        context "dry_run" do
          let(:dry_run) { target.save dry_run: true }
          it_behaves_like :dry_run, :patch, :block_path, use_id: true, json_method: :update_block_json
        end

        context "save" do
          it { expect(target.save.checked).to eq true }
        end
      end
    end
  end
end
