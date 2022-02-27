# frozen_string_literal: true

module NotionRubyMapping
  RSpec.describe RelationProperty do
    tc = TestConnection.instance

    describe "a relation property with parameters" do
      let(:target) { RelationProperty.new "rp", relation: ["page_id"] }

      it_behaves_like :property_values_json, {"rp" => {"type" => "relation", "relation" => [{"id" => "page_id"}]}}
      it_behaves_like :will_not_update

      describe "relation=" do
        before { target.relation = ["new_page_id"] }
        it_behaves_like :property_values_json, {"rp" => {"type" => "relation", "relation" => [{"id" => "new_page_id"}]}}
        it_behaves_like :will_update
      end

      describe "update_from_json" do
        before { target.update_from_json(tc.read_json("relation_property_item")) }
        it_behaves_like :property_values_json, {"rp" => {
          "type" => "relation",
          "relation" => [
            {
              "id" => "860753bb-6d1f-48de-9621-1fa6e0e31f82",
            },
          ],
        }}
      end
    end

    describe "a relation property from property_item_json" do
      let(:target) { Property.create_from_json "rp", tc.read_json("relation_property_item") }
      it_behaves_like :has_name_as, "rp"
      it_behaves_like :will_not_update
      it_behaves_like :property_values_json, {
        "rp" => {
          "type" => "relation",
          "relation" => [
            {
              "id" => "860753bb-6d1f-48de-9621-1fa6e0e31f82",
            },
          ],
        },
      }
    end
  end
end
