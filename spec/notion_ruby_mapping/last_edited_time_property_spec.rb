# frozen_string_literal: true

module NotionRubyMapping
  RSpec.describe LastEditedTimeProperty do
    tc = TestConnection.instance

    context "Database property" do
      context "created by new" do
        let(:target) { LastEditedTimeProperty.new "letp", base_type: :database }
        it_behaves_like :has_name_as, "letp"
        it_behaves_like :raw_json, :last_edited_time, {}

        describe "update_from_json" do
          before { target.update_from_json(tc.read_json("last_edited_time_property_object")) }
          it_behaves_like :will_not_update
          it_behaves_like :assert_different_property, :property_values_json
          it_behaves_like :update_property_schema_json, {}
          it_behaves_like :raw_json, :last_edited_time, {}
          it_behaves_like :property_schema_json, {"letp" => {"last_edited_time" => {}}}
        end

        describe "new_name=" do
          before { target.new_name = "new_name" }
          it_behaves_like :will_update
          it_behaves_like :assert_different_property, :property_values_json
          it_behaves_like :update_property_schema_json, {"letp" => {"name" => "new_name"}}
        end

        describe "remove" do
          before { target.remove }
          it_behaves_like :will_update
          it_behaves_like :assert_different_property, :property_values_json
          it_behaves_like :update_property_schema_json, {"letp" => nil}
        end
      end

      context "created from json" do
        let(:target) { Property.create_from_json "letp", tc.read_json("last_edited_time_property_object"), :database }
        it_behaves_like :has_name_as, "letp"
        it_behaves_like :will_not_update
        it_behaves_like :assert_different_property, :property_values_json
        it_behaves_like :update_property_schema_json, {}
        it_behaves_like :raw_json, :last_edited_time, {}
      end
    end

    context "Page property" do
      context "created by new" do
        let(:target) { LastEditedTimeProperty.new "letp", json: "2022-02-06T21:29:00.000Z" }
        it_behaves_like :property_values_json, {}
        it_behaves_like :will_not_update
        it { expect(target.last_edited_time).to eq "2022-02-06T21:29:00.000Z" }
        it_behaves_like :assert_different_property, :update_property_schema_json

        describe "update_from_json" do
          before { target.update_from_json(tc.read_json("last_edited_time_property_item")) }
          it_behaves_like :will_not_update
          it_behaves_like :property_values_json, {}
          it { expect(target.last_edited_time).to eq "2022-03-12T06:51:00.000Z" }
          it_behaves_like :assert_different_property, :update_property_schema_json
        end
      end

      context "created from json" do
        let(:target) { Property.create_from_json "letp", tc.read_json("last_edited_time_property_item") }
        it_behaves_like :has_name_as, "letp"
        it_behaves_like :will_not_update
        it_behaves_like :property_values_json, {}
        it { expect(target.last_edited_time).to eq "2022-03-12T06:51:00.000Z" }
        it_behaves_like :assert_different_property, :update_property_schema_json
      end
    end
  end
end
