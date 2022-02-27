# frozen_string_literal: true

module NotionRubyMapping
  RSpec.describe PeopleProperty do
    tc = TestConnection.instance
    p12 = {"type" => "people", "people" => (%w[P1 P2].map { |id| {"object" => "user", "id" => id} })}

    it_behaves_like :filter_test, PeopleProperty, %w[contains does_not_contain], value: "abc"
    it_behaves_like :filter_test, PeopleProperty, %w[is_empty is_not_empty]

    describe "a select property with parameters" do
      let(:target) { PeopleProperty.new "pp", people: %w[P1 P2] }
      it_behaves_like :property_values_json, {"pp" => p12}
      it_behaves_like :will_not_update

      describe "people=" do
        context "a value" do
          before { target.people = "P1" }
          it_behaves_like :property_values_json, {
            "pp" => {
              "type" => "people",
              "people" => [{"object" => "user", "id" => "P1"}],
            },
          }
          it_behaves_like :will_update
        end

        context "an array value" do
          before { target.people = %w[P1 P2] }
          it_behaves_like :property_values_json, {"pp" => p12}
          it_behaves_like :will_update
        end
      end

      describe "update_from_json" do
        before { target.update_from_json(tc.read_json("people_property_item")) }
        it_behaves_like :will_not_update
        it_behaves_like :property_values_json, {
          "pp" => {
            "type" => "people",
            "people" => [
              {
                "object" => "user",
                "id" => "2200a911-6a96-44bb-bd38-6bfb1e01b9f6",
              },
            ],
          },
        }
      end
    end

    describe "a people property from property_item_json" do
      let(:target) { Property.create_from_json "pp", tc.read_json("people_property_item") }
      it_behaves_like :has_name_as, "pp"
      it_behaves_like :will_not_update
      it_behaves_like :property_values_json, {
        "pp" => {
          "type" => "people",
          "people" => [
            {
              "object" => "user",
              "id" => "2200a911-6a96-44bb-bd38-6bfb1e01b9f6",
            },
          ],
        },
      }
    end
  end
end
