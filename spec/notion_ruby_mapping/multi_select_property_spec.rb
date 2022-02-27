# frozen_string_literal: true

module NotionRubyMapping
  RSpec.describe MultiSelectProperty do
    tc = TestConnection.instance
    ms12 = {"multi_select" => [{"name" => "MS1"}, {"name" => "MS2"}], "type" => "multi_select"}

    describe "a select property with parameters" do
      let(:target) { MultiSelectProperty.new "msp", multi_select: %w[MS1 MS2] }
      it_behaves_like :property_values_json, {"msp" => ms12}
      it_behaves_like :will_not_update

      describe "multi_select=" do
        context "a value" do
          before { target.multi_select = "MS1" }
          it_behaves_like :property_values_json, {
            "msp" => {
              "type" => "multi_select",
              "multi_select" => [{"name" => "MS1"}],
            },
          }
          it_behaves_like :will_update
        end

        context "an array value" do
          before { target.multi_select = %w[MS1 MS2] }
          it_behaves_like :property_values_json, {"msp" => ms12}
          it_behaves_like :will_update
        end
      end

      describe "update_from_json" do
        before { target.update_from_json(tc.read_json("multi_select_property_item")) }
        it_behaves_like :property_values_json, {
          "msp" => {
            "type" => "multi_select",
            "multi_select" => [
              {
                "name" => "Multi Select 2",
              },
              {
                "name" => "Multi Select 1",
              },
            ],
          },
        }
      end
    end

    describe "a multi_select property from property_item_json" do
      let(:target) { Property.create_from_json "msp", tc.read_json("multi_select_property_item") }
      it_behaves_like :has_name_as, "msp"
      it_behaves_like :will_not_update
      it_behaves_like :property_values_json, {
        "msp" => {
          "type" => "multi_select",
          "multi_select" => [
            {
              "name" => "Multi Select 2",
            },
            {
              "name" => "Multi Select 1",
            },
          ],
        },
      }
    end
  end
end
