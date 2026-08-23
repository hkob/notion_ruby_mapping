# frozen_string_literal: true

module NotionRubyMapping
  RSpec.describe SelectProperty do
    tc = TestConnection.instance
    let(:first_page_id) { TestConnection::DB_FIRST_PAGE_ID }
    let(:property_cache_first) { PropertyCache.new base_type: "page", page_id: first_page_id }

    select_property_object = {
      "options" => [
        {
          "color" => "brown",
          "id" => "0fed8e50-c917-4b56-96d9-9691a5132fc4",
          "name" => "Select 1",
        },
        {
          "color" => "default",
          "id" => "0b71c5a8-ea82-4b21-970e-b155e7c68a7e",
          "name" => "Select 2",
        },
        {
          "color" => "purple",
          "id" => "b32c83bb-c9af-49e8-9b88-122139affdb7",
          "name" => "Select 3",
        },
      ],
    }

    context "when Database property" do
      context "when created by new" do
        let(:target) { described_class.new "sp", base_type: "database" }

        it_behaves_like "has name as", "sp"
        it_behaves_like "filter test", described_class, %w[equals does_not_equal], value: true
        it_behaves_like "filter test", described_class, %w[is_empty is_not_empty]
        it_behaves_like "raw json", "select", {"options" => []}
        it_behaves_like "property schema json", {"sp" => {"select" => {"options" => []}}}

        describe "update_from_json" do
          before { target.update_from_json(tc.read_json("select_property_object")) }

          it_behaves_like "will not update"
          it_behaves_like "assert different property", :property_values_json
          it_behaves_like "raw json", "select", select_property_object
        end

        describe "add_select_option" do
          before { target.add_select_option name: "Select 4", color: "orange" }

          it { expect(target.select_names).to eq ["Select 4"] }

          it_behaves_like "will update"
          it_behaves_like "assert different property", :property_values_json
          it_behaves_like "update property schema json", {
            "sp" => {
              "select" => {
                "options" => [
                  {
                    "name" => "Select 4",
                    "color" => "orange",
                  },
                ],
              },
            },
          }
          it_behaves_like "property schema json", {
            "sp" => {
              "select" => {
                "options" => [
                  {
                    "name" => "Select 4",
                    "color" => "orange",
                  },
                ],
              },
            },
          }
        end
      end

      context "when created from json" do
        let(:target) { Property.create_from_json "sp", tc.read_json("select_property_object"), "database" }

        it_behaves_like "has name as", "sp"
        it_behaves_like "will not update"
        it_behaves_like "assert different property", :property_values_json
        it { expect(target.select_names).to eq ["Select 1", "Select 2", "Select 3"] }
        it { expect(target.select_options).to eq select_property_object["options"] }

        it_behaves_like "raw json", "select", select_property_object
      end
    end

    context "when DataSource property" do
      context "when created by new" do
        let(:target) { described_class.new "sp", base_type: "data_source" }

        it_behaves_like "has name as", "sp"
        it_behaves_like "filter test", described_class, %w[equals does_not_equal], value: true
        it_behaves_like "filter test", described_class, %w[is_empty is_not_empty]
        it_behaves_like "raw json", "select", {"options" => []}
        it_behaves_like "property schema json", {"sp" => {"select" => {"options" => []}}}

        describe "update_from_json" do
          before { target.update_from_json(tc.read_json("select_property_object")) }

          it_behaves_like "will not update"
          it_behaves_like "assert different property", :property_values_json
          it_behaves_like "update property schema json", {}
          it_behaves_like "raw json", "select", select_property_object
        end

        describe "add_select_option" do
          before { target.add_select_option name: "Select 4", color: "orange" }

          it { expect(target.select_names).to eq ["Select 4"] }

          it_behaves_like "will update"
          it_behaves_like "assert different property", :property_values_json
          it_behaves_like "update property schema json", {
            "sp" => {
              "select" => {
                "options" => [
                  {
                    "name" => "Select 4",
                    "color" => "orange",
                  },
                ],
              },
            },
          }
          it_behaves_like "property schema json", {
            "sp" => {
              "select" => {
                "options" => [
                  {
                    "name" => "Select 4",
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
        let(:target) { Property.create_from_json "sp", tc.read_json("select_property_object"), "data_source" }

        it_behaves_like "has name as", "sp"
        it_behaves_like "will not update"
        it_behaves_like "assert different property", :property_values_json
        it_behaves_like "update property schema json", {}
        it { expect(target.select_names).to eq ["Select 1", "Select 2", "Select 3"] }
        it { expect(target.select_options).to eq select_property_object["options"] }

        it_behaves_like "raw json", "select", select_property_object
      end
    end

    context "when Page property" do
      retrieve_select = {
        "sp" => {
          "type" => "select",
          "select" => {
            "color" => "purple",
            "id" => "b32c83bb-c9af-49e8-9b88-122139affdb7",
            "name" => "Select 3",
          },
        },
      }
      context "when created by new" do
        let(:target) { described_class.new "sp", select: "Select 2" }

        it_behaves_like "property values json", {
          "sp" => {
            "type" => "select",
            "select" => {"name" => "Select 2"},
          },
        }
        it_behaves_like "will not update"
        it_behaves_like "assert different property", :update_property_schema_json
        it_behaves_like "assert different property", :property_schema_json

        describe "select=" do
          ["Select 3", nil].each do |value|
            context "select = #{value.inspect}" do
              before { target.select = value }

              it_behaves_like "property values json", {
                "sp" => {
                  "type" => "select",
                  "select" => {"name" => value},
                },
              }
              it_behaves_like "will update"
              it_behaves_like "assert different property", :update_property_schema_json
              it_behaves_like "assert different property", :property_schema_json
            end
          end
        end

        describe "update_from_json" do
          before { target.update_from_json(tc.read_json("retrieve_property_select")) }

          it_behaves_like "will not update"
          it { expect(target.select_name).to eq "Select 3" }

          it_behaves_like "property values json", {
            "sp" => {
              "type" => "select",
              "select" => {
                "color" => "purple",
                "id" => "b32c83bb-c9af-49e8-9b88-122139affdb7",
                "name" => "Select 3",
              },
            },
          }
          it_behaves_like "assert different property", :update_property_schema_json
          it_behaves_like "assert different property", :property_schema_json
        end
      end

      context "when created from json" do
        let(:target) { Property.create_from_json "sp", tc.read_json("retrieve_property_select") }

        it_behaves_like "has name as", "sp"
        it_behaves_like "will not update"
        it_behaves_like "property values json", retrieve_select
        it { expect(target.select).to eq retrieve_select["sp"]["select"] }
        it { expect(target.select_name).to eq "Select 3" }

        it_behaves_like "assert different property", :update_property_schema_json
        it_behaves_like "assert different property", :property_schema_json
      end
    end
  end
end
