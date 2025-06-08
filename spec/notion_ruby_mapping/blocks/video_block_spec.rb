# frozen_string_literal: true

require_relative "../../spec_helper"

module NotionRubyMapping
  RSpec.describe VideoBlock do
    type = :video

    it_behaves_like "retrieve block", described_class, TestConnection::BLOCK_ID_HASH[type], false, {
      object: "block",
      type: "video",
      video: {
        caption: [],
        type: "external",
        external: {
          url: "https://youtu.be/gp2yhkVw0z4",
        },
      },
    }

    describe "create_child_block" do
      let(:target) do
        described_class.new "https://download.samplelib.com/mp4/sample-5s.mp4"
      end

      it_behaves_like "create child block", described_class,
                      "93a9e7684171437cb6e855d2c922306e", "b264e6b3a6164beca088e5ae86e3d0ae"
    end

    describe "save (update)" do
      let(:update_id) { TestConnection::UPDATE_BLOCK_ID_HASH[type.to_sym] }
      let(:target) do
        described_class.new "https://download.samplelib.com/mp4/sample-5s.mp4", caption: "Old caption", id: update_id
      end

      it_behaves_like "update block caption", type, "New caption"
      it_behaves_like "update block file", type, "https://www.learningcontainer.com/wp-content/uploads/2020/05/sample-mp4-file.mp4"
    end
  end
end
