# frozen_string_literal: true

require_relative "../../spec_helper"

module NotionRubyMapping
  RSpec.describe AudioBlock do
    type = "audio"

    it_behaves_like "retrieve block", described_class, TestConnection.block_id(type), false, {
      "object" => "block",
      "type" => "audio",
      "audio" => {
        "caption" => [],
        "type" => "external",
        "external" => {
          "url" => "https://download.samplelib.com/mp3/sample-3s.mp3",
        },
      },
    }

    describe "create_child_block" do
      let(:target) do
        described_class.new "https://download.samplelib.com/mp3/sample-3s.mp3"
      end

      it_behaves_like "create child block", described_class,
                      "2cad8e4e98ab8161a64bc8d7e9f6fc5d", "2cad8e4e98ab8195b8dee4a5569ad95a"
    end

    describe "save (update)" do
      let(:update_id) { TestConnection.update_block_id(type) }
      let(:target) do
        described_class.new "https://download.samplelib.com/mp3/sample-3s.mp3", caption: "Old caption", id: update_id
      end

      it_behaves_like "update block caption", type, "New caption"
      it_behaves_like "update block file", type, "https://download.samplelib.com/mp3/sample-6s.mp3"
    end
  end
end
