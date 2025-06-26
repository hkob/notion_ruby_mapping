# frozen_string_literal: true

module NotionRubyMapping
  RSpec.describe StatusProperty do
    tc = TestConnection.instance
    let(:no_content_json) { {"id" => "Qy~%3E"} }
    let(:status_database_id) { TestConnection::STATUS_DATABASE_ID }
    let(:status_page_id) { TestConnection::STATUS_PAGE_ID }
    let(:property_cache_status) { PropertyCache.new base_type: "page", page_id: status_page_id }

    context "when Database property" do
      status_property_object = {
        "options" => [
          {
            "id" => "33df6183-a55b-4384-9fde-b07bd8ca7b5a",
            "name" => "Not started",
            "color" => "default",
          },
          {
            "id" => "f72c1b31-8799-44d7-b063-1ae923c5be7f",
            "name" => "In progress",
            "color" => "blue",
          },
          {
            "id" => "bAJF",
            "name" => "Implementation",
            "color" => "orange",
          },
          {
            "id" => "A:GG",
            "name" => "Design",
            "color" => "purple",
          },
          {
            "id" => "241374c0-38a6-4f5e-8063-d568c15894d2",
            "name" => "Done",
            "color" => "green",
          },
        ],
        "groups" => [
          {
            "id" => "15bba3f4-7a01-4536-b994-c6f5a87964c5",
            "name" => "To-do",
            "color" => "gray",
            "option_ids" => [
              "33df6183-a55b-4384-9fde-b07bd8ca7b5a",
            ],
          },
          {
            "id" => "51a46edb-2706-403f-b23f-53b76e270058",
            "name" => "In progress",
            "color" => "blue",
            "option_ids" => %w[bAJF A:GG f72c1b31-8799-44d7-b063-1ae923c5be7f],
          },
          {
            "id" => "edbe740f-eb99-482b-b624-10af35b66675",
            "name" => "Complete",
            "color" => "green",
            "option_ids" => [
              "241374c0-38a6-4f5e-8063-d568c15894d2",
            ],
          },
        ],
      }
      context "when created by new" do
        let(:target) { described_class.new "sp", base_type: "database" }

        it_behaves_like "has name as", "sp"
        it_behaves_like "filter test", described_class, %w[equals does_not_equal], value: true
        it_behaves_like "filter test", described_class, %w[is_empty is_not_empty]
        it_behaves_like "raw json", "status", {}
        it_behaves_like "property schema json", {"sp" => {"status" => {}}}

        describe "update_from_json" do
          before { target.update_from_json(tc.read_json("status_property_object")) }

          it_behaves_like "will not update"
          it_behaves_like "assert different property", :property_values_json
          it_behaves_like "update property schema json", {}
          it_behaves_like "raw json", "status", status_property_object
          it_behaves_like "property schema json", {"sp" => {"status" => {}}}
        end

        describe "new_name=" do
          before { target.new_name = "new_name" }

          it_behaves_like "will update"
          it_behaves_like "assert different property", :property_values_json
          it_behaves_like "update property schema json", {"sp" => {"name" => "new_name"}}
        end

        describe "remove" do
          before { target.remove }

          it_behaves_like "will update"
          it_behaves_like "assert different property", :property_values_json
          it_behaves_like "update property schema json", {"sp" => nil}
        end
      end

      context "when created from json" do
        let(:target) { Property.create_from_json "sp", tc.read_json("status_property_object"), "database" }

        it_behaves_like "has name as", "sp"
        it_behaves_like "will not update"
        it_behaves_like "assert different property", :property_values_json
        it_behaves_like "update property schema json", {}
        it_behaves_like "raw json", "status", status_property_object
      end
    end

    context "when Page property" do
      retrieve_status = {
        "sp" => {
          "type" => "status",
          "status" => {
            "color" => "blue",
            "id" => "f72c1b31-8799-44d7-b063-1ae923c5be7f",
            "name" => "In progress",
          },
        },
      }
      context "when created by new" do
        let(:target) { described_class.new "sp" }

        it_behaves_like "property values json", {"sp" => {"status" => {}, "type" => "status"}}
        it_behaves_like "will not update"
        it_behaves_like "assert different property", :update_property_schema_json

        describe "status=" do
          before { target.status = "Design" }

          it_behaves_like "property values json", {
            "sp" => {
              "type" => "status",
              "status" => {"name" => "Design"},
            },
          }
          it_behaves_like "will update"
          it_behaves_like "assert different property", :update_property_schema_json
          it_behaves_like "assert different property", :property_schema_json
        end

        describe "update_from_json" do
          before { target.update_from_json(tc.read_json("retrieve_property_status")) }

          it_behaves_like "will not update"
          it_behaves_like "property values json", retrieve_status
          it_behaves_like "assert different property", :update_property_schema_json
        end
      end

      context "when created from json" do
        let(:target) { Property.create_from_json "sp", tc.read_json("retrieve_property_status") }

        it_behaves_like "has name as", "sp"
        it_behaves_like "will not update"
        it_behaves_like "property values json", retrieve_status
        it_behaves_like "assert different property", :update_property_schema_json
      end

      context "when created from json (no content)" do
        let(:target) { Property.create_from_json "sp", no_content_json, "page", property_cache_status }

        it_behaves_like "has name as", "sp"
        it_behaves_like "will not update"
        it { expect(target).not_to be_contents }

        it_behaves_like "assert different property", :update_property_schema_json

        # hook property_values_json / status to retrieve a property item
        it_behaves_like "property values json", retrieve_status
      end
    end
  end
end
