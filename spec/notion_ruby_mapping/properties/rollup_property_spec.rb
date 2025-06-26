# frozen_string_literal: true

module NotionRubyMapping
  RSpec.describe RollupProperty do
    tc = TestConnection.instance
    let(:no_content_json) { {id: "STe_"} }
    let(:first_page_id) { TestConnection::DB_FIRST_PAGE_ID }

    context "Database property" do
      context "when created by new" do
        let(:target) { described_class.new "rp", base_type: "database" }

        it_behaves_like "has name as", "rp"
        it_behaves_like "raw json", "rollup", {}
        context "when create query" do
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
            context "with on parameter #{title}" do
              it_behaves_like "filter test", described_class, %w[before on_or_after], value: d, value_str: dss
              it_behaves_like "filter test", described_class, %w[after on_or_before], value: d, value_str: des
              if title == "time"
                it_behaves_like "filter test", described_class, %w[equals does_not_equal], value: d, value_str: ds
              else
                it_behaves_like "date equal filter test", described_class, %w[equals does_not_equal], d
              end
            end
          end

          it_behaves_like "filter test", NumberProperty,
                          %w[equals does_not_equal greater_than less_than greater_than_or_equal_to
                             less_than_or_equal_to],
                          value: 100
          %w[any every none].each do |condition|
            context condition do
              it_behaves_like "filter test", described_class,
                              %w[equals does_not_equal contains does_not_contain starts_with ends_with],
                              value: "abc", condition: condition, another_type: "rich_text"
              it_behaves_like "filter test", described_class,
                              %w[equals does_not_equal greater_than less_than greater_than_or_equal_to
                                 less_than_or_equal_to], value: 100, condition: condition, another_type: "number"
              it_behaves_like "filter test", described_class, %w[is_empty is_not_empty],
                              condition: condition, another_type: "number"
              it_behaves_like "filter test", described_class,
                              %w[past_week past_month past_year next_week next_month next_year],
                              value_str: {}, condition: condition, another_type: "date"
            end
          end
        end

        describe "update_from_json" do
          before { target.update_from_json(tc.read_json("rollup_property_object")) }

          it_behaves_like "will not update"
          it_behaves_like "assert different property", :property_values_json
          it_behaves_like "update property schema json", {}
          it_behaves_like "raw json", "rollup", {
            "function" => "show_original",
            "relation_property_id" => "<nJT",
            "relation_property_name" => "RelationTitle",
            "rollup_property_id" => ":>Fq",
            "rollup_property_name" => "Tags",
          }
          it_behaves_like "property schema json", {"rp" => {"rollup" => {
            "function" => "show_original",
            "relation_property_name" => "RelationTitle",
            "rollup_property_name" => "Tags",
          }}}
        end

        describe "new_name=" do
          before { target.new_name = "new_name" }

          it_behaves_like "will update"
          it_behaves_like "assert different property", :property_values_json
          it_behaves_like "update property schema json", {"rp" => {"name" => "new_name"}}
        end

        describe "remove" do
          before { target.remove }

          it_behaves_like "will update"
          it_behaves_like "assert different property", :property_values_json
          it_behaves_like "update property schema json", {"rp" => nil}
        end
      end

      context "when created from json" do
        let(:target) { Property.create_from_json "rp", tc.read_json("rollup_property_object"), "database" }

        it_behaves_like "has name as", "rp"
        it_behaves_like "will not update"
        it_behaves_like "assert different property", :property_values_json
        it_behaves_like "update property schema json", {}
        it_behaves_like "raw json", "rollup", {
          "function" => "show_original",
          "relation_property_id" => "<nJT",
          "relation_property_name" => "RelationTitle",
          "rollup_property_id" => ":>Fq",
          "rollup_property_name" => "Tags",
        }
        describe "relation_property_name" do
          it { expect(target.relation_property_name).to eq "RelationTitle" }

          context "when relation_property_name=" do
            before { target.relation_property_name = "new RelationTitle" }

            it { expect(target.relation_property_name).to eq "new RelationTitle" }
          end
        end

        describe "rollup_property_name" do
          it { expect(target.rollup_property_name).to eq "Tags" }

          context "when rollup_property_name=" do
            before { target.rollup_property_name = "new Tags" }

            it { expect(target.rollup_property_name).to eq "new Tags" }
          end
        end

        describe "function" do
          it { expect(target.function).to eq "show_original" }

          context "when function =" do
            before { target.function = "average" }

            it { expect(target.function).to eq "average" }
          end
        end
      end
    end

    context "when Page property" do
      context "when created by new" do
        let(:target) { described_class.new "rp", json: {"type" => "number", "number" => 123} }

        it_behaves_like "property values json", {}
        it_behaves_like "will not update"
        it_behaves_like "assert different property", :update_property_schema_json
        it_behaves_like "assert different property", :property_schema_json

        describe "update_from_json" do
          before { target.update_from_json(tc.read_json("retrieve_property_rollup")) }

          it_behaves_like "will not update"
          it_behaves_like "property values json", {}
          it_behaves_like "assert different property", :update_property_schema_json
          it_behaves_like "assert different property", :property_schema_json
        end
      end

      context "when created from json" do
        let(:target) { Property.create_from_json "rp", tc.read_json("retrieve_property_rollup") }

        it_behaves_like "has name as", "rp"
        it_behaves_like "will not update"
        it_behaves_like "property values json", {}
        it_behaves_like "assert different property", :update_property_schema_json
        it_behaves_like "assert different property", :property_schema_json
      end
    end
  end
end
