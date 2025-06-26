# frozen_string_literal: true

require_relative "../../spec_helper"

module NotionRubyMapping
  RSpec.describe PdfBlock do
    type = "pdf"
    url = "https://github.com/onocom/sample-files-for-demo-use/raw/151dd797d54d7e0ae0dc50e8e19d7965b387e202/sample-pdf.pdf"

    it_behaves_like "retrieve block", described_class, TestConnection.block_id(type), false, {
      "object" => "block",
      "type" => "pdf",
      "pdf" => {
        "caption" => [],
        "type" => "external",
        "external" => {
          "url" => url,
        },
      },
    }

    describe "create_child_block" do
      let(:target) do
        described_class.new url
      end

      it_behaves_like "create child block", described_class,
                      "4ddfda7e03e34f028ae3e9aa671e59a0", "45240e9ff36f49f2836a2f8670f450d6"
    end

    describe "save (update)" do
      let(:update_id) { TestConnection.update_block_id(type) }
      let(:target) do
        PdfBlock.new url, id: update_id
      end

      it_behaves_like "update block file", type, "https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf"
      it_behaves_like "update block caption", type, "new caption"
    end
  end
end
