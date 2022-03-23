# frozen_string_literal: true

module NotionRubyMapping
  RSpec.describe TitleProperty do
    tc = TestConnection.instance

    context "Database property" do
      context "created by new" do
        let(:target) { TitleProperty.new "tp", base_type: :database }
        it_behaves_like :has_name_as, "tp"
        it_behaves_like :property_schema_json, {"tp" => {"title" => {}}}

        describe "update_from_json" do
          before { target.update_from_json(tc.read_json("title_property_object")) }
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
        let(:target) { Property.create_from_json "tp", tc.read_json("title_property_object"), :database }
        it_behaves_like :has_name_as, "tp"
        it_behaves_like :will_not_update
        it_behaves_like :assert_different_property, :property_values_json
        it_behaves_like :update_property_schema_json, {}
      end
    end

    context "Page property" do
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
            let(:target) { TitleProperty.new "tp", text_objects: params }
            it_behaves_like :property_values_json, {"tp" => ans_json}
            it_behaves_like :will_not_update

            describe "update_from_json" do
              before { target.update_from_json(tc.read_json("title_property_item")) }
              it_behaves_like :property_values_json, {
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
            end
          end
        end
      end

      describe "a title property from property_item_json" do
        let(:target) { Property.create_from_json "tp", tc.read_json("title_property_item") }
        it_behaves_like :has_name_as, "tp"
        it_behaves_like :will_not_update
        it_behaves_like :property_values_json, {
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

        context "a paragraph text and href_text" do
          let(:target) { TitleProperty.new "tp", text_objects: [tc.to_text, tc.to_href] }

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

      # describe "start=" do
      #   subject { property.property_values_json }
      #   {
      #     Date.new(2022, 2, 22) => [
      #       [{}, {"start" => "2022-02-22"}],
      #       [{start_date: Date.new(2022, 2, 22)}, {"start" => "2022-02-22"}],
      #       [{end_date: Date.new(2022, 2, 24)}, {"start" => "2022-02-22", "end" => "2022-02-24"}],
      #       [
      #         {end_date: Time.new(2022, 2, 24, 1, 23, 45, "+09:00")},
      #         {"start" => "2022-02-22"}, # Different class -> clear end_date
      #       ],
      #       [{end_date: Date.new(2022, 2, 20)}, {"start" => "2022-02-22"}], # Previous date -> clear end_date
      #     ],
      #     Time.new(2022, 2, 22, 1, 23, 45, "+09:00") => [
      #       [{}, {"start" => "2022-02-22T01:23:45+09:00"}],
      #       [{start_date: Date.new(2022, 2, 22)}, {"start" => "2022-02-22T01:23:45+09:00"}],
      #       [
      #         {end_date: Time.new(2022, 2, 24, 1, 23, 45, "+09:00")},
      #         {"start" => "2022-02-22T01:23:45+09:00", "end" => "2022-02-24T01:23:45+09:00"},
      #       ],
      #       [
      #         {end_date: Date.new(2022, 2, 24)},
      #         {"start" => "2022-02-22T01:23:45+09:00"}, # Different class -> clear end_date
      #       ],
      #       [
      #         {end_date: Time.new(2022, 2, 20, 1, 23, 45, "+09:00")},
      #         {"start" => "2022-02-22T01:23:45+09:00"}, # Previous date -> clear end_date
      #       ],
      #     ],
      #     DateTime.new(2022, 2, 22, 1, 23, 45, "+09:00") => [
      #       [{}, {"start" => "2022-02-22T01:23:45+09:00"}],
      #       [{start_date: Date.new(2022, 2, 22)}, {"start" => "2022-02-22T01:23:45+09:00"}],
      #       [
      #         {end_date: DateTime.new(2022, 2, 24, 1, 23, 45, "+09:00")},
      #         {"start" => "2022-02-22T01:23:45+09:00", "end" => "2022-02-24T01:23:45+09:00"},
      #       ],
      #       [
      #         {end_date: Date.new(2022, 2, 24)},
      #         {"start" => "2022-02-22T01:23:45+09:00"}, # Different class -> clear end_date
      #       ],
      #       [
      #         {end_date: DateTime.new(2022, 2, 20, 1, 23, 45, "+09:00")},
      #         {"start" => "2022-02-22T01:23:45+09:00"}, # Previous date -> clear end_date
      #       ],
      #     ],
      #   }.each do |date, array|
      #     array.each do |params, answer|
      #       context params do
      #         let(:property) { DateProperty.new "dp", **params }
      #         before { property.start_date = date }
      #         it { is_expected.to eq({"date" => answer}) }
      #         it "will update" do
      #           expect(property.will_update).to be_truthy
      #         end
      #       end
      #     end
      #   end
      # end

      # describe "end=" do
      #   subject { property.property_values_json }
      #   {
      #     Date.new(2022, 2, 22) => [
      #       [{}, {}],
      #       [{start_date: Date.new(2022, 2, 20)}, {"start" => "2022-02-20", "end" => "2022-02-22"}],
      #       [
      #         {start_date: Date.new(2022, 2, 21), end_date: Date.new(2022, 2, 22)},
      #         {"start" => "2022-02-21", "end" => "2022-02-22"},
      #       ],
      #       [
      #         {start_date: Time.new(2022, 2, 20, 1, 23, 45, "+09:00")},
      #         {"start" => "2022-02-20T01:23:45+09:00"}, # Different class -> clear end_date
      #       ],
      #       [
      #         {start_date: Date.new(2022, 2, 24)},
      #         {"start" => "2022-02-24"},
      #       ], # Previous date -> clear end_date
      #     ],
      #     Time.new(2022, 2, 22, 1, 23, 45, "+09:00") => [
      #       [{}, {}],
      #       [
      #         {start_date: Time.new(2022, 2, 21, 1, 23, 45, "+09:00")},
      #         {"start" => "2022-02-21T01:23:45+09:00", "end" => "2022-02-22T01:23:45+09:00"},
      #       ],
      #       [
      #         {
      #           start_date: Time.new(2022, 2, 20, 1, 23, 45, "+09:00"),
      #           end_date: Time.new(2022, 2, 24, 1, 23, 45, "+09:00"),
      #         },
      #         {"start" => "2022-02-20T01:23:45+09:00", "end" => "2022-02-22T01:23:45+09:00"},
      #       ],
      #       [
      #         {start_date: Date.new(2022, 2, 20)},
      #         {"start" => "2022-02-20"}, # Different class -> clear end_date
      #       ],
      #       [
      #         {start_date: Time.new(2022, 2, 24, 1, 23, 45, "+09:00")},
      #         {"start" => "2022-02-24T01:23:45+09:00"}, # Previous date -> clear end_date
      #       ],
      #     ],
      #     DateTime.new(2022, 2, 22, 1, 23, 45, "+09:00") => [
      #       [{}, {}],
      #       [
      #         {start_date: DateTime.new(2022, 2, 21, 1, 23, 45, "+09:00")},
      #         {"start" => "2022-02-21T01:23:45+09:00", "end" => "2022-02-22T01:23:45+09:00"},
      #       ],
      #       [
      #         {
      #           start_date: DateTime.new(2022, 2, 20, 1, 23, 45, "+09:00"),
      #           end_date: DateTime.new(2022, 2, 24, 1, 23, 45, "+09:00"),
      #         },
      #         {"start" => "2022-02-20T01:23:45+09:00", "end" => "2022-02-22T01:23:45+09:00"},
      #       ],
      #       [
      #         {start_date: Date.new(2022, 2, 20)},
      #         {"start" => "2022-02-20"}, # Different class -> clear end_date
      #       ],
      #       [
      #         {start_date: DateTime.new(2022, 2, 24, 1, 23, 45, "+09:00")},
      #         {"start" => "2022-02-24T01:23:45+09:00"}, # Previous date -> clear end_date
      #       ],
      #     ],
      #   }.each do |date, array|
      #     context date.class do
      #       array.each do |params, answer|
      #         context params do
      #           let(:property) { DateProperty.new "dp", **params }
      #           before { property.end_date = date }
      #           it { is_expected.to eq({"date" => answer}) }
      #           it "will update" do
      #             expect(property.will_update).to be_truthy
      #           end
      #         end
      #       end
      #     end
      #   end
      # end
      # end

      # describe "create_from_json" do
      #   [
      #     {"start" => "2022-02-20"},
      #     {"start" => "2022-02-20", "end" => "2022-02-21"},
      #     {"start" => "2022-02-20T13:45:00+09:00"},
      #     {"start" => "2022-02-20T13:45:00+09:00", "end" => "2022-02-20T16:15:00+09:00"},
      #     {"start" => "2022-02-20T13:45:00", "time_zone" => "Asia/Tokyo"},
      #     {"start" => "2022-02-20T13:45:00", "end" => "2022-02-20T16:15:00", "time_zone" => "Asia/Tokyo"},
      #   ].each do |json|
      #     context json do
      #       let(:property) { Property.create_from_json "dp", {"date" => json} }
      #       it "has_name" do
      #         expect(property.name).to eq "dp"
      #       end
      #       it "property_values_json" do
      #         expect(property.property_values_json).to eq({"date" => json})
      #       end
      #       it "will not update" do
      #         expect(property.will_update).to be_falsey
      #       end
      #     end
      #   end
    end
  end
end
