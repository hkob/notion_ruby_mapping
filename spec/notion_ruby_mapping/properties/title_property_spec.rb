# frozen_string_literal: true

module NotionRubyMapping
  RSpec.describe TitleProperty do
    tc = TestConnection.instance
    let(:first_page_id) { TestConnection::DB_FIRST_PAGE_ID }
    let(:property_cache_first) { PropertyCache.new base_type: "page", page_id: first_page_id }

    context "when Database property" do
      context "when created by new" do
        let(:target) { described_class.new "tp", base_type: "database" }

        it_behaves_like "has name as", "tp"
        it_behaves_like "property schema json", {"tp" => {"title" => {}}}

        describe "update_from_json" do
          before { target.update_from_json(tc.read_json("title_property_object")) }

          it_behaves_like "will not update"
          it_behaves_like "assert different property", :property_values_json
        end
      end

      context "when created from json" do
        let(:target) { Property.create_from_json "tp", tc.read_json("title_property_object"), "database" }

        it_behaves_like "has name as", "tp"
        it_behaves_like "will not update"
        it_behaves_like "assert different property", :property_values_json
      end
    end

    context "when DataSource property" do
      context "when created by new" do
        let(:target) { described_class.new "tp", base_type: "data_source" }

        it_behaves_like "has name as", "tp"
        it_behaves_like "property schema json", {"tp" => {"title" => {}}}

        describe "update_from_json" do
          before { target.update_from_json(tc.read_json("title_property_object")) }

          it_behaves_like "will not update"
          it_behaves_like "assert different property", :property_values_json
          it_behaves_like "update property schema json", {}
        end

        describe "new_name=" do
          before { target.new_name = "new_name" }

          it_behaves_like "will update"
          it_behaves_like "assert different property", :property_values_json
          it_behaves_like "update property schema json", {"tp" => {"name" => "new_name"}}
        end

        describe "remove" do
          before { target.remove }

          it_behaves_like "will update"
          it_behaves_like "assert different property", :property_values_json
          it_behaves_like "update property schema json", {"tp" => nil}
        end
      end

      context "when created from json" do
        let(:target) { Property.create_from_json "tp", tc.read_json("title_property_object"), "data_source" }

        it_behaves_like "has name as", "tp"
        it_behaves_like "will not update"
        it_behaves_like "assert different property", :property_values_json
        it_behaves_like "update property schema json", {}
      end
    end

    context "when Page property" do
      retrieve_title = {
        "tp" => {
          "type" => "title",
          "title" => [
            {
              "type" => "text",
              "text" => {
                "content" => "ABC",
                "link" => nil,
              },
              "annotations" => {
                "bold" => false,
                "italic" => false,
                "strikethrough" => false,
                "underline" => false,
                "code" => false,
                "color" => "default",
              },
              "plain_text" => "ABC",
              "href" => nil,
            },
          ],
        },
      }
      describe "a title property with parameters" do
        [
          [
            "text only",
            [tc.to_text],
            {
              "type" => "title",
              "title" => [
                {
                  "type" => "text",
                  "text" => {
                    "content" => "plain_text",
                    "link" => nil,
                  },
                  "plain_text" => "plain_text",
                  "href" => nil,
                },
              ],
            },
          ],
          [
            "text, link text",
            [tc.to_text, tc.to_href],
            {
              "type" => "title",
              "title" => [
                {
                  "type" => "text",
                  "text" => {
                    "content" => "plain_text",
                    "link" => nil,
                  },
                  "plain_text" => "plain_text",
                  "href" => nil,
                },
                {
                  "type" => "text",
                  "text" => {
                    "content" => "href_text",
                    "link" => {
                      "url" => "https://www.google.com/",
                    },
                  },
                  "plain_text" => "href_text",
                  "href" => "https://www.google.com/",
                },
              ],
            },
          ],
        ].each do |(label, params, ans_json)|
          context label do
            let(:target) { described_class.new "tp", text_objects: params }

            it_behaves_like "property values json", {"tp" => ans_json}
            it_behaves_like "will not update"

            describe "update_from_json" do
              before { target.update_from_json(tc.read_json("retrieve_property_title")) }

              it_behaves_like "property values json", retrieve_title
            end
          end
        end
      end

      describe "empty title" do
        context "when all title text objects are deleted" do
          let(:target) { described_class.new "title", text_objects: [tc.to_text] }

          before { target.delete_at 0 }

          it_behaves_like "will update"

          it_behaves_like "property values json", {
            "title" => {
              "type" => "title",
              "title" => [],
            },
          }
        end
      end

      describe "plain_text=" do
        let(:target) { described_class.new "tp", text_objects: [tc.to_href] }

        before { target.plain_text = "new title" }

        it_behaves_like "will update"

        it { expect(target.full_text).to eq "new title" }

        it_behaves_like "property values json", {
          "tp" => {
            "type" => "title",
            "title" => [
              {
                "type" => "text",
                "text" => {
                  "content" => "new title",
                  "link" => nil,
                },
                "plain_text" => "new title",
                "href" => nil,
              },
            ],
          },
        }
      end

      describe "plain_text= nil" do
        let(:target) { described_class.new "tp", text_objects: [tc.to_text] }

        it "raises an error when nil is given" do
          expect { target.plain_text = nil }.to raise_error(ArgumentError)
        end
      end

      describe "clear" do
        let(:target) { described_class.new "title", text_objects: [tc.to_text] }

        before { target.clear }

        it_behaves_like "will update"

        it_behaves_like "property values json", {
          "title" => {
            "type" => "title",
            "title" => [],
          },
        }
      end

      describe "a title property from property_item_json" do
        let(:target) { Property.create_from_json "tp", tc.read_json("retrieve_property_title") }

        it_behaves_like "has name as", "tp"
        it_behaves_like "will not update"
        it_behaves_like "property values json", retrieve_title

        context "when a paragraph text and href_text" do
          let(:target) { described_class.new "tp", text_objects: [tc.to_text, tc.to_href] }

          describe "[]" do
            it { expect(target[0].text).to eq "plain_text" }
            it { expect(target[1].text).to eq "href_text" }
          end

          describe "map" do
            it { expect(target.map(&:text)).to eq %w[plain_text href_text] }
          end

          describe "map.with_index" do
            it "returns Enumerable object" do
              ans = target.map.with_index { |to, i| "#{i}:#{to.text}" }
              expect(ans).to eq %w[0:plain_text 1:href_text]
            end
          end
        end
      end
    end
  end
end
