# frozen_string_literal: true

module NotionRubyMapping
  RSpec.describe ButtonProperty do
    tc = TestConnection.instance
    let(:button_page_id) { TestConnection::BUTTON_PAGE_ID }
    let(:property_cache_first) { PropertyCache.new base_type: "page", page_id: button_page_id }

    correct = {"Buttons" => {"type" => "button", "button" => {}}}

    context "Database property" do
      context "created from json" do
        let(:target) { Property.create_from_json "Buttons", tc.read_json("button_property_object"), "database" }

        it_behaves_like "has name as", "Buttons"
        it_behaves_like "will not update"
        it_behaves_like "assert different property", :property_values_json
        it_behaves_like "update property schema json", {}
        it_behaves_like "raw json", "button", {}
      end
    end

    context "DataSource property" do
      context "created from json" do
        let(:target) { Property.create_from_json "Buttons", tc.read_json("button_property_object"), "data_source" }

        it_behaves_like "has name as", "Buttons"
        it_behaves_like "will not update"
        it_behaves_like "assert different property", :property_values_json
        it_behaves_like "update property schema json", {}
        it_behaves_like "raw json", "button", {}
      end
    end

    context "Page property" do
      context "created from json" do
        let(:target) { Property.create_from_json "Buttons", tc.read_json("retrieve_property_button") }

        it_behaves_like "has name as", "Buttons"
        it_behaves_like "will not update"
        it_behaves_like "property values json", correct
        it_behaves_like "assert different property", :update_property_schema_json
        it_behaves_like "assert different property", :property_schema_json
      end
    end
  end
end
