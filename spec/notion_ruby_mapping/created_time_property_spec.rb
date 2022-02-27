# frozen_string_literal: true

module NotionRubyMapping
  RSpec.describe CreatedTimeProperty do
    tc = TestConnection.instance

    describe "a created_time property with parameters" do
      let(:target) { CreatedTimeProperty.new "ctp", created_time: "2022-02-07T21:29:00.000Z" }

      it_behaves_like :property_values_json, {}
      it_behaves_like :will_not_update
      describe "update_from_json" do
        before { target.update_from_json(tc.read_json("created_time_property_item")) }
        it_behaves_like :will_not_update
        it { expect(target.created_time).to eq "2022-02-07T21:29:00.000Z" }
      end
    end

    describe "a created_time property from property_item_json" do
      let(:target) { Property.create_from_json "ctp", tc.read_json("created_time_property_item") }
      it_behaves_like :has_name_as, "ctp"
      it_behaves_like :will_not_update
      it_behaves_like :property_values_json, {}
    end
  end
end
