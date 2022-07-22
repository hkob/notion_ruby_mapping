# frozen_string_literal: true

module NotionRubyMapping
  RSpec.describe RichTextProperty do
    tc = TestConnection.instance
    let(:no_content_json) { {"id" => "flUp"} }
    let(:first_page_id) { TestConnection::DB_FIRST_PAGE_ID }
    let(:property_cache_first) { PropertyCache.new base_type: :page, page_id: first_page_id }

    context "Database property" do
      context "created by new" do
        let(:target) { RichTextProperty.new "tp", base_type: :database }
        it_behaves_like :has_name_as, "tp"
        it_behaves_like :property_schema_json, {"tp" => {"rich_text" => {}}}

        describe "update_from_json" do
          before { target.update_from_json(tc.read_json("rich_text_property_object")) }
          it_behaves_like :will_not_update
          it_behaves_like :assert_different_property, :property_values_json
          it_behaves_like :update_property_schema_json, {}
        end

        describe "new_name=" do
          before { target.new_name = "new_name" }
          it_behaves_like :will_update
          it_behaves_like :assert_different_property, :property_values_json
          it_behaves_like :update_property_schema_json, {"tp" => {"name" => "new_name"}}
        end

        describe "remove" do
          before { target.remove }
          it_behaves_like :will_update
          it_behaves_like :assert_different_property, :property_values_json
          it_behaves_like :update_property_schema_json, {"tp" => nil}
        end
      end

      context "created from json" do
        let(:target) { Property.create_from_json "tp", tc.read_json("rich_text_property_object"), :database }
        it_behaves_like :has_name_as, "tp"
        it_behaves_like :will_not_update
        it_behaves_like :assert_different_property, :property_values_json
        it_behaves_like :update_property_schema_json, {}
      end
    end

    describe "Page property" do
      retrieve_rich_text = {
        "rtp" => {
          "type" => "rich_text",
          "rich_text" => [
            {
              "type" => "text",
              "text" => {
                "content" => "def",
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
              "plain_text" => "def",
              "href" => nil,
            },
          ],
        },
      }
      describe "a rich_text property with parameters" do
        [
          [
            "text only",
            [tc.to_text],
            "plain_text",
            {
              "type" => "rich_text",
              "rich_text" => [
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
            "plain_texthref_text",
            {
              "type" => "rich_text",
              "rich_text" => [
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
        ].each do |(label, params, full_text, ans_json)|
          context label do
            let(:target) { RichTextProperty.new "rtp", text_objects: params }
            it { expect(target.full_text).to eq full_text }
            it_behaves_like :property_values_json, {"rtp" => ans_json}
            it_behaves_like :will_not_update
          end
        end
      end

      describe "a rich_text property from property_item_json" do
        let(:target) { Property.create_from_json "rtp", tc.read_json("retrieve_property_rich_text") }
        it_behaves_like :has_name_as, "rtp"
        it_behaves_like :will_not_update
        it_behaves_like :property_values_json, retrieve_rich_text
      end

      context "created from json (no content)" do
        let(:target) { Property.create_from_json "rtp", no_content_json, :page, property_cache_first }
        it_behaves_like :has_name_as, "rtp"
        it_behaves_like :will_not_update
        it { expect(target.contents?).to be_falsey }
        it_behaves_like :assert_different_property, :update_property_schema_json

        # hook property_values_json / title to retrieve a property item
        it_behaves_like :property_values_json, retrieve_rich_text
      end
    end
  end
end
