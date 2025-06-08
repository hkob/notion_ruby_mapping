# frozen_string_literal: true

module NotionRubyMapping
  RSpec.describe TextObject do
    tc = TestConnection.instance
    text_json = tc.read_json "text_plain_object"
    href_json = tc.read_json "text_href_object"

    describe "self.text_object" do
      subject { RichTextObject.text_object to }
      context "when String" do
        let(:to) { "String" }

        it { expect(subject).to be_is_a TextObject }
        it { expect(subject.text).to eq "String" }
      end

      context "when TextObject" do
        let(:to) { TextObject.new "TextObject" }

        it { expect(subject).to be_is_a TextObject }
        it { expect(subject.text).to eq "TextObject" }
      end

      context "when MentionObject" do
        let(:to) { MentionObject.new user_id: "user_id" }

        it { expect(subject).to be_is_a MentionObject }
        it { expect(subject.text).to eq "" }
      end
    end

    describe "RichTextObject class" do
      it "raise error to construct parent RichTextObject directly" do
        expect { RichTextObject.new "ABC" }.to raise_error(StandardError)
      end
    end

    describe "property_values_json" do
      context "when plain_text" do
        let(:target) { tc.to_text }

        it_behaves_like "property values json", {
          type: "text",
          text: {
            content: "plain_text",
            link: nil,
          },
          plain_text: "plain_text",
          href: nil,
        }
      end

      context "href" do
        let(:target) { tc.to_href }

        it_behaves_like "property values json", {
          type: "text",
          text: {
            content: "href_text",
            link: {
              url: "https://www.google.com/",
            },
          },
          plain_text: "href_text",
          href: "https://www.google.com/",
        }
      end

      context "annotations" do
        %i[bold italic strikethrough underline code].each do |an|
          context "annotation #{an}" do
            let(:target) { TextObject.new "#{an}_text", {an => true} }

            it_behaves_like "property values json", {
              type: "text",
              text: {
                content: "#{an}_text",
                link: nil,
              },
              annotations: {
                an => true,
              },
              plain_text: "#{an}_text",
              href: nil,
            }
          end
        end
      end
    end

    describe "create_from_json" do
      let(:target) { TextObject.create_from_json json }

      context "plain_text" do
        let(:json) { text_json }

        it_behaves_like "property values json", {
          type: "text",
          text: {
            content: "abc\n",
            link: nil,
          },
          annotations: {
            bold: false,
            italic: false,
            strikethrough: false,
            underline: false,
            code: false,
            color: "default",
          },
          plain_text: "abc\n",
          href: nil,
        }
      end

      context "text with link" do
        let(:json) { href_json }

        it_behaves_like "property values json", {
          type: "text",
          text: {
            content: "高専HP",
            link: {
              url: "https://www.metro-cit.ac.jp",
            },
          },
          annotations: {
            bold: false,
            italic: false,
            strikethrough: false,
            underline: false,
            code: false,
            color: "default",
          },
          plain_text: "高専HP",
          href: "https://www.metro-cit.ac.jp",
        }
      end
    end

    context "xxx=" do
      let(:target) { TextObject.new "ABC" }

      {
        :text= => [
          "DEF",
          {type: "text", text: {content: "DEF", link: nil}, plain_text: "DEF", href: nil},
        ],
        :bold= => [
          true,
          {type: "text", text: {content: "ABC", link: nil}, annotations: {bold: true},
           plain_text: "ABC", href: nil},
        ],
        :italic= => [
          true,
          {type: "text", text: {content: "ABC", link: nil}, annotations: {italic: true},
           plain_text: "ABC", href: nil},
        ],
        :strikethrough= => [
          true,
          {type: "text", text: {content: "ABC", link: nil}, annotations: {strikethrough: true},
           plain_text: "ABC", href: nil},
        ],
        :underline= => [
          true,
          {type: "text", text: {content: "ABC", link: nil}, annotations: {underline: true},
           plain_text: "ABC", href: nil},
        ],
        :code= => [
          true,
          {type: "text", text: {content: "ABC", link: nil}, annotations: {code: true},
           plain_text: "ABC", href: nil},
        ],
        :color= => [
          "red",
          {type: "text", text: {content: "ABC", link: nil}, annotations: {color: "red"},
           plain_text: "ABC", href: nil},
        ],
      }.each do |method, (value, json)|
        context method do
          before { target.send(method, value) }

          it_behaves_like "property values json", json
        end
      end
    end
  end
end
