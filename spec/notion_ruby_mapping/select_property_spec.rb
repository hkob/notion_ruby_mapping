# frozen_string_literal: true

module NotionRubyMapping
  RSpec.describe SelectProperty do
    tc = TestConnection.instance

    let(:property) { SelectProperty.new "sp" }
    it_behaves_like :filter_test, SelectProperty, %w[equals does_not_equal], value: true
    it_behaves_like :filter_test, SelectProperty, %w[is_empty is_not_empty]

    describe "a select property with parameters" do
      let(:target) { SelectProperty.new "sp", select: "Select 1" }

      it_behaves_like :property_values_json, {"sp" => {"select" => {"name" => "Select 1"}, "type" => "select"}}
      it_behaves_like :will_not_update

      describe "select=" do
        before { target.select = "Select 2" }
        it_behaves_like :property_values_json, {"sp" => {"select" => {"name" => "Select 2"}, "type" => "select"}}
        it_behaves_like :will_update
      end

      describe "update_from_json" do
        before { target.update_from_json(tc.read_json("select_property_item")) }
        it_behaves_like :will_not_update
        it_behaves_like :property_values_json, {
          "sp" => {
            "type" => "select",
            "select" => {
              "name" => "Select 3",
            },
          },
        }
      end
    end

    describe "a select property from property_item_json" do
      let(:target) { Property.create_from_json "sp", tc.read_json("select_property_item") }
      it_behaves_like :has_name_as, "sp"
      it_behaves_like :will_not_update
      it_behaves_like :property_values_json, {
        "sp" => {
          "type" => "select",
          "select" => {
            "name" => "Select 3",
          },
        },
      }
    end
  end
end
