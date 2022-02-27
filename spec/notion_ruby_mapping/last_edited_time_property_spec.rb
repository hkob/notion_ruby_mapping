# frozen_string_literal: true

module NotionRubyMapping
  RSpec.describe LastEditedTimeProperty do
    tc = TestConnection.instance

    describe "a last_edited_time property with parameters" do
      let(:target) { LastEditedTimeProperty.new "letp", last_edited_time: "2022-02-07T21:29:00.000Z" }

      it_behaves_like :property_values_json, {}
      it_behaves_like :will_not_update
      describe "update_from_json" do
        before { target.update_from_json(tc.read_json("last_edited_time_property_item")) }
        it_behaves_like :will_not_update
        it { expect(target.last_edited_time).to eq "2022-03-12T06:51:00.000Z" }
      end
    end

    describe "a last_edited_time property from property_item_json" do
      let(:target) { Property.create_from_json "letp", tc.read_json("last_edited_time_property_item") }
      it_behaves_like :has_name_as, "letp"
      it_behaves_like :will_not_update
      it_behaves_like :property_values_json, {}
    end
  end
end
