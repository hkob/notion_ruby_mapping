# frozen_string_literal: true

module NotionRubyMapping
  RSpec.describe RollupProperty do
    tc = TestConnection.instance
    # frozen_string_literal: true

    describe "a rollup property" do
      let(:property) { RollupProperty.new "rp" }
      it "has name" do
        expect(property.name).to eq "rp"
      end

      context "create query" do
        subject { query.filter }
        [
          ["date", Date.new(2022, 2, 12), "2022-02-12"],
          ["time", Time.new(2022, 2, 12, 1, 23, 45, "+09:00"), "2022-02-12T01:23:45+09:00"],
        ].each do |(title, d, ds)|
          context "on parameter #{title}" do
            it_behaves_like :filter_test, RollupProperty, %w[equals before after on_or_before on_or_after],
                            value: d, value_str: ds
          end
        end

        it_behaves_like :filter_test, NumberProperty,
                        %w[equals does_not_equal greater_than less_than greater_than_or_equal_to less_than_or_equal_to],
                        value: 100
        %w[any every none].each do |rollup|
          context rollup do
            it_behaves_like :filter_test, RollupProperty,
                            %w[equals does_not_equal contains does_not_contain starts_with ends_with],
                            value: "abc", rollup: rollup, rollup_type: "rich_text"
            it_behaves_like :filter_test, RollupProperty,
                            %w[equals does_not_equal greater_than less_than greater_than_or_equal_to
                               less_than_or_equal_to], value: 100, rollup: rollup, rollup_type: "number"
            it_behaves_like :filter_test, RollupProperty, %w[is_empty is_not_empty],
                            rollup: rollup, rollup_type: "number"
            it_behaves_like :filter_test, RollupProperty,
                            %w[past_week past_month past_year next_week next_month next_year],
                            value_str: {}, rollup: rollup, rollup_type: "date"
          end
        end
      end
    end

    describe "a rollup property with parameters" do
      let(:target) { RollupProperty.new "rp", json: {"type" => "number", "number" => 123} }

      it_behaves_like :property_values_json, {}
      it_behaves_like :will_not_update

      describe "update_from_json" do
        before { target.update_from_json(tc.read_json("rollup_property_item")) }
        it_behaves_like :will_not_update
        it_behaves_like :property_values_json, {}
      end
    end

    describe "a rollup property from property_item_json" do
      let(:target) { Property.create_from_json "rp", tc.read_json("rollup_property_item") }
      it_behaves_like :has_name_as, "rp"
      it_behaves_like :will_not_update
      it_behaves_like :property_values_json, {}
    end
  end
end
