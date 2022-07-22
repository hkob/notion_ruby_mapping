# frozen_string_literal: true

module NotionRubyMapping
  RSpec.describe LastEditedByProperty do
    tc = TestConnection.instance
    let(:no_content_json) { {"id" => "LQGa"} }
    let(:first_page_id) { TestConnection::DB_FIRST_PAGE_ID }
    let(:property_cache_first) { PropertyCache.new base_type: :page, page_id: first_page_id }

    context "Database property" do
      context "last_edited by new" do
        let(:target) { LastEditedByProperty.new "lebp", base_type: :database }
        it_behaves_like :has_name_as, "lebp"
        it_behaves_like :raw_json, :last_edited_by, {}

        describe "update_from_json" do
          before { target.update_from_json(tc.read_json("last_edited_by_property_object")) }
          it_behaves_like :will_not_update
          it_behaves_like :assert_different_property, :property_values_json
          it_behaves_like :update_property_schema_json, {}
          it_behaves_like :raw_json, :last_edited_by, {}
          it_behaves_like :property_schema_json, {"lebp" => {"last_edited_by" => {}}}
        end

        describe "new_name=" do
          before { target.new_name = "new_name" }
          it_behaves_like :will_update
          it_behaves_like :assert_different_property, :property_values_json
          it_behaves_like :update_property_schema_json, {"lebp" => {"name" => "new_name"}}
        end

        describe "remove" do
          before { target.remove }
          it_behaves_like :will_update
          it_behaves_like :assert_different_property, :property_values_json
          it_behaves_like :update_property_schema_json, {"lebp" => nil}
        end
      end

      context "last_edited from json" do
        let(:target) { Property.create_from_json "lebp", tc.read_json("last_edited_by_property_object"), :database }
        it_behaves_like :has_name_as, "lebp"
        it_behaves_like :will_not_update
        it_behaves_like :assert_different_property, :property_values_json
        it_behaves_like :update_property_schema_json, {}
        it_behaves_like :raw_json, :last_edited_by, {}
      end
    end

    context "Page property" do
      context "last_edited by new" do
        let(:target) { LastEditedByProperty.new "lebp", user_id: "user_id" }
        it_behaves_like :property_values_json, {}
        it_behaves_like :will_not_update
        it { expect(target.last_edited_by.user_id).to eq "user_id" }
        it_behaves_like :assert_different_property, :update_property_schema_json

        describe "update_from_json" do
          before { target.update_from_json(tc.read_json("retrieve_property_last_edited_by")) }
          it_behaves_like :will_not_update
          it_behaves_like :property_values_json, {}
          it { expect(target.last_edited_by.name).to eq "Hiroyuki KOBAYASHI" }
          it_behaves_like :assert_different_property, :update_property_schema_json
        end
      end

      context "created from json" do
        let(:target) { Property.create_from_json "lebp", tc.read_json("retrieve_property_last_edited_by") }
        it_behaves_like :has_name_as, "lebp"
        it_behaves_like :will_not_update
        it_behaves_like :property_values_json, {}
        it { expect(target.last_edited_by.name).to eq "Hiroyuki KOBAYASHI" }
        it_behaves_like :assert_different_property, :update_property_schema_json
      end
    end

    context "created from json (no content)" do
      let(:target) { Property.create_from_json "lebp", no_content_json, :page, property_cache_first }
      it_behaves_like :has_name_as, "lebp"
      it_behaves_like :will_not_update
      it { expect(target.contents?).to be_falsey }
      it_behaves_like :assert_different_property, :update_property_schema_json

      # hook property_values_json / last_edited_by to retrieve a property item
      it_behaves_like :property_values_json, {}
      it { expect(target.last_edited_by.name).to eq "Hiroyuki KOBAYASHI" }
    end

    describe "a last_edited_by property with parameters" do
      let(:target) { LastEditedByProperty.new "lebp", user_id: "user_id" }

      it_behaves_like :property_values_json, {}
      it_behaves_like :will_not_update
      describe "update_from_json" do
        before { target.update_from_json(tc.read_json("retrieve_property_last_edited_by")) }
        it_behaves_like :will_not_update
        it_behaves_like :property_values_json, {}
      end
    end

    describe "a last_edited_by property from property_item_json" do
      let(:target) { Property.create_from_json "ctp", tc.read_json("retrieve_property_last_edited_by") }
      it_behaves_like :has_name_as, "ctp"
      it_behaves_like :will_not_update
      it_behaves_like :property_values_json, {}
    end
  end
end
