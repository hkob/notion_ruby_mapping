# frozen_string_literal: true

module NotionRubyMapping
  RSpec.describe RollupProperty do
    tc = TestConnection.instance

    context "Database property" do
      context "created by new" do
        let(:target) { RollupProperty.new "rp", base_type: :database }
        it_behaves_like :has_name_as, "rp"
        it_behaves_like :raw_json, :rollup, {}
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
                          %w[equals does_not_equal greater_than less_than greater_than_or_equal_to
                             less_than_or_equal_to],
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

        describe "update_from_json" do
          before { target.update_from_json(tc.read_json("rollup_property_object")) }
          it_behaves_like :will_not_update
          it_behaves_like :assert_different_property, :property_values_json
          it_behaves_like :update_property_schema_json, {}
          it_behaves_like :raw_json, :rollup, {
            "function" => "show_original",
            "relation_property_id" => "<nJT",
            "relation_property_name" => "RelationTitle",
            "rollup_property_id" => ":>Fq",
            "rollup_property_name" => "Tags",
          }
          it_behaves_like :property_schema_json, {"rp" => {"rollup" => {
            "function" => "show_original",
            "relation_property_name" => "RelationTitle",
            "rollup_property_name" => "Tags",
          }}}
        end

        describe "new_name=" do
          before { target.new_name = "new_name" }
          it_behaves_like :will_update
          it_behaves_like :assert_different_property, :property_values_json
          it_behaves_like :update_property_schema_json, {"rp" => {"name" => "new_name"}}
        end

        describe "remove" do
          before { target.remove }
          it_behaves_like :will_update
          it_behaves_like :assert_different_property, :property_values_json
          it_behaves_like :update_property_schema_json, {"rp" => nil}
        end

      end

      context "created from json" do
        let(:target) { Property.create_from_json "rp", tc.read_json("rollup_property_object"), :database }
        it_behaves_like :has_name_as, "rp"
        it_behaves_like :will_not_update
        it_behaves_like :assert_different_property, :property_values_json
        it_behaves_like :update_property_schema_json, {}
        it_behaves_like :raw_json, :rollup, {
          "function" => "show_original",
          "relation_property_id" => "<nJT",
          "relation_property_name" => "RelationTitle",
          "rollup_property_id" => ":>Fq",
          "rollup_property_name" => "Tags",
        }
        describe "relation_property_name" do
          it { expect(target.relation_property_name).to eq "RelationTitle" }
          context "relation_property_name=" do
            before { target.relation_property_name = "new RelationTitle" }
            it { expect(target.relation_property_name).to eq "new RelationTitle" }
          end
        end

        describe "rollup_property_name" do
          it { expect(target.rollup_property_name).to eq "Tags" }
          context "rollup_property_name=" do
            before { target.rollup_property_name = "new Tags" }
            it { expect(target.rollup_property_name).to eq "new Tags" }
          end
        end

        describe "function" do
          it { expect(target.function).to eq "show_original" }
          context "function =" do
            before { target.function  = "average" }
            it { expect(target.function).to eq "average" }
          end
        end
      end
    end

    context "Page property" do
      context "created by new" do
        let(:target) { RollupProperty.new "rp", json: {"type" => "number", "number" => 123} }
        it_behaves_like :property_values_json, {}
        it_behaves_like :will_not_update
        it_behaves_like :assert_different_property, :update_property_schema_json
        it_behaves_like :assert_different_property, :property_schema_json

        describe "update_from_json" do
          before { target.update_from_json(tc.read_json("rollup_property_item")) }
          it_behaves_like :will_not_update
          it_behaves_like :property_values_json, {}
          it_behaves_like :assert_different_property, :update_property_schema_json
          it_behaves_like :assert_different_property, :property_schema_json
        end
      end

      context "created from json" do
        let(:target) { Property.create_from_json "rp", tc.read_json("rollup_property_item") }
        it_behaves_like :has_name_as, "rp"
        it_behaves_like :will_not_update
        it_behaves_like :property_values_json, {}
        it_behaves_like :assert_different_property, :update_property_schema_json
        it_behaves_like :assert_different_property, :property_schema_json
      end
    end
  end
end
