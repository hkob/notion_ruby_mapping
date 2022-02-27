# frozen_string_literal: true

module NotionRubyMapping
  RSpec.describe LastEditedByProperty do
    tc = TestConnection.instance

    describe "a created_by property with parameters" do
      let(:target) { LastEditedByProperty.new "lebp", user_id: "user_id" }

      it_behaves_like :property_values_json, {}
      it_behaves_like :will_not_update

      describe "update_from_json" do
        before { target.update_from_json(tc.read_json("last_edited_by_property_item")) }
        it { expect(target.user.name).to eq "Hiroyuki KOBAYASHI" }
      end
    end

    describe "a created_by property from property_item_json" do
      let(:target) { Property.create_from_json "lebp", tc.read_json("last_edited_by_property_item") }
      it_behaves_like :has_name_as, "lebp"
      it_behaves_like :will_not_update
      it_behaves_like :property_values_json, {}
    end
  end
end
