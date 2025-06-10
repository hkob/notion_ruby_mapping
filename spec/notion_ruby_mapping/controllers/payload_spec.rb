# frozen_string_literal: true

require_relative "../../spec_helper"

module NotionRubyMapping
  RSpec.describe Payload do
    let(:payload) { Payload.new nil }

    describe "constructor" do
      it "can create an object" do
        expect(payload).not_to be_nil
      end
    end

    subject { payload.property_values_json }
    describe "description=" do
      before { payload.description = "Title" }

      let(:ans) do
        {
          description: [
            {
              href: nil,
              plain_text: "Title",
              text: {
                content: "Title",
                link: nil,
              },
              type: "text",
            },
          ],
        }
      end

      it { is_expected.to eq ans }
    end

    describe "is_inline=" do
      before { payload.is_inline = true }

      it { is_expected.to eq({is_inline: true}) }
    end

    describe "set_icon" do
      before { payload.set_icon(**params) }

      context "for emoji icon" do
        let(:params) { {emoji: "😀"} }

        it "update icon (emoji)" do
          expect(subject).to eq({icon: {type: "emoji", emoji: "😀"}})
        end
      end

      context "for link icon" do
        let(:url) { "https://cdn.profile-image.st-hatena.com/users/hkob/profile.png" }
        let(:params) { {url: url} }

        it "update icon (link)" do
          expect(subject).to eq({icon: {type: "external", external: {url: url}}})
        end
      end
    end
  end
end
