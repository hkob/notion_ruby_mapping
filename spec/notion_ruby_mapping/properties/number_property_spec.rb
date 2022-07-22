# frozen_string_literal: true

module NotionRubyMapping
  RSpec.describe NumberProperty do
    tc = TestConnection.instance
    let(:no_content_json) { {"id" => "swq%5C"} }
    let(:first_page_id) { TestConnection::DB_FIRST_PAGE_ID }
    let(:property_cache_first) { PropertyCache.new base_type: :page, page_id: first_page_id }

    context "Database property" do
      context "created by new" do
        let(:target) { NumberProperty.new "np", base_type: :database, format: "yen" }
        it_behaves_like :has_name_as, "np"
        it { expect(target.format).to eq "yen" }
        it_behaves_like :filter_test, NumberProperty,
                        %w[equals does_not_equal greater_than less_than greater_than_or_equal_to less_than_or_equal_to],
                        value: 100
        it_behaves_like :filter_test, NumberProperty, %w[is_empty is_not_empty]
        it_behaves_like :raw_json, :number, {"format" => "yen"}
        it_behaves_like :property_schema_json, {"np" => {"number" => {"format" => "yen"}}}

        describe "update_from_json" do
          before { target.update_from_json(tc.read_json("number_property_object")) }
          it_behaves_like :will_not_update
          it_behaves_like :assert_different_property, :property_values_json
          it_behaves_like :update_property_schema_json, {}
          it_behaves_like :raw_json, :number, {
            "format" => "number_with_commas",
          }
        end

        describe "format=" do
          before { target.format = "percent" }
          it_behaves_like :will_update
          it_behaves_like :assert_different_property, :property_values_json
          it_behaves_like :update_property_schema_json, {"np" => {"number" => {"format" => "percent"}}}
        end

        describe "new_name=" do
          before { target.new_name = "new_name" }
          it_behaves_like :will_update
          it_behaves_like :assert_different_property, :property_values_json
          it_behaves_like :update_property_schema_json, {"np" => {"name" => "new_name"}}
        end

        describe "remove" do
          before { target.remove }
          it_behaves_like :will_update
          it_behaves_like :assert_different_property, :property_values_json
          it_behaves_like :update_property_schema_json, {"np" => nil}
        end
      end

      context "created from json" do
        let(:target) { Property.create_from_json "np", tc.read_json("number_property_object"), :database }
        it_behaves_like :has_name_as, "np"
        it_behaves_like :will_not_update
        it_behaves_like :assert_different_property, :property_values_json
        it_behaves_like :update_property_schema_json, {}
        it { expect(target.format).to eq "number_with_commas" }
        it_behaves_like :raw_json, :number, {
          "format" => "number_with_commas",
        }
      end
    end

    context "Page property" do
      context "created by new" do
        let(:target) { NumberProperty.new "np", json: 3.14 }

        it_behaves_like :property_values_json, {"np" => {"type" => "number", "number" => 3.14}}
        it_behaves_like :will_not_update
        it_behaves_like :assert_different_property, :update_property_schema_json
        it_behaves_like :assert_different_property, :property_schema_json

        describe "number=" do
          before { target.number = 2022 }
          it_behaves_like :property_values_json, {"np" => {"type" => "number", "number" => 2022}}
          it_behaves_like :will_update
          it_behaves_like :assert_different_property, :update_property_schema_json
          it_behaves_like :assert_different_property, :property_schema_json
        end

        describe "update_from_json" do
          before { target.update_from_json(tc.read_json("retrieve_property_number")) }
          it_behaves_like :will_not_update
          it_behaves_like :property_values_json, {"np" => {"type" => "number", "number" => 1.41421356}}
          it_behaves_like :assert_different_property, :update_property_schema_json
          it_behaves_like :assert_different_property, :property_schema_json
        end
      end

      context "created from json" do
        let(:target) { Property.create_from_json "np", tc.read_json("retrieve_property_number") }
        it_behaves_like :has_name_as, "np"
        it_behaves_like :will_not_update
        it_behaves_like :property_values_json, {"np" => {"type" => "number", "number" => 1.41421356}}
        it_behaves_like :assert_different_property, :update_property_schema_json
        it_behaves_like :assert_different_property, :property_schema_json
      end

      context "created from json (no content)" do
        let(:target) { Property.create_from_json "np", no_content_json, :page, property_cache_first }
        it_behaves_like :has_name_as, "np"
        it_behaves_like :will_not_update
        it { expect(target.contents?).to be_falsey }
        it_behaves_like :assert_different_property, :update_property_schema_json

        # hook property_values_json / created_by to retrieve a property item
        it_behaves_like :property_values_json, {"np" => {"type" => "number", "number" => 1.41421356}}
        it { expect(target.number).to eq 1.41421356 }
      end
    end
  end
end
