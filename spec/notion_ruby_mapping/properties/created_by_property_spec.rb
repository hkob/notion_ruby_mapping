# frozen_string_literal: true

module NotionRubyMapping
  RSpec.describe CreatedByProperty do
    tc = TestConnection.instance
    let(:no_content_json) { {id: "eR%3D~"} }
    let(:first_page_id) { TestConnection::DB_FIRST_PAGE_ID }
    let(:property_cache_first) { PropertyCache.new base_type: :page, page_id: first_page_id }

    context "Database property" do
      context "created by new" do
        let(:target) { CreatedByProperty.new "cbp", base_type: :database }

        it_behaves_like "has name as", :cbp
        it_behaves_like "raw json", :created_by, {}

        describe "update_from_json" do
          before { target.update_from_json(tc.read_json("created_by_property_object")) }

          it_behaves_like "will not update"
          it_behaves_like "assert different property", :property_values_json
          it_behaves_like "update property schema json", {}
          it_behaves_like "raw json", :created_by, {}
          it_behaves_like "property schema json", {cbp: {created_by: {}}}
        end

        describe "new_name=" do
          before { target.new_name = "new_name" }

          it_behaves_like "will update"
          it_behaves_like "assert different property", :property_values_json
          it_behaves_like "update property schema json", {cbp: {name: :new_name}}
        end

        describe "remove" do
          before { target.remove }

          it_behaves_like "will update"
          it_behaves_like "assert different property", :property_values_json
          it_behaves_like "update property schema json", {cbp: nil}
        end
      end

      context "created from json" do
        let(:target) { Property.create_from_json "cbp", tc.read_json("created_by_property_object"), :database }

        it_behaves_like "has name as", :cbp
        it_behaves_like "will not update"
        it_behaves_like "assert different property", :property_values_json
        it_behaves_like "update property schema json", {}
        it_behaves_like "raw json", :created_by, {}
      end
    end

    context "Page property" do
      context "created by new" do
        let(:target) { CreatedByProperty.new "cbp", user_id: "user_id" }

        it_behaves_like "property values json", {}
        it_behaves_like "will not update"
        it { expect(target.created_by.user_id).to eq "user_id" }

        it_behaves_like "assert different property", :update_property_schema_json

        describe "update_from_json" do
          before { target.update_from_json(tc.read_json("retrieve_property_created_by")) }

          it_behaves_like "will not update"
          it_behaves_like "property values json", {}
          it { expect(target.created_by.name).to eq "Hiroyuki KOBAYASHI" }

          it_behaves_like "assert different property", :update_property_schema_json
        end
      end

      context "created from json" do
        let(:target) { Property.create_from_json "cbp", tc.read_json("retrieve_property_created_by") }

        it_behaves_like "has name as", :cbp
        it_behaves_like "will not update"
        it_behaves_like "property values json", {}
        it { expect(target.created_by.name).to eq "Hiroyuki KOBAYASHI" }

        it_behaves_like "assert different property", :update_property_schema_json
      end
    end

    context "created from json (no content)" do
      let(:target) { Property.create_from_json "cbp", no_content_json, :page, property_cache_first }

      it_behaves_like "has name as", :cbp
      it_behaves_like "will not update"
      it { expect(target.contents?).to be_falsey }

      it_behaves_like "assert different property", :update_property_schema_json

      # hook property_values_json / created_by to retrieve a property item
      it_behaves_like "property values json", {}
      it { expect(target.created_by.name).to eq "Hiroyuki KOBAYASHI" }
    end

    describe "a created_by property with parameters" do
      let(:target) { CreatedByProperty.new "ctp", user_id: "user_id" }

      it_behaves_like "property values json", {}
      it_behaves_like "will not update"
      describe "update_from_json" do
        before { target.update_from_json(tc.read_json("retrieve_property_created_by")) }

        it_behaves_like "will not update"
        it_behaves_like "property values json", {}
      end
    end

    describe "a created_by property from property_item_json" do
      let(:target) { Property.create_from_json "ctp", tc.read_json("retrieve_property_created_by") }

      it_behaves_like "has name as", :ctp
      it_behaves_like "will not update"
      it_behaves_like "property values json", {}
    end
  end
end
