# frozen_string_literal: true

require_relative "../../spec_helper"

module NotionRubyMapping
  RSpec.describe TemplateBlock do
    type = "template"

    it_behaves_like :retrieve_block, described_class, TestConnection::BLOCK_ID_HASH[type.to_sym], true, {
      "object" => "block",
      "type" => "template",
      "template" => {
        "rich_text" => [
          {
            "type" => "text",
            "text" => {
              "content" => "Add a new to-do",
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
            "plain_text" => "Add a new to-do",
            "href" => nil,
          },
        ],
      },
    }

    describe "create_child_block" do
      let(:sub_block) { ParagraphBlock.new "with children" }
      let(:target) { TemplateBlock.new "A sample template", sub_blocks: sub_block }
      it_behaves_like :create_child_block, described_class,
                      "d7ddf708705643eb875a4b59f234fea8", "8557d88e43a4407883c785b8b82d7240"
    end

    describe "save (update)" do
      let(:update_id) { TestConnection::UPDATE_BLOCK_ID_HASH[type.to_sym] }
      let(:target) { described_class.new "Old Template", id: update_id }
      it_behaves_like :update_block_rich_text_array, type, "New template"
    end
  end
end
