# frozen_string_literal: true

module NotionRubyMapping
  RSpec.describe RelationProperty do
    tc = TestConnection.instance

    context "Database property" do
      context "created by new" do
        let(:target) { RelationProperty.new "rp", base_type: :database }
        it_behaves_like :has_name_as, "rp"
        it_behaves_like :raw_json, :relation, {}

        describe "update_from_json" do
          before { target.update_from_json(tc.read_json("relation_property_object")) }
          it_behaves_like :will_not_update
          it_behaves_like :assert_different_property, :property_values_json
          it_behaves_like :update_property_schema_json, {}
          it_behaves_like :raw_json, :relation, {
            "database_id" => "1d6b1040-a9fb-48d9-9a3d-041429816e9f",
            "synced_property_name" => "Related to Sample table (Column)",
            "synced_property_id" => "jZZ>",
          }
          it_behaves_like :property_schema_json, {
            "rp" => {
              "relation" => {
                "database_id" => "1d6b1040-a9fb-48d9-9a3d-041429816e9f",
              },
            },
          }
        end

        describe "replace_relation_database" do
          before { target.replace_relation_database database_id: "new_database_id", synced_property_name: "new name" }
          it_behaves_like :will_update
          it_behaves_like :assert_different_property, :property_values_json
          it_behaves_like :update_property_schema_json, {
            "rp" => {
              "relation" => {
                "database_id" => "new_database_id",
                "synced_property_name" => "new name",
              },
            },
          }
        end

        describe "new_name=" do
          before { target.new_name = "new_name" }
          it_behaves_like :will_update
          it_behaves_like :assert_different_property, :property_values_json
          it_behaves_like :update_property_schema_json, {"rp" => {"name" => "new_name"}}
        end

        describe "remove" do
          before { target.remove }
          it_behaves_like :will_update
          it_behaves_like :assert_different_property, :property_values_json
          it_behaves_like :update_property_schema_json, {"rp" => nil}
        end
      end

      context "created from json" do
        let(:target) { Property.create_from_json "rp", tc.read_json("relation_property_object"), :database }
        it_behaves_like :has_name_as, "rp"
        it_behaves_like :will_not_update
        it_behaves_like :assert_different_property, :property_values_json
        it_behaves_like :update_property_schema_json, {}
        it_behaves_like :raw_json, :relation, {
          "database_id" => "1d6b1040-a9fb-48d9-9a3d-041429816e9f",
          "synced_property_name" => "Related to Sample table (Column)",
          "synced_property_id" => "jZZ>",
        }
      end
    end

    context "Page property" do
      context "created by new" do
        let(:target) { RelationProperty.new "rp", json: [{"id" => "page_id"}] }
        it_behaves_like :property_values_json, {
          "rp" => {
            "relation" => [
              {"id" => "page_id"},
            ],
            "type" => "relation",
          },
        }
        it_behaves_like :will_not_update
        it_behaves_like :assert_different_property, :update_property_schema_json
        it_behaves_like :assert_different_property, :property_schema_json

        describe "add_relation=" do
          [
            "a_id", %w[page_id a_id],
            {"id" => "b_id"}, %w[page_id b_id],
          ].each_slice(2) do |(input, page_ids)|
            context input do
              before { target.add_relation input }
              it_behaves_like :property_values_json, {
                "rp" => {
                  "type" => "relation",
                  "relation" => Array(page_ids).map { |id| {"id" => id} }
                },
              }
              it_behaves_like :will_update
            end
          end
        end

        describe "relation=" do
          [
            "a_id", "a_id",
            %w[a_id b_id], %w[a_id b_id],
            {"id" => "a_id"}, "a_id",
            [{"id" => "a_id"}, {"id" => "b_id"}], %w[a_id b_id],
          ].each_slice(2) do |(input, page_ids)|
            context input do
              before { target.relation = input }
              it_behaves_like :property_values_json, {
                "rp" => {
                  "type" => "relation",
                  "relation" => Array(page_ids).map { |id| {"id" => id} }
                },
              }
              it_behaves_like :will_update
            end
          end
        end

        describe "update_from_json" do
          before { target.update_from_json(tc.read_json("relation_property_item")) }
          it_behaves_like :will_not_update
          it_behaves_like :property_values_json, {
            "rp" => {
              "relation" => [
                {"id" => "860753bb-6d1f-48de-9621-1fa6e0e31f82"},
              ],
              "type" => "relation",
            },
          }
          it_behaves_like :assert_different_property, :update_property_schema_json
          it_behaves_like :assert_different_property, :property_schema_json
        end
      end

      context "created from json" do
        let(:target) { Property.create_from_json "rp", tc.read_json("relation_property_item") }
        it_behaves_like :has_name_as, "rp"
        it_behaves_like :will_not_update
        it_behaves_like :property_values_json, {
          "rp" => {
            "relation" => [
              {"id" => "860753bb-6d1f-48de-9621-1fa6e0e31f82"},
            ],
            "type" => "relation",
          },
        }
        it_behaves_like :assert_different_property, :update_property_schema_json
        it_behaves_like :assert_different_property, :property_schema_json
      end
    end
  end
end
