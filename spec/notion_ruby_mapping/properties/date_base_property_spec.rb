# frozen_string_literal: true

module NotionRubyMapping
  RSpec.describe DateProperty do
    it "start_end_time" do
      expect(described_class.start_end_time(Date.new(2022, 2, 22))).to eq %w[2022-02-22T00:00:00+09:00 2022-02-22T23:59:59+09:00]
    end
  end


  [CreatedTimeProperty, DateProperty, LastEditedTimeProperty].each do |c|
    RSpec.describe c do
      let(:target) { c.new "dp" }
      describe "a date property" do
        it_behaves_like :has_name_as, "dp"

        context "create query for date" do
          subject { query.filter }
          [
            [
              "date",
              Date.new(2022, 2, 12),
              "2022-02-12",
              "2022-02-12T00:00:00+09:00",
              "2022-02-12T23:59:59+09:00"
            ],
            [
              "time",
              Time.new(2022, 2, 12, 1, 23, 45, "+09:00"),
              "2022-02-12T01:23:45+09:00",
              "2022-02-12T01:23:45+09:00",
              "2022-02-12T01:23:45+09:00",
            ],
          ].each do |(title, d, ds, dss, des)|
            context "on parameter #{title}" do
              it_behaves_like :filter_test, c, %w[before on_or_after], value: d, value_str: dss
              it_behaves_like :filter_test, c, %w[after on_or_before], value: d, value_str: des
              if title == "time"
                it_behaves_like :filter_test, c, %w[equals does_not_equal], value: d, value_str: ds
              else
                it_behaves_like :date_equal_filter_test, c, %w[equals does_not_equal], d
              end
              unless c == DateProperty
                it_behaves_like :timestamp_filter_test, c, %w[before on_or_after], value: d, value_str: dss
                it_behaves_like :timestamp_filter_test, c, %w[after on_or_before], value: d, value_str: des
                if title == "time"
                  it_behaves_like :timestamp_filter_test, c, %w[equals does_not_equal], value: d, value_str: ds if title == "time"
                else
                  it_behaves_like :date_equal_timestamp_filter_test, c, %w[equals does_not_equal], d
                end
              end
            end
          end
          it_behaves_like :filter_test, c, %w[is_empty is_not_empty]
          it_behaves_like :filter_test, c, %w[past_week past_month past_year this_week next_week next_month next_year],
                          value_str: {}
          unless c == DateProperty
            it_behaves_like :timestamp_filter_test, c, %w[is_empty is_not_empty]
            it_behaves_like :timestamp_filter_test, c,
                            %w[past_week past_month past_year this_week next_week next_month next_year], value_str: {}
          end
        end
      end
    end
  end
end
