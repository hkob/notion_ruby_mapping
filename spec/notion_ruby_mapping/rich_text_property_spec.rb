# frozen_string_literal: true

module NotionRubyMapping
  RSpec.describe RichTextProperty do
    tci = TestConnection.instance

    describe "a title property with parameters" do
      [
        [
          "text only",
          [tci.to_text],
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
          [tci.to_text, tci.to_href],
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
      let(:target) { Property.create_from_json "rtp", tci.read_json("rich_text_property_item") }
      it_behaves_like :has_name_as, "rtp"
      it_behaves_like :will_not_update
      it_behaves_like :property_values_json, {
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
    end
  end
end
