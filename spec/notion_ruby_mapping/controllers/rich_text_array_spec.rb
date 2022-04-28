# frozen_string_literal: true

module NotionRubyMapping
  RSpec.describe TextObject do
    tc = TestConnection.instance
    rich_text_array_json = tc.read_json "rich_text_array"
    rich_text_property_values_json = tc.read_json "rich_text_array"
    rich_text_property_values_json[1]["mention"]["user"] = {
      "id" => "2200a911-6a96-44bb-bd38-6bfb1e01b9f6",
      "object" => "user",
    }

    context "for sample RichTextArray" do
      let(:target) { RichTextArray.new "title", json: rich_text_array_json }

      describe "count" do
        it { expect(target.count).to eq 13 }
      end

      describe "full_text" do
        it { expect(target.full_text).to eq "abc\n \n \n \n \n高専HP\n " }
      end

      describe "property_values_json" do
        it { expect(target.property_values_json).to eq([]) }
      end

      it_behaves_like :will_not_update

      context "[0].text" do
        subject { target[0] }
        it { expect(subject.text).to eq "abc\n" }
        it { expect(subject.will_update).to be_falsey }
        it_behaves_like :will_not_update

        context "after [0].text = def" do
          before { subject.text = "def\n" }
          it { expect(subject.text).to eq "def\n" }
          it { expect(subject.will_update).to be_truthy }
          it_behaves_like :will_update
        end
      end

      context "after << String" do
        before { target << "ABC" }

        describe "count" do
          it { expect(target.count).to eq 14 }
        end

        describe "full_text" do
          it { expect(target.full_text).to eq "abc\n \n \n \n \n高専HP\n ABC" }
        end
        it_behaves_like :will_update

        describe "property_values_json" do
          ans = rich_text_property_values_json + [
            {
              "href" => nil,
              "plain_text" => "ABC",
              "text" => {
                "content" => "ABC",
                "link" => nil,
              },
              "type" => "text",
            },
          ]
          it { expect(target.property_values_json).to eq ans }
        end
      end

      context "after << TextObject" do
        before { target << TextObject.new("DEF") }

        describe "count" do
          it { expect(target.count).to eq 14 }
        end

        describe "full_text" do
          it { expect(target.full_text).to eq "abc\n \n \n \n \n高専HP\n DEF" }
        end
        it_behaves_like :will_update
        describe "property_values_json" do
          ans = rich_text_property_values_json + [
            {
              "href" => nil,
              "plain_text" => "DEF",
              "text" => {
                "content" => "DEF",
                "link" => nil,
              },
              "type" => "text",
            },
          ]
          it { expect(target.property_values_json).to eq ans }
        end
      end

      context "after delete_at 0 " do
        before { target.delete_at 0 }

        describe "count" do
          it { expect(target.count).to eq 12 }
        end

        describe "full_text" do
          it { expect(target.full_text).to eq " \n \n \n \n高専HP\n " }
        end
        it_behaves_like :will_update
      end
    end

    context "create from text_objects" do
      let(:target) { RichTextArray.new "title", text_objects: text_objects }
      subject { target.full_text }
      context "a single string" do
        let(:text_objects) { "A string" }
        it { is_expected.to eq "A string" }
      end

      context "two strings" do
        let(:text_objects) { %W[ABC\n DEF] }
        it { is_expected.to eq "ABC\nDEF" }
      end

      context "A TextObject" do
        let(:text_objects) { TextObject.new "A TextObject" }
        it { is_expected.to eq "A TextObject" }
      end

      context "A TextObject and A MentionObject" do
        let(:text_objects) do
          [
            TextObject.new("A TextObject"),
            MentionObject.new(user_id: "ABC"),
          ]
        end
        it { is_expected.to eq "A TextObject" }
      end
    end

    context "create without arguments" do
      let(:target) { RichTextArray.new "title" }

      describe "count" do
        it { expect(target.count).to eq 0 }
      end
    end
  end
end
