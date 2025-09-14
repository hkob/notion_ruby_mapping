# frozen_string_literal: true

module NotionRubyMapping
  RSpec.describe MultiSelectProperty do
    tc = TestConnection.instance
    let(:no_content_json) { {"id" => "Kjx%7D"} }
    let(:first_page_id) { TestConnection::DB_FIRST_PAGE_ID }
    let(:property_cache_first) { PropertyCache.new base_type: "page", page_id: first_page_id }

    context "when Database property" do
      context "when created by new" do
        let(:target) { described_class.new "msp", base_type: "database" }

        it_behaves_like "has name as", "msp"
        it_behaves_like "filter test", described_class,
                        %w[contains does_not_contain], value: "ABC"
        it_behaves_like "filter test", described_class, %w[is_empty is_not_empty]
        it_behaves_like "raw json", "multi_select", {"options" => []}
        it_behaves_like "property schema json", {"msp" => {"multi_select" => {"options" => []}}}

        describe "update_from_json" do
          before { target.update_from_json(tc.read_json("multi_select_property_object")) }

          it_behaves_like "will not update"
          it_behaves_like "assert different property", :property_values_json
          it_behaves_like "raw json", "multi_select", {
            "options" => [
              {
                "color" => "yellow",
                "id" => "2a0eeeee-b3fd-4072-96a9-865f67cfa6ff",
                "name" => "Multi Select 1",
              },
              {
                "color" => "default",
                "id" => "5f554552-b77a-474b-b5c7-4ae819966e32",
                "name" => "Multi Select 2",
              },
              {
                "color" => "red",
                "id" => "d4bc3d6e-a6e1-4d57-af66-d8ecbbda1dd3",
                "name" => "multi_select",
              },
            ],
          }
        end

        describe "multi_select_options=" do
          before { target.add_multi_select_option name: "Multi Select 4", color: "orange" }

          it_behaves_like "will update"
          it_behaves_like "assert different property", :property_values_json
          it_behaves_like "update property schema json", {
            "msp" => {
              "multi_select" => {
                "options" => [
                  {
                    "name" => "Multi Select 4",
                    "color" => "orange",
                  },
                ],
              },
            },
          }
          it_behaves_like "property schema json", {
            "msp" => {
              "multi_select" => {
                "options" => [
                  {
                    "name" => "Multi Select 4",
                    "color" => "orange",
                  },
                ],
              },
            },
          }
        end
      end

      context "when created from json" do
        let(:target) { Property.create_from_json "msp", tc.read_json("multi_select_property_object"), "database" }

        it_behaves_like "has name as", "msp"
        it_behaves_like "will not update"
        it_behaves_like "assert different property", :property_values_json
        it {
          expect(target.multi_select_names).to eq [
            "Multi Select 1",
            "Multi Select 2",
            "multi_select",
          ]
        }

        it_behaves_like "raw json", "multi_select", {
          "options" => [
            {
              "color" => "yellow",
              "id" => "2a0eeeee-b3fd-4072-96a9-865f67cfa6ff",
              "name" => "Multi Select 1",
            },
            {
              "color" => "default",
              "id" => "5f554552-b77a-474b-b5c7-4ae819966e32",
              "name" => "Multi Select 2",
            },
            {
              "color" => "red",
              "id" => "d4bc3d6e-a6e1-4d57-af66-d8ecbbda1dd3",
              "name" => "multi_select",
            },
          ],
        }
      end
    end

    context "when DataSource property" do
      context "when created by new" do
        let(:target) { described_class.new "msp", base_type: "data_source" }

        it_behaves_like "has name as", "msp"
        it_behaves_like "filter test", described_class,
                        %w[contains does_not_contain], value: "ABC"
        it_behaves_like "filter test", described_class, %w[is_empty is_not_empty]
        it_behaves_like "raw json", "multi_select", {"options" => []}
        it_behaves_like "property schema json", {"msp" => {"multi_select" => {"options" => []}}}

        describe "update_from_json" do
          before { target.update_from_json(tc.read_json("multi_select_property_object")) }

          it_behaves_like "will not update"
          it_behaves_like "assert different property", :property_values_json
          it_behaves_like "update property schema json", {}
          it_behaves_like "raw json", "multi_select", {
            "options" => [
              {
                "color" => "yellow",
                "id" => "2a0eeeee-b3fd-4072-96a9-865f67cfa6ff",
                "name" => "Multi Select 1",
              },
              {
                "color" => "default",
                "id" => "5f554552-b77a-474b-b5c7-4ae819966e32",
                "name" => "Multi Select 2",
              },
              {
                "color" => "red",
                "id" => "d4bc3d6e-a6e1-4d57-af66-d8ecbbda1dd3",
                "name" => "multi_select",
              },
            ],
          }
        end

        describe "multi_select_options=" do
          before { target.add_multi_select_option name: "Multi Select 4", color: "orange" }

          it_behaves_like "will update"
          it_behaves_like "assert different property", :property_values_json
          it_behaves_like "update property schema json", {
            "msp" => {
              "multi_select" => {
                "options" => [
                  {
                    "name" => "Multi Select 4",
                    "color" => "orange",
                  },
                ],
              },
            },
          }
          it_behaves_like "property schema json", {
            "msp" => {
              "multi_select" => {
                "options" => [
                  {
                    "name" => "Multi Select 4",
                    "color" => "orange",
                  },
                ],
              },
            },
          }
        end

        describe "new_name=" do
          before { target.new_name = "new_name" }

          it_behaves_like "will update"
          it_behaves_like "assert different property", :property_values_json
          it_behaves_like "update property schema json", {"msp" => {"name" => "new_name"}}
        end

        describe "remove" do
          before { target.remove }

          it_behaves_like "will update"
          it_behaves_like "assert different property", :property_values_json
          it_behaves_like "update property schema json", {"msp" => nil}
        end
      end

      context "when created from json" do
        let(:target) { Property.create_from_json "msp", tc.read_json("multi_select_property_object"), "data_source" }

        it_behaves_like "has name as", "msp"
        it_behaves_like "will not update"
        it_behaves_like "assert different property", :property_values_json
        it_behaves_like "update property schema json", {}
        it {
          expect(target.multi_select_names).to eq [
            "Multi Select 1",
            "Multi Select 2",
            "multi_select",
          ]
        }

        it_behaves_like "raw json", "multi_select", {
          "options" => [
            {
              "color" => "yellow",
              "id" => "2a0eeeee-b3fd-4072-96a9-865f67cfa6ff",
              "name" => "Multi Select 1",
            },
            {
              "color" => "default",
              "id" => "5f554552-b77a-474b-b5c7-4ae819966e32",
              "name" => "Multi Select 2",
            },
            {
              "color" => "red",
              "id" => "d4bc3d6e-a6e1-4d57-af66-d8ecbbda1dd3",
              "name" => "multi_select",
            },
          ],
        }
      end
    end

    context "when Page property" do
      retrieve_multi_select = {
        "msp" => {
          "multi_select" => [
            {
              "color" => "default",
              "id" => "5f554552-b77a-474b-b5c7-4ae819966e32",
              "name" => "Multi Select 2",
            },
            {
              "color" => "yellow",
              "id" => "2a0eeeee-b3fd-4072-96a9-865f67cfa6ff",
              "name" => "Multi Select 1",
            },
          ],
          "type" => "multi_select",
        },
      }
      context "when created by new" do
        let(:target) { described_class.new "msp", multi_select: "Multi Select 2" }

        it_behaves_like "property values json", {
          "msp" => {
            "type" => "multi_select",
            "multi_select" => [
              {"name" => "Multi Select 2"},
            ],
          },
        }
        it_behaves_like "will not update"
        it_behaves_like "assert different property", :update_property_schema_json
        it_behaves_like "assert different property", :property_schema_json

        describe "multi_select=" do
          before { target.multi_select = "Multi Select 3" }

          it_behaves_like "property values json", {
            "msp" => {
              "type" => "multi_select",
              "multi_select" => [
                {"name" => "Multi Select 3"},
              ],
            },
          }
          it_behaves_like "will update"
          it_behaves_like "assert different property", :update_property_schema_json
          it_behaves_like "assert different property", :property_schema_json
        end

        describe "update_from_json" do
          before { target.update_from_json(tc.read_json("retrieve_property_multi_select")) }

          it_behaves_like "will not update"
          it_behaves_like "property values json", retrieve_multi_select
          it_behaves_like "assert different property", :update_property_schema_json
          it_behaves_like "assert different property", :property_schema_json
        end
      end

      context "when created from json" do
        let(:target) { Property.create_from_json "msp", tc.read_json("retrieve_property_multi_select") }

        it_behaves_like "has name as", "msp"
        it_behaves_like "will not update"
        it_behaves_like "property values json", retrieve_multi_select
        it_behaves_like "assert different property", :update_property_schema_json
        it_behaves_like "assert different property", :property_schema_json
      end

      context "when created from json (no content)" do
        let(:target) { Property.create_from_json "msp", no_content_json, "page", property_cache_first }

        it_behaves_like "has name as", "msp"
        it_behaves_like "will not update"
        it { expect(target).not_to be_contents }

        it_behaves_like "assert different property", :update_property_schema_json

        # hook property_values_json / multi_select to retrieve a property item
        it_behaves_like "property values json", retrieve_multi_select
        it { expect(target.multi_select).to eq retrieve_multi_select["msp"]["multi_select"] }
      end
    end
  end
end
