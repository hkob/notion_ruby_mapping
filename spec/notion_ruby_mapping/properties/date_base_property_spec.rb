# frozen_string_literal: true

module NotionRubyMapping
  [CreatedTimeProperty, DateProperty, LastEditedTimeProperty].each do |c|
    RSpec.describe c do
      let(:target) { c.new "dp" }
      describe "a date property" do
        it_behaves_like :has_name_as, "dp"

        context "create query for date" do
          subject { query.filter }
          [
            ["date", Date.new(2022, 2, 12), "2022-02-12"],
            ["time", Time.new(2022, 2, 12, 1, 23, 45, "+09:00"), "2022-02-12T01:23:45+09:00"],
          ].each do |(title, d, ds)|
            context "on parameter #{title}" do
              it_behaves_like :filter_test, c, %w[equals before after on_or_before on_or_after],
                              value: d, value_str: ds
              unless c == DateProperty
                it_behaves_like :timestamp_filter_test, c, %w[equals before after on_or_before on_or_after],
                                value: d, value_str: ds

              end
            end
          end
          it_behaves_like :filter_test, c, %w[is_empty is_not_empty]
          it_behaves_like :filter_test, c, %w[past_week past_month past_year next_week next_month next_year],
                          value_str: {}
          unless c == DateProperty
            it_behaves_like :timestamp_filter_test, c, %w[is_empty is_not_empty]
            it_behaves_like :timestamp_filter_test, c,
                            %w[past_week past_month past_year next_week next_month next_year], value_str: {}
          end
        end
      end
    end
  end
end
