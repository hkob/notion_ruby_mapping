# frozen_string_literal: true

module NotionRubyMapping
  RSpec.describe CreatedByProperty do
    tc = TestConnection.instance

    describe "a created_by property with parameters" do
      let(:target) { CreatedByProperty.new "ctp", user_id: "user_id" }

      it_behaves_like :property_values_json, {}
      it_behaves_like :will_not_update
      describe "update_from_json" do
        before { target.update_from_json(tc.read_json("created_by_property_item")) }
        it_behaves_like :will_not_update
        it_behaves_like :property_values_json, {}
      end
    end

    describe "a created_by property from property_item_json" do
      let(:target) { Property.create_from_json "ctp", tc.read_json("created_by_property_item") }
      it_behaves_like :has_name_as, "ctp"
      it_behaves_like :will_not_update
      it_behaves_like :property_values_json, {}
    end
  end
end
