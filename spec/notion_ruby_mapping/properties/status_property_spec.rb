# frozen_string_literal: true

module NotionRubyMapping
  RSpec.describe StatusProperty do
    tc = TestConnection.instance
    let(:no_content_json) { {"id" => "Qy~%3E"} }
    let(:status_database_id) { TestConnection::STATUS_DATABASE_ID }
    let(:status_page_id) { TestConnection::STATUS_PAGE_ID }
    let(:property_cache_status) { PropertyCache.new base_type: :page, page_id: status_page_id }

    context "Database property" do
      context "created by new" do
        let(:target) { StatusProperty.new "sp", base_type: :database }
        it_behaves_like :has_name_as, "sp"
        it_behaves_like :raw_json, :status, {}


        describe "update_from_json" do
          before { target.update_from_json(tc.read_json("status_property_object")) }
          it_behaves_like :will_not_update
          it_behaves_like :assert_different_property, :property_values_json
          it_behaves_like :update_property_schema_json, {}
          it_behaves_like :raw_json, :status, {}
          it_behaves_like :property_schema_json, {"sp" => {"status" => {}}}
        end

        describe "new_name=" do
          before { target.new_name = "new_name" }
          it_behaves_like :will_update
          it_behaves_like :assert_different_property, :property_values_json
          it_behaves_like :update_property_schema_json, {"sp" => {"name" => "new_name"}}
        end

        describe "remove" do
          before { target.remove }
          it_behaves_like :will_update
          it_behaves_like :assert_different_property, :property_values_json
          it_behaves_like :update_property_schema_json, {"sp" => nil}
        end
      end

      context "created from json" do
        let(:target) { Property.create_from_json "sp", tc.read_json("status_property_object"), :database }
        it_behaves_like :has_name_as, "sp"
        it_behaves_like :will_not_update
        it_behaves_like :assert_different_property, :property_values_json
        it_behaves_like :update_property_schema_json, {}
        it_behaves_like :raw_json, :status, {}
      end
    end

    context "Page property" do
      context "created by new" do
        let(:target) { StatusProperty.new "sp" }
        it_behaves_like :property_values_json, {}
        it_behaves_like :will_not_update
        it_behaves_like :assert_different_property, :update_property_schema_json

        describe "update_from_json" do
          before { target.update_from_json(tc.read_json("retrieve_property_status")) }
          it_behaves_like :will_not_update
          it_behaves_like :property_values_json, {}
          it_behaves_like :assert_different_property, :update_property_schema_json
        end
      end

      context "created from json" do
        let(:target) { Property.create_from_json "sp", tc.read_json("retrieve_property_status") }
        it_behaves_like :has_name_as, "sp"
        it_behaves_like :will_not_update
        it_behaves_like :property_values_json, {}
        it_behaves_like :assert_different_property, :update_property_schema_json
      end
    end

    context "created from json (no content)" do
      let(:target) { Property.create_from_json "sp", no_content_json, :page, property_cache_status }
      it_behaves_like :has_name_as, "sp"
      it_behaves_like :will_not_update
      it { expect(target.contents?).to be_falsey }
      it_behaves_like :assert_different_property, :update_property_schema_json

      # hook property_values_json / status to retrieve a property item
      it_behaves_like :property_values_json, {}
    end

    describe "a status property from property_item_json" do
      let(:target) { Property.create_from_json "sp", tc.read_json("status_property_object") }
      it_behaves_like :has_name_as, "sp"
      it_behaves_like :will_not_update
      it_behaves_like :property_values_json, {}
    end
  end
end
