# frozen_string_literal: true

module NotionRubyMapping
  RSpec.describe FormulaProperty do
    tc = TestConnection.instance

    describe "a formula property" do
      let(:property) { FormulaProperty.new "fp" }
      it "has name" do
        expect(property.name).to eq "fp"
      end

      context "create query" do
        subject { query.filter }
        [
          ["date", Date.new(2022, 2, 12), "2022-02-12"],
          ["time", Time.new(2022, 2, 12, 1, 23, 45, "+09:00"), "2022-02-12T01:23:45+09:00"],
        ].each do |(title, d, ds)|
          context "on parameter #{title}" do
            it_behaves_like :filter_test, FormulaProperty, %w[equals before after on_or_before on_or_after],
                            value: d, value_str: ds
          end
        end

        it_behaves_like :filter_test, FormulaProperty,
                        %w[does_not_equal contains does_not_contain starts_with ends_with on_or_before on_or_after],
                        value: "abc"
        it_behaves_like :filter_test, FormulaProperty, %w[is_empty is_not_empty]
        it_behaves_like :filter_test, FormulaProperty,
                        %w[past_week past_month past_year next_week next_month next_year], value_str: {}
        it_behaves_like :filter_test, FormulaProperty,
                        %w[equals does_not_equal greater_than less_than greater_than_or_equal_to less_than_or_equal_to],
                        value: 100
      end
    end

    describe "a formula property with parameters" do
      let(:target) { FormulaProperty.new "fp", json: {"type" => "number", "number" => 123} }

      it_behaves_like :property_values_json, {}
      it_behaves_like :will_not_update
      describe "update_from_json" do
        before { target.update_from_json(tc.read_json("formula_property_item")) }
        it_behaves_like :will_not_update
        it_behaves_like :property_values_json, {}
      end
    end

    describe "a formula property from property_item_json" do
      let(:target) { Property.create_from_json "fp", tc.read_json("formula_property_item") }
      it_behaves_like :has_name_as, "fp"
      it_behaves_like :will_not_update
      it_behaves_like :property_values_json, {}
    end
  end
end
