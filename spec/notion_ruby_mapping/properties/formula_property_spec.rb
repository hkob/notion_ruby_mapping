# frozen_string_literal: true

module NotionRubyMapping
  RSpec.describe FormulaProperty do
    tc = TestConnection.instance
    let(:no_content_json) { {"id" => "%5D~iZ"} }
    let(:first_page_id) { TestConnection::DB_FIRST_PAGE_ID }
    let(:property_cache_first) { PropertyCache.new base_type: :page, page_id: first_page_id }

    context "Database property" do
      context "created by new" do
        let(:target) { FormulaProperty.new "fp", base_type: :database, formula: "today()" }
        it_behaves_like :has_name_as, "fp"
        context "create query" do
          subject { query.filter }
          [
            [
              "date",
              Date.new(2022, 2, 12),
              "2022-02-12",
              "2022-02-12T00:00:00+09:00",
              "2022-02-12T23:59:59+09:00",
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
              it_behaves_like :filter_test, FormulaProperty, %w[before on_or_after], value: d, value_str: dss,
                              another_type: "date"
              it_behaves_like :filter_test, FormulaProperty, %w[after on_or_before], value: d, value_str: des,
                              another_type: "date"
              if title == "time"
                it_behaves_like :filter_test, FormulaProperty, %w[equals does_not_equal], value: d, value_str: ds,
                                another_type: "date"
              else
                it_behaves_like :date_equal_filter_test, FormulaProperty, %w[equals does_not_equal], d,
                                another_type: "date"

              end
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
                          value: 100, another_type: "number"
        end
        it { expect(target.formula).to eq({"expression" => "today()"}) }
        it { expect(target.formula_expression).to eq "today()" }
        it_behaves_like :raw_json, :formula, {"expression" => "today()"}

        describe "update_from_json" do
          before { target.update_from_json(tc.read_json("formula_property_object")) }
          it_behaves_like :will_not_update
          it_behaves_like :assert_different_property, :property_values_json
          it_behaves_like :update_property_schema_json, {}
          it { expect(target.formula).to eq({"expression" => "now()"}) }
          it { expect(target.formula_expression).to eq "now()" }
          it_behaves_like :raw_json, :formula, {"expression" => "now()"}
          it_behaves_like :property_schema_json, {"fp" => {"formula" => {"expression" => "now()"}}}
        end

        describe "new_name=" do
          before { target.new_name = "new_name" }
          it_behaves_like :will_update
          it_behaves_like :assert_different_property, :property_values_json
          it_behaves_like :update_property_schema_json, {"fp" => {"name" => "new_name"}}
        end

        describe "remove" do
          before { target.remove }
          it_behaves_like :will_update
          it_behaves_like :assert_different_property, :property_values_json
          it_behaves_like :update_property_schema_json, {"fp" => nil}
        end
      end

      context "created from json" do
        let(:target) { Property.create_from_json "fp", tc.read_json("formula_property_object"), :database }
        it_behaves_like :has_name_as, "fp"
        it_behaves_like :will_not_update
        it_behaves_like :assert_different_property, :property_values_json
        it_behaves_like :update_property_schema_json, {}
        it_behaves_like :raw_json, :formula, {"expression" => "now()"}
      end
    end

    describe "a formula property with parameters" do
      let(:target) { FormulaProperty.new "fp", json: {"type" => "number", "number" => 123} }

      it_behaves_like :property_values_json, {}
      it_behaves_like :will_not_update
      describe "update_from_json" do
        before { target.update_from_json(tc.read_json("retrieve_property_formula")) }
        it_behaves_like :will_not_update
        it_behaves_like :property_values_json, {}
      end
    end

    describe "a formula property from property_item_json" do
      let(:target) { Property.create_from_json "fp", tc.read_json("retrieve_property_formula") }
      it_behaves_like :has_name_as, "fp"
      it_behaves_like :will_not_update
      it_behaves_like :property_values_json, {}
    end

    context "created from json (no content)" do
      let(:target) { Property.create_from_json "fp", no_content_json, :page, property_cache_first }
      it_behaves_like :has_name_as, "fp"
      it_behaves_like :will_not_update
      it { expect(target.contents?).to be_falsey }
      it_behaves_like :assert_different_property, :update_property_schema_json

      # hook property_values_json / formula to retrieve a property item
      it_behaves_like :property_values_json, {}
      it {
        expect(target.formula).to eq({"type" => "date", "date" => {"start" => "2022-09-02T01:14:00.000+00:00",
                                                                   "end" => nil, "time_zone" => nil}})
      }
    end
  end
end
