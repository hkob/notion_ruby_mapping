# frozen_string_literal: true

module NotionRubyMapping
  RSpec.describe CheckboxProperty do
    tc = TestConnection.instance
    let(:property) { CheckboxProperty.new "cp" }

    it_behaves_like :filter_test, CheckboxProperty, %w[equals does_not_equal], value: true

    describe "a checkbox_property from property_item_json" do
      let(:target) { Property.create_from_json "cp", tc.read_json("checkbox_property_item") }
      it_behaves_like :has_name_as, "cp"
      it_behaves_like :will_not_update
      it_behaves_like :property_values_json, {
        "cp" => {
          "type" => "checkbox",
          "checkbox" => true,
        },
      }
      describe "update_from_json" do
        before { target.update_from_json(tc.read_json("checkbox_property_item")) }
        it_behaves_like :property_values_json, {
          "cp" => {
            "type" => "checkbox",
            "checkbox" => true,
          },
        }
      end
    end
  end
end
