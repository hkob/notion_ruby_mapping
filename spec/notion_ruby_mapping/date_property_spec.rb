# frozen_string_literal: true

module NotionRubyMapping
  RSpec.describe DateProperty do
    describe "a select property with parameters" do
      [
        [{}, {}],
        [{start_date: Date.new(2022, 2, 20)}, {"start" => "2022-02-20"}],
        [
          {start_date: Date.new(2022, 2, 20), end_date: Date.new(2022, 2, 21)},
          {"start" => "2022-02-20", "end" => "2022-02-21"},
        ],
        [
          {start_date: Time.local(2022, 2, 20, 13, 45)},
          {"start" => "2022-02-20T13:45:00+09:00"},
        ],
        [
          {
            start_date: Time.new(2022, 2, 20, 13, 45, 0, "+09:00"),
            end_date: Time.new(2022, 2, 20, 16, 15, 0, "+09:00"),
          },
          {"start" => "2022-02-20T13:45:00+09:00", "end" => "2022-02-20T16:15:00+09:00"},
        ],
        [
          {start_date: DateTime.new(2022, 2, 20, 13, 45, 0, "+09:00")},
          {"start" => "2022-02-20T13:45:00+09:00"},
        ],
        [
          {
            start_date: DateTime.new(2022, 2, 20, 13, 45, 0, "+09:00"),
            end_date: DateTime.new(2022, 2, 20, 16, 15, 0, "+09:00"),
          },
          {"start" => "2022-02-20T13:45:00+09:00", "end" => "2022-02-20T16:15:00+09:00"},
        ],
      ].each do |(params, json)|
        context params do
          let(:property) { DateProperty.new "dp", **params }
          subject { property.create_json }
          it { is_expected.to eq({"date" => json}) }
          it "will not update" do
            expect(property.will_update).to be_falsey
          end
        end
      end

      describe "start=" do
        subject { property.create_json }
        {
          Date.new(2022, 2, 22) => [
            [{}, {"start" => "2022-02-22"}],
            [{start_date: Date.new(2022, 2, 22)}, {"start" => "2022-02-22"}],
            [{end_date: Date.new(2022, 2, 24)}, {"start" => "2022-02-22", "end" => "2022-02-24"}],
            [
              {end_date: Time.new(2022, 2, 24, 1, 23, 45, "+09:00")},
              {"start" => "2022-02-22"}, # Different class -> clear end_date
            ],
            [{end_date: Date.new(2022, 2, 20)}, {"start" => "2022-02-22"}], # Previous date -> clear end_date
          ],
          Time.new(2022, 2, 22, 1, 23, 45, "+09:00") => [
            [{}, {"start" => "2022-02-22T01:23:45+09:00"}],
            [{start_date: Date.new(2022, 2, 22)}, {"start" => "2022-02-22T01:23:45+09:00"}],
            [
              {end_date: Time.new(2022, 2, 24, 1, 23, 45, "+09:00")},
              {"start" => "2022-02-22T01:23:45+09:00", "end" => "2022-02-24T01:23:45+09:00"},
            ],
            [
              {end_date: Date.new(2022, 2, 24)},
              {"start" => "2022-02-22T01:23:45+09:00"}, # Different class -> clear end_date
            ],
            [
              {end_date: Time.new(2022, 2, 20, 1, 23, 45, "+09:00")},
              {"start" => "2022-02-22T01:23:45+09:00"}, # Previous date -> clear end_date
            ],
          ],
          DateTime.new(2022, 2, 22, 1, 23, 45, "+09:00") => [
            [{}, {"start" => "2022-02-22T01:23:45+09:00"}],
            [{start_date: Date.new(2022, 2, 22)}, {"start" => "2022-02-22T01:23:45+09:00"}],
            [
              {end_date: DateTime.new(2022, 2, 24, 1, 23, 45, "+09:00")},
              {"start" => "2022-02-22T01:23:45+09:00", "end" => "2022-02-24T01:23:45+09:00"},
            ],
            [
              {end_date: Date.new(2022, 2, 24)},
              {"start" => "2022-02-22T01:23:45+09:00"}, # Different class -> clear end_date
            ],
            [
              {end_date: DateTime.new(2022, 2, 20, 1, 23, 45, "+09:00")},
              {"start" => "2022-02-22T01:23:45+09:00"}, # Previous date -> clear end_date
            ],
          ],
        }.each do |date, array|
          array.each do |params, answer|
            context params do
              let(:property) { DateProperty.new "dp", **params }
              before { property.start_date = date }
              it { is_expected.to eq({"date" => answer}) }
              it "will update" do
                expect(property.will_update).to be_truthy
              end
            end
          end
        end
      end

      describe "end=" do
        subject { property.create_json }
        {
          Date.new(2022, 2, 22) => [
            [{}, {}],
            [{start_date: Date.new(2022, 2, 20)}, {"start" => "2022-02-20", "end" => "2022-02-22"}],
            [
              {start_date: Date.new(2022, 2, 21), end_date: Date.new(2022, 2, 22)},
              {"start" => "2022-02-21", "end" => "2022-02-22"}
            ],
            [
              {start_date: Time.new(2022, 2, 20, 1, 23, 45, "+09:00")},
              {"start" => "2022-02-20T01:23:45+09:00"}, # Different class -> clear end_date
            ],
            [
              {start_date: Date.new(2022, 2, 24)},
              {"start" => "2022-02-24"}
            ], # Previous date -> clear end_date
          ],
          Time.new(2022, 2, 22, 1, 23, 45, "+09:00") => [
            [{}, {}],
            [
              {start_date: Time.new(2022, 2, 21, 1, 23, 45, "+09:00")},
              {"start" => "2022-02-21T01:23:45+09:00", "end" => "2022-02-22T01:23:45+09:00"}
            ],
            [
              {
                start_date: Time.new(2022, 2, 20, 1, 23, 45, "+09:00"),
                end_date: Time.new(2022, 2, 24, 1, 23, 45, "+09:00"),
              },
              {"start" => "2022-02-20T01:23:45+09:00", "end" => "2022-02-22T01:23:45+09:00"},
            ],
            [
              {start_date: Date.new(2022, 2, 20)},
              {"start" => "2022-02-20"}, # Different class -> clear end_date
            ],
            [
              {start_date: Time.new(2022, 2, 24, 1, 23, 45, "+09:00")},
              {"start" => "2022-02-24T01:23:45+09:00"}, # Previous date -> clear end_date
            ],
          ],
          DateTime.new(2022, 2, 22, 1, 23, 45, "+09:00") => [
            [{}, {}],
            [
              {start_date: DateTime.new(2022, 2, 21, 1, 23, 45, "+09:00")},
              {"start" => "2022-02-21T01:23:45+09:00", "end" => "2022-02-22T01:23:45+09:00"}
            ],
            [
              {
                start_date: DateTime.new(2022, 2, 20, 1, 23, 45, "+09:00"),
                end_date: DateTime.new(2022, 2, 24, 1, 23, 45, "+09:00"),
              },
              {"start" => "2022-02-20T01:23:45+09:00", "end" => "2022-02-22T01:23:45+09:00"},
            ],
            [
              {start_date: Date.new(2022, 2, 20)},
              {"start" => "2022-02-20"}, # Different class -> clear end_date
            ],
            [
              {start_date: DateTime.new(2022, 2, 24, 1, 23, 45, "+09:00")},
              {"start" => "2022-02-24T01:23:45+09:00"}, # Previous date -> clear end_date
            ],
          ],
        }.each do |date, array|
          context date.class do
            array.each do |params, answer|
              context params do
                let(:property) { DateProperty.new "dp", **params }
                before { property.end_date = date }
                it { is_expected.to eq({"date" => answer}) }
                it "will update" do
                  expect(property.will_update).to be_truthy
                end
              end
            end
          end
        end
      end
    end

    describe "create_from_json" do
      [
        {"start" => "2022-02-20"},
        {"start" => "2022-02-20", "end" => "2022-02-21"},
        {"start" => "2022-02-20T13:45:00+09:00"},
        {"start" => "2022-02-20T13:45:00+09:00", "end" => "2022-02-20T16:15:00+09:00"},
        {"start" => "2022-02-20T13:45:00", "time_zone" => "Asia/Tokyo"},
        {"start" => "2022-02-20T13:45:00", "end" => "2022-02-20T16:15:00", "time_zone" => "Asia/Tokyo"},
      ].each do |json|
        context json do
          let(:property) { Property.create_from_json "dp", {"date" => json} }
          it "has_name" do
            expect(property.name).to eq "dp"
          end
          it "create_json" do
            expect(property.create_json).to eq({"date" => json})
          end
          it "will not update" do
            expect(property.will_update).to be_falsey

          end
        end
      end
    end
  end
end
