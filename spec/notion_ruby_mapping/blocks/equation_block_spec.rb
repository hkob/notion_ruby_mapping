# frozen_string_literal: true

require_relative "../../spec_helper"

module NotionRubyMapping
  RSpec.describe EquationBlock do
    type = "equation"

    it_behaves_like :retrieve_block, described_class, TestConnection::BLOCK_ID_HASH[type.to_sym], false, {
      "object" => "block",
      "type" => "equation",
      "equation" => {
        "expression" => "x = \\frac{-b\\pm\\sqrt{b^2-4ac}}{2a}",
      },
    }

    describe "create_child_block" do
      let(:target) { described_class.new "x = \\frac{-b\\pm\\sqrt{b^2-4ac}}{2a}" }
      it_behaves_like :create_child_block, described_class,
                      "6a9acb0945a74dc5aed5aafc35f4eaa4", "7e76e0b05a7d444ab8544acb27b3ea6f"
    end

    describe "save (update)" do
      let(:update_id) { TestConnection::UPDATE_BLOCK_ID_HASH[type.to_sym] }
      let(:target) { described_class.new "x = \\frac{-b\\pm\\sqrt{b^2-4ac}}{2a}", id: update_id }

      context "expression" do
        let(:new_expression) { "X(z) = \\sum_{n=-\\infty}^{\\infty}x[n]z^{-n}" }
        before { target.expression = new_expression }
        let(:json) { {type => {"expression" => new_expression}} }
        it { expect(target.update_block_json).to eq json }
        context "dry_run" do
          let(:dry_run) { target.save dry_run: true }
          it_behaves_like :dry_run, :patch, :block_path, use_id: true, json_method: :update_block_json
        end

        context "save" do
          it { expect(target.save.expression).to eq new_expression }
        end
      end
    end
  end
end
