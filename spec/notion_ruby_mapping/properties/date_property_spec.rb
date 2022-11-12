# frozen_string_literal: true

module NotionRubyMapping
  RSpec.describe DateProperty do
    tc = TestConnection.instance
    let(:no_content_json) { {"id" => "SPrp"} }
    let(:first_page_id) { TestConnection::DB_FIRST_PAGE_ID }
    let(:property_cache_first) { PropertyCache.new base_type: :page, page_id: first_page_id }

    context "Database property" do
      context "created by new" do
        let(:target) { DateProperty.new "dp", base_type: :database }
        it_behaves_like :has_name_as, "dp"
        it_behaves_like :raw_json, :date, {}

        describe "update_from_json" do
          before { target.update_from_json(tc.read_json("date_property_object")) }
          it_behaves_like :will_not_update
          it_behaves_like :assert_different_property, :property_values_json
          it_behaves_like :update_property_schema_json, {}
          it_behaves_like :raw_json, :date, {}
          it_behaves_like :property_schema_json, {"dp" => {"date" => {}}}
        end

        describe "new_name=" do
          before { target.new_name = "new_name" }
          it_behaves_like :will_update
          it_behaves_like :assert_different_property, :property_values_json
          it_behaves_like :update_property_schema_json, {"dp" => {"name" => "new_name"}}
        end

        describe "remove" do
          before { target.remove }
          it_behaves_like :will_update
          it_behaves_like :assert_different_property, :property_values_json
          it_behaves_like :update_property_schema_json, {"dp" => nil}
        end
      end
    end

    describe "update_from_json" do
      let(:target) { DateProperty.new "dp", start_date: Date.today }
      before { target.update_from_json(tc.read_json("retrieve_property_date")) }
      it_behaves_like :property_values_json, {
        "dp" => {
          "type" => "date",
          "date" => {
            "start" => "2022-02-25T01:23:00.000+09:00",
            "end" => nil,
            "time_zone" => nil,
          },
        },
      }
    end

    describe "a date property with parameters" do
      [
        [{}, {"start" => nil, "end" => nil, "time_zone" => nil}],
        [{start_date: Date.new(2022, 2, 20)}, {"start" => "2022-02-20", "end" => nil, "time_zone" => nil}],
        [
          {start_date: Date.new(2022, 2, 20), end_date: Date.new(2022, 2, 21)},
          {"start" => "2022-02-20", "end" => "2022-02-21", "time_zone" => nil},
        ],
        [
          {start_date: Time.local(2022, 2, 20, 13, 45)},
          {"start" => "2022-02-20T13:45:00+09:00", "end" => nil, "time_zone" => nil},
        ],
        [
          {
            start_date: Time.new(2022, 2, 20, 13, 45, 0, "+09:00"),
            end_date: Time.new(2022, 2, 20, 16, 15, 0, "+09:00"),
          },
          {"start" => "2022-02-20T13:45:00+09:00", "end" => "2022-02-20T16:15:00+09:00", "time_zone" => nil},
        ],
        [
          {start_date: DateTime.new(2022, 2, 20, 13, 45, 0, "+09:00")},
          {"start" => "2022-02-20T13:45:00+09:00", "end" => nil, "time_zone" => nil},
        ],
        [
          {
            start_date: DateTime.new(2022, 2, 20, 13, 45, 0, "+09:00"),
            end_date: DateTime.new(2022, 2, 20, 16, 15, 0, "+09:00"),
          },
          {"start" => "2022-02-20T13:45:00+09:00", "end" => "2022-02-20T16:15:00+09:00", "time_zone" => nil},
        ],
      ].each do |(params, json)|
        context params do
          let(:target) { DateProperty.new "dp", **params }
          it_behaves_like :property_values_json, {"dp" => {"type" => "date", "date" => json}}
          it_behaves_like :will_not_update
        end
      end

      describe "start=" do
        {
          Date.new(2022, 2, 22) => [
            [{}, {"start" => "2022-02-22", "end" => nil, "time_zone" => nil}],
            [{start_date: Date.new(2022, 2, 22)}, {"start" => "2022-02-22", "end" => nil, "time_zone" => nil}],
            [
              {end_date: Date.new(2022, 2, 24)},
              {"start" => "2022-02-22", "end" => "2022-02-24", "time_zone" => nil},
            ],
            [
              {end_date: Time.new(2022, 2, 24, 1, 23, 45, "+09:00")},
              # (Different class -> clear end_date) -> not clear
              {"start" => "2022-02-22", "end" => "2022-02-24T01:23:45+09:00", "time_zone" => nil},
            ],
            [
              {end_date: Date.new(2022, 2, 20)},
              # (Previous date -> clear end_date) -> not clear
              {"start" => "2022-02-22", "end" => "2022-02-20", "time_zone" => nil},
            ],
          ],
          Time.new(2022, 2, 22, 1, 23, 45, "+09:00") => [
            [{}, {"start" => "2022-02-22T01:23:45+09:00", "end" => nil, "time_zone" => nil}],
            [
              {start_date: Date.new(2022, 2, 22)},
              {"start" => "2022-02-22T01:23:45+09:00", "end" => nil, "time_zone" => nil},
            ],
            [
              {end_date: Time.new(2022, 2, 24, 1, 23, 45, "+09:00")},
              {"start" => "2022-02-22T01:23:45+09:00", "end" => "2022-02-24T01:23:45+09:00", "time_zone" => nil},
            ],
            [
              {end_date: Date.new(2022, 2, 24)},
              # (Different class -> clear end_date) -> not clear
              {"start" => "2022-02-22T01:23:45+09:00", "end" => "2022-02-24", "time_zone" => nil},
            ],
            [
              {end_date: Time.new(2022, 2, 20, 1, 23, 45, "+09:00")},
              # (Previous date -> clear end_date) -> not clear
              {"start" => "2022-02-22T01:23:45+09:00", "end" => "2022-02-20T01:23:45+09:00", "time_zone" => nil},
            ],
          ],
          DateTime.new(2022, 2, 22, 1, 23, 45, "+09:00") => [
            [{}, {"start" => "2022-02-22T01:23:45+09:00", "end" => nil, "time_zone" => nil}],
            [
              {start_date: Date.new(2022, 2, 22)},
              {"start" => "2022-02-22T01:23:45+09:00", "end" => nil, "time_zone" => nil},
            ],
            [
              {end_date: DateTime.new(2022, 2, 24, 1, 23, 45, "+09:00")},
              {"start" => "2022-02-22T01:23:45+09:00", "end" => "2022-02-24T01:23:45+09:00", "time_zone" => nil},
            ],
            [
              {end_date: Date.new(2022, 2, 24)},
              # (Different class -> clear end_date) -> not clear
              {"start" => "2022-02-22T01:23:45+09:00", "end" => "2022-02-24", "time_zone" => nil},
            ],
            [
              # (Previous date -> clear end_date) -> not clear
              {end_date: DateTime.new(2022, 2, 20, 1, 23, 45, "+09:00")},
              {"start" => "2022-02-22T01:23:45+09:00", "end" => "2022-02-20T01:23:45+09:00", "time_zone" => nil},
            ],
          ],
        }.each do |date, array|
          array.each do |params, answer|
            context params do
              let(:target) { DateProperty.new "dp", **params }
              before { target.start_date = date }
              it_behaves_like :property_values_json, {"dp" => {"type" => "date", "date" => answer}}
              it_behaves_like :will_update
            end
          end
        end
      end

      describe "end=" do
        {
          Date.new(2022, 2, 22) => [
            [{}, {"start" => nil, "end" => "2022-02-22", "time_zone" => nil}],
            [{start_date: Date.new(2022, 2, 20)}, {"start" => "2022-02-20", "end" => "2022-02-22", "time_zone" => nil}],
            [
              {start_date: Date.new(2022, 2, 21), end_date: Date.new(2022, 2, 22)},
              {"start" => "2022-02-21", "end" => "2022-02-22", "time_zone" => nil},
            ],
            [
              {start_date: Time.new(2022, 2, 20, 1, 23, 45, "+09:00")},
              # (Different class -> clear end_date) -> not clear
              {"start" => "2022-02-20T01:23:45+09:00", "end" => "2022-02-22", "time_zone" => nil},
            ],
            [
              {start_date: Date.new(2022, 2, 24)},
              # (Previous date -> clear end_date) -> not clear
              {"start" => "2022-02-24", "end" => "2022-02-22", "time_zone" => nil},
            ],
          ],
          Time.new(2022, 2, 22, 1, 23, 45, "+09:00") => [
            [{}, {"start" => nil, "end" => "2022-02-22T01:23:45+09:00", "time_zone" => nil}],
            [
              {start_date: Time.new(2022, 2, 21, 1, 23, 45, "+09:00")},
              {"start" => "2022-02-21T01:23:45+09:00", "end" => "2022-02-22T01:23:45+09:00", "time_zone" => nil},
            ],
            [
              {
                start_date: Time.new(2022, 2, 20, 1, 23, 45, "+09:00"),
                end_date: Time.new(2022, 2, 24, 1, 23, 45, "+09:00"),
              },
              {"start" => "2022-02-20T01:23:45+09:00", "end" => "2022-02-22T01:23:45+09:00", "time_zone" => nil},
            ],
            [
              {start_date: Date.new(2022, 2, 20)},
              # (Different class -> clear end_date) -> not clear
              {"start" => "2022-02-20", "end" => "2022-02-22T01:23:45+09:00", "time_zone" => nil},
            ],
            [
              {start_date: Time.new(2022, 2, 24, 1, 23, 45, "+09:00")},
              # (Previous date -> clear end_date) -> not clear
              {"start" => "2022-02-24T01:23:45+09:00", "end" => "2022-02-22T01:23:45+09:00", "time_zone" => nil},
            ],
          ],
          DateTime.new(2022, 2, 22, 1, 23, 45, "+09:00") => [
            [{}, {"start" => nil, "end" => "2022-02-22T01:23:45+09:00", "time_zone" => nil}],
            [
              {start_date: DateTime.new(2022, 2, 21, 1, 23, 45, "+09:00")},
              {"start" => "2022-02-21T01:23:45+09:00", "end" => "2022-02-22T01:23:45+09:00", "time_zone" => nil},
            ],
            [
              {
                start_date: DateTime.new(2022, 2, 20, 1, 23, 45, "+09:00"),
                end_date: DateTime.new(2022, 2, 24, 1, 23, 45, "+09:00"),
              },
              {"start" => "2022-02-20T01:23:45+09:00", "end" => "2022-02-22T01:23:45+09:00", "time_zone" => nil},
            ],
            [
              {start_date: Date.new(2022, 2, 20)},
              # (Different class -> clear end_date) -> not clear
              {"start" => "2022-02-20", "end" => "2022-02-22T01:23:45+09:00", "time_zone" => nil},
            ],
            [
              {start_date: DateTime.new(2022, 2, 24, 1, 23, 45, "+09:00")},
              # (Previous date -> clear end_date) -> not clear
              {"start" => "2022-02-24T01:23:45+09:00", "end" => "2022-02-22T01:23:45+09:00", "time_zone" => nil},
            ],
          ],
        }.each do |date, array|
          context date.class do
            array.each do |params, answer|
              context params do
                let(:target) { DateProperty.new "dp", **params }
                before { target.end_date = date }
                it_behaves_like :property_values_json, {"dp" => {"type" => "date", "date" => answer}}
                it_behaves_like :will_update
              end
            end
          end
        end
      end
    end

    describe "create_from_json" do
      [
        {"start" => "2022-02-20", "end" => nil, "time_zone" => nil},
        {"start" => "2022-02-20", "end" => "2022-02-21", "time_zone" => nil},
        {"start" => "2022-02-20T13:45:00+09:00", "end" => nil, "time_zone" => nil},
        {"start" => "2022-02-20T13:45:00+09:00", "end" => "2022-02-20T16:15:00+09:00", "time_zone" => nil},
        {"start" => "2022-02-20T13:45:00", "end" => nil, "time_zone" => "Asia/Tokyo"},
        {"start" => "2022-02-20T13:45:00", "end" => "2022-02-20T16:15:00", "time_zone" => "Asia/Tokyo"},
      ].each do |json|
        context json do
          let(:target) { Property.create_from_json "dp", {"type" => "date", "date" => json} }
          it_behaves_like :has_name_as, "dp"
          it_behaves_like :property_values_json, {"dp" => {"type" => "date", "date" => json}}
          it_behaves_like :will_not_update
        end
      end
    end

    context "created from json (no content)" do
      let(:target) { Property.create_from_json "dp", no_content_json, :page, property_cache_first }
      it_behaves_like :has_name_as, "dp"
      it_behaves_like :will_not_update
      it { expect(target.contents?).to be_falsey }
      it_behaves_like :assert_different_property, :update_property_schema_json

      # hook property_values_json / start_time to retrieve a property item
      it_behaves_like :property_values_json, {
        "dp" => {
          "type" => "date",
          "date" => {
            "start" => "2022-02-25T01:23:00.000+09:00",
            "end" => nil,
            "time_zone" => nil,
          },
        },
      }
      it { expect(target.start_date).to eq "2022-02-25T01:23:00.000+09:00" }
      it { expect(target.end_date).to eq nil }
      it { expect(target.time_zone).to eq nil }
    end

    describe "a date property from property_item_json" do
      let(:target) { Property.create_from_json "dp", tc.read_json("retrieve_property_date") }
      it_behaves_like :has_name_as, "dp"
      it_behaves_like :will_not_update
      it_behaves_like :property_values_json, {
        "dp" => {
          "type" => "date",
          "date" => {
            "start" => "2022-02-25T01:23:00.000+09:00",
            "end" => nil,
            "time_zone" => nil,
          },
        },
      }
    end
  end
end
