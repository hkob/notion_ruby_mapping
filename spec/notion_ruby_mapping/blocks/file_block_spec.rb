# frozen_string_literal: true

require_relative "../../spec_helper"

module NotionRubyMapping
  RSpec.describe FileBlock do
    type = :file

    it_behaves_like "retrieve block", described_class, TestConnection::BLOCK_ID_HASH[type.to_sym], false, {
      object: "block",
      type: "file",
      file: {
        type: "file",
        file: {
          url: "https://s3.us-west-2.amazonaws.com/secure.notion-static.com/c55cf49f-fcb4-497e-9645-d484f03bf1d5/sample.txt?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Content-Sha256=UNSIGNED-PAYLOAD&X-Amz-Credential=AKIAT73L2G45EIPT3X45%2F20220426%2Fus-west-2%2Fs3%2Faws4_request&X-Amz-Date=20220426T132600Z&X-Amz-Expires=3600&X-Amz-Signature=0a6b8b6a0d6ae1ca7ec024d357b2c3eb52ed6f0ce14bcead00da1961ad03a6de&X-Amz-SignedHeaders=host&x-id=GetObject",
          expiry_time: "2022-04-26T14:26:00.536Z",
        },
        caption: [],
      },
    }

    describe "create_child_block" do
      let(:sub_block) { ParagraphBlock.new "with children" }
      let(:target) do
        described_class.new "https://img.icons8.com/ios-filled/250/000000/mac-os.png", caption: "macOS icon"
      end

      it_behaves_like "create child block", described_class,
                      "7d216c4e05784d3fade4be41d03f3aa2", "a3e050b85d654b3799c85abe24fa0da1"
    end

    describe "save (update)" do
      let(:update_id) { TestConnection::UPDATE_BLOCK_ID_HASH[type.to_sym] }
      let(:target) do
        described_class.new "https://img.icons8.com/ios-filled/250/000000/mac-os.png",
                            caption: "macOS icon", id: update_id
      end

      it_behaves_like "update block caption", type, "Notion logo"
      it_behaves_like "update block file", type, "https://cdn.worldvectorlogo.com/logos/notion-logo-1.svg"
    end
  end
end
