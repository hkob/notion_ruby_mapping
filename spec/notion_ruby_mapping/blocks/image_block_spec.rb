# frozen_string_literal: true

require_relative "../../spec_helper"

module NotionRubyMapping
  RSpec.describe ImageBlock do
    type = :image

    it_behaves_like "retrieve block", described_class, TestConnection::BLOCK_ID_HASH[:image_external], false, {
      object: "block",
      type: "image",
      image: {
        caption: [],
        type: "external",
        external: {
          url: "https://cdn.worldvectorlogo.com/logos/notion-logo-1.svg",
        },
      },
    }

    describe "create_child_block" do
      let(:target) do
        described_class.new "https://cdn.worldvectorlogo.com/logos/notion-logo-1.svg", caption: "Notion logo"
      end

      it_behaves_like "create child block", described_class,
                      "7b2f144fd2714ea690db8ffd5a84e8f0", "9a94b3131a1d4a0b814e60c8bf0345f1"
    end

    describe "save (update)" do
      let(:update_id) { TestConnection::UPDATE_BLOCK_ID_HASH[type.to_sym] }
      let(:target) do
        described_class.new "https://cdn.worldvectorlogo.com/logos/notion-logo-1.svg", caption: "Notion logo",
                                                                                       id: update_id
      end

      it_behaves_like "update block file", type, "https://cdn.worldvectorlogo.com/logos/notion-logo-1.svg"

      it_behaves_like "update block caption", type, "macOS logo"
    end
  end
end
