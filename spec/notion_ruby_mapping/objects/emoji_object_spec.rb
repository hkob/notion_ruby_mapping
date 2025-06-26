# frozen_string_literal: true

module NotionRubyMapping
  RSpec.describe EmojiObject do
    tc = TestConnection.instance
    emoji_json = tc.read_json "emoji_object"

    describe "self.emoji_object" do
      subject { EmojiObject.emoji_object eo }
      context "when String" do
        let(:eo) { "🐶" }

        it { expect(subject).to be_is_a EmojiObject }
        it { expect(subject.emoji).to eq "🐶" }
      end

      context "when EmojiObject" do
        let(:eo) { EmojiObject.new emoji: "💿" }

        it { expect(subject).to be_is_a EmojiObject }
        it { expect(subject.emoji).to eq "💿" }
      end
    end

    describe "property_values_json" do
      let(:target) { EmojiObject.new emoji: "🟠" }

      it_behaves_like "property values json", {
        "type" => "emoji",
        "emoji" => "🟠",
      }
    end

    describe "create from json" do
      let(:target) { EmojiObject.new json: emoji_json }

      it_behaves_like "property values json", {
        "type" => "emoji",
        "emoji" => "✅",
      }
      it { expect(target.emoji).to eq "✅" }
    end

    describe "emoji=" do
      let(:target) { EmojiObject.new emoji: "🟠" }

      before { target.emoji = "✅" }

      it { expect(target.emoji).to eq "✅" }
      it { expect(target.will_update).to eq true }
    end
  end
end
