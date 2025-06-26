# frozen_string_literal: true

module NotionRubyMapping
  RSpec.describe RelationProperty do
    tc = TestConnection.instance
    let(:no_content_json) { {"id" => "%3CnJT"} }
    let(:first_page_id) { TestConnection::DB_FIRST_PAGE_ID }
    let(:property_cache_first) { PropertyCache.new base_type: "page", page_id: first_page_id }

    context "when Database property" do
      context "when created by new" do
        let(:target) { described_class.new "rp", base_type: "database" }

        it_behaves_like "has name as", "rp"
        it_behaves_like "raw json", :relation, {}

        describe "update_from_json" do
          before { target.update_from_json(tc.read_json("relation_property_object")) }

          it_behaves_like "will not update"
          it_behaves_like "assert different property", :property_values_json
          it_behaves_like "update property schema json", {}
          it_behaves_like "raw json", "relation", {
            "database_id" => "c37a2c66-e3aa-4a0d-a447-73de3b80c253",
            "type" => "dual_property",
            "dual_property" => {
              "synced_property_name" => "RelationTitle",
              "synced_property_id" => "%3CnJT",
            },
          }
          it_behaves_like "property schema json", {
            "rp" => {
              "relation" => {
                "database_id" => "c37a2c66-e3aa-4a0d-a447-73de3b80c253",
                "type" => "dual_property",
                "dual_property" => {
                  "synced_property_id" => "%3CnJT",
                  "synced_property_name" => "RelationTitle",
                },
              },
            },
          }
        end

        describe "replace_relation_database (dual_property)" do
          before { target.replace_relation_database database_id: "new_database_id" }

          it_behaves_like "will update"
          it_behaves_like "assert different property", :property_values_json
          it_behaves_like "update property schema json", {
            "rp" => {
              "relation" => {
                "database_id" => "new_database_id",
                "type" => "dual_property",
                "dual_property" => {},
              },
            },
          }
        end

        describe "replace_relation_database (single_property)" do
          before do
            target.replace_relation_database database_id: "new_database_id", type: "single_property"
          end

          it_behaves_like "will update"
          it_behaves_like "assert different property", :property_values_json
          it_behaves_like "update property schema json", {
            "rp" => {
              "relation" => {
                "database_id" => "new_database_id",
                "type" => "single_property",
                "single_property" => {},
              },
            },
          }
        end

        describe "new_name=" do
          before { target.new_name = "new_name" }

          it_behaves_like "will update"
          it_behaves_like "assert different property", :property_values_json
          it_behaves_like "update property schema json", {"rp" => {"name" => "new_name"}}
        end

        describe "remove" do
          before { target.remove }

          it_behaves_like "will update"
          it_behaves_like "assert different property", :property_values_json
          it_behaves_like "update property schema json", {"rp" => nil}
        end
      end

      context "when created from json" do
        let(:target) { Property.create_from_json "rp", tc.read_json("relation_property_object"), "database" }

        it_behaves_like "has name as", "rp"
        it_behaves_like "will not update"
        it_behaves_like "assert different property", :property_values_json
        it_behaves_like "update property schema json", {}
        it_behaves_like "raw json", "relation", {
          "database_id" => "c37a2c66-e3aa-4a0d-a447-73de3b80c253",
          "type" => "dual_property",
          "dual_property" => {
            "synced_property_name" => "RelationTitle",
            "synced_property_id" => "%3CnJT",
          },
        }
      end
    end

    context "when Page property" do
      retrieve_relation = {
        "rp" => {
          "relation" => [
            {"id" => "860753bb-6d1f-48de-9621-1fa6e0e31f82"},
          ],
          "type" => "relation",
        },
      }
      context "when created by new" do
        let(:target) { RelationProperty.new "rp", json: [{"id" => "page_id"}] }

        it_behaves_like "property values json", {
          "rp" => {
            "relation" => [
              {"id" => "page_id"},
            ],
            "type" => "relation",
          },
        }
        it_behaves_like "will not update"
        it_behaves_like "assert different property", :update_property_schema_json
        it_behaves_like "assert different property", :property_schema_json

        describe "add_relation=" do
          [
            "a_id", %w[page_id a_id],
            {"id" => "b_id"}, %w[page_id b_id]
          ].each_slice(2) do |(input, page_ids)|
            context input do
              before { target.add_relation input }

              it_behaves_like "property values json", {
                "rp" => {
                  "type" => "relation",
                  "relation" => Array(page_ids).map { |id| {"id" => id} },
                },
              }
              it_behaves_like "will update"
            end
          end
        end

        describe "relation=" do
          [
            "a_id", "a_id",
            %w[a_id b_id], %w[a_id b_id],
            {"id" => "a_id"}, "a_id",
            [{"id" => "a_id"}, {"id" => "b_id"}], %w[a_id b_id]
          ].each_slice(2) do |(input, page_ids)|
            context input do
              before { target.relation = input }

              it_behaves_like "property values json", {
                "rp" => {
                  "type" => "relation",
                  "relation" => Array(page_ids).map { |id| {"id" => id} },
                },
              }
              it_behaves_like "will update"
            end
          end
        end

        describe "update_from_json" do
          before { target.update_from_json(tc.read_json("retrieve_property_relation")) }

          it_behaves_like "will not update"
          it_behaves_like "property values json", {
            "rp" => {
              "relation" => [
                {"id" => "page_id"},
              ],
              "type" => "relation",
            },
          }
          it_behaves_like "assert different property", :update_property_schema_json
          it_behaves_like "assert different property", :property_schema_json
        end
      end

      context "when created from json" do
        let(:target) { Property.create_from_json "rp", tc.read_json("retrieve_property_relation") }

        it_behaves_like "has name as", "rp"
        it_behaves_like "will not update"
        it_behaves_like "property values json", retrieve_relation
        it_behaves_like "assert different property", :update_property_schema_json
        it_behaves_like "assert different property", :property_schema_json
      end

      context "when created from json (no content)" do
        let(:target) { Property.create_from_json "rp", no_content_json, "page", property_cache_first }

        it_behaves_like "has name as", "rp"
        it_behaves_like "will not update"
        it { expect(target).not_to be_contents }

        it_behaves_like "assert different property", :update_property_schema_json

        # hook property_values_json / title to retrieve a property item
        it_behaves_like "property values json", retrieve_relation
      end
    end
  end
end
