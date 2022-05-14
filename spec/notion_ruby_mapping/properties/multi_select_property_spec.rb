# frozen_string_literal: true

module NotionRubyMapping
  RSpec.describe MultiSelectProperty do
    tc = TestConnection.instance

    context "Database property" do
      context "created by new" do
        let(:target) { MultiSelectProperty.new "msp", base_type: :database }
        it_behaves_like :has_name_as, "msp"
        it_behaves_like :filter_test, MultiSelectProperty,
                        %w[contains does_not_contain], value: "ABC"
        it_behaves_like :filter_test, MultiSelectProperty, %w[is_empty is_not_empty]
        it_behaves_like :raw_json, :multi_select, {"options" => []}
        it_behaves_like :property_schema_json, {"msp" => {"multi_select" => {"options" => []}}}

        describe "update_from_json" do
          before { target.update_from_json(tc.read_json("multi_select_property_object")) }
          it_behaves_like :will_not_update
          it_behaves_like :assert_different_property, :property_values_json
          it_behaves_like :update_property_schema_json, {}
          it_behaves_like :raw_json, :multi_select, {
            "options" => [
              {
                "color" => "yellow",
                "id" => "2a0eeeee-b3fd-4072-96a9-865f67cfa6ff",
                "name" => "Multi Select 1",
              },
              {
                "color" => "default",
                "id" => "5f554552-b77a-474b-b5c7-4ae819966e32",
                "name" => "Multi Select 2",
              },
              {
                "color" => "red",
                "id" => "d4bc3d6e-a6e1-4d57-af66-d8ecbbda1dd3",
                "name" => "multi_select",
              },
            ],
          }
        end

        describe "multi_select_options=" do
          before { target.add_multi_select_option name: "Multi Select 4", color: "orange" }
          it_behaves_like :will_update
          it_behaves_like :assert_different_property, :property_values_json
          it_behaves_like :update_property_schema_json, {
            "msp" => {
              "multi_select" => {
                "options" => [
                  {
                    "name" => "Multi Select 4",
                    "color" => "orange",
                  },
                ],
              },
            },
          }
          it_behaves_like :property_schema_json, {
            "msp" => {
              "multi_select" => {
                "options" => [
                  {
                    "name" => "Multi Select 4",
                    "color" => "orange",
                  },
                ],
              },
            },
          }
        end

        describe "new_name=" do
          before { target.new_name = "new_name" }
          it_behaves_like :will_update
          it_behaves_like :assert_different_property, :property_values_json
          it_behaves_like :update_property_schema_json, {"msp" => {"name" => "new_name"}}
        end

        describe "remove" do
          before { target.remove }
          it_behaves_like :will_update
          it_behaves_like :assert_different_property, :property_values_json
          it_behaves_like :update_property_schema_json, {"msp" => nil}
        end
      end

      context "created from json" do
        let(:target) { Property.create_from_json "msp", tc.read_json("multi_select_property_object"), :database }
        it_behaves_like :has_name_as, "msp"
        it_behaves_like :will_not_update
        it_behaves_like :assert_different_property, :property_values_json
        it_behaves_like :update_property_schema_json, {}
        it {
          expect(target.multi_select_names).to eq [
            "Multi Select 1",
            "Multi Select 2",
            "multi_select",
          ]
        }
        it_behaves_like :raw_json, :multi_select, {
          "options" => [
            {
              "color" => "yellow",
              "id" => "2a0eeeee-b3fd-4072-96a9-865f67cfa6ff",
              "name" => "Multi Select 1",
            },
            {
              "color" => "default",
              "id" => "5f554552-b77a-474b-b5c7-4ae819966e32",
              "name" => "Multi Select 2",
            },
            {
              "color" => "red",
              "id" => "d4bc3d6e-a6e1-4d57-af66-d8ecbbda1dd3",
              "name" => "multi_select",
            },
          ],
        }
      end
    end

    context "Page property" do
      context "created by new" do
        let(:target) { MultiSelectProperty.new "msp", multi_select: "Multi Select 2" }

        it_behaves_like :property_values_json, {
          "msp" => {
            "type" => "multi_select",
            "multi_select" => [
              {"name" => "Multi Select 2"},
            ],
          },
        }
        it_behaves_like :will_not_update
        it_behaves_like :assert_different_property, :update_property_schema_json
        it_behaves_like :assert_different_property, :property_schema_json

        describe "multi_select=" do
          before { target.multi_select = "Multi Select 3" }
          it_behaves_like :property_values_json, {
            "msp" => {
              "type" => "multi_select",
              "multi_select" => [
                {"name" => "Multi Select 3"},
              ],
            },
          }
          it_behaves_like :will_update
          it_behaves_like :assert_different_property, :update_property_schema_json
          it_behaves_like :assert_different_property, :property_schema_json
        end

        describe "update_from_json" do
          before { target.update_from_json(tc.read_json("multi_select_property_item")) }
          it_behaves_like :will_not_update
          it_behaves_like :property_values_json, {
            "msp" => {
              "multi_select" => [
                {
                  "color" => "default",
                  "id" => "5f554552-b77a-474b-b5c7-4ae819966e32",
                  "name" => "Multi Select 2",
                },
                {
                  "color" => "yellow",
                  "id" => "2a0eeeee-b3fd-4072-96a9-865f67cfa6ff",
                  "name" => "Multi Select 1",
                },
              ],
              "type" => "multi_select",
            },
          }
          it_behaves_like :assert_different_property, :update_property_schema_json
          it_behaves_like :assert_different_property, :property_schema_json
        end
      end

      context "created from json" do
        let(:target) { Property.create_from_json "msp", tc.read_json("multi_select_property_item") }
        it_behaves_like :has_name_as, "msp"
        it_behaves_like :will_not_update
        it_behaves_like :property_values_json, {
          "msp" => {
            "multi_select" => [
              {
                "color" => "default",
                "id" => "5f554552-b77a-474b-b5c7-4ae819966e32",
                "name" => "Multi Select 2",
              },
              {
                "color" => "yellow",
                "id" => "2a0eeeee-b3fd-4072-96a9-865f67cfa6ff",
                "name" => "Multi Select 1",
              },
            ],
            "type" => "multi_select",
          },
        }
        it_behaves_like :assert_different_property, :update_property_schema_json
        it_behaves_like :assert_different_property, :property_schema_json
      end
    end
  end
end
