# frozen_string_literal: true

require_relative "../../spec_helper"

module NotionRubyMapping
  RSpec.describe ImageBlock do
    type = "image"

    it_behaves_like :retrieve_block, described_class, TestConnection::BLOCK_ID_HASH[:image_external], false, {
      "object" => "block",
      "type" => "image",
      "image" => {
        "caption" => [],
        "type" => "external",
        "external" => {
          "url" => "https://cdn.worldvectorlogo.com/logos/notion-logo-1.svg",
        },
      },
    }

    describe "create_child_block" do
      let(:target) do
        described_class.new "https://cdn.worldvectorlogo.com/logos/notion-logo-1.svg", caption: "Notion logo"
      end
      it_behaves_like :create_child_block, described_class,
                      "bd83ff96c8004f0bb0c9ddc783f0b2d4", "75f4887696e84d61bcab9fd5946002c9"
    end

    describe "save (update)" do
      let(:update_id) { TestConnection::UPDATE_BLOCK_ID_HASH[type.to_sym] }
      let(:target) do
        described_class.new "https://cdn.worldvectorlogo.com/logos/notion-logo-1.svg", caption: "Notion logo",
                                                                                       id: update_id
      end

      it_behaves_like :update_block_file, type, "https://cdn.worldvectorlogo.com/logos/notion-logo-1.svg"

      it_behaves_like :update_block_caption, type, "macOS logo"
    end
  end
end
