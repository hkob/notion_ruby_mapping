# frozen_string_literal: true

module NotionRubyMapping
  RSpec.describe PeopleProperty do
    tc = TestConnection.instance
    let(:no_content_json) { {"id" => "_x%3E%3D"} }
    let(:first_page_id) { TestConnection::DB_FIRST_PAGE_ID }
    let(:property_cache_first) { PropertyCache.new base_type: "page", page_id: first_page_id }

    p_12 = {"type" => "people", "people" => (%w[P1 P2].map { |id| {"object" => "user", "id" => id} })}

    context "when Database property" do
      context "when created by new" do
        let(:target) { described_class.new "pp", base_type: "database" }

        it_behaves_like "has name as", "pp"
        it_behaves_like "filter test", described_class, %w[contains does_not_contain], value: true
        it_behaves_like "filter test", described_class, %w[is_empty is_not_empty]
        it_behaves_like "raw json", "people", {}
        it_behaves_like "property schema json", {"pp" => {"people" => {}}}

        describe "update_from_json" do
          before { target.update_from_json(tc.read_json("people_property_object")) }

          it_behaves_like "will not update"
          it_behaves_like "assert different property", :property_values_json
          it_behaves_like "raw json", "people", {}
        end
      end

      context "when created from json" do
        let(:target) { Property.create_from_json "pp", tc.read_json("people_property_object"), "database" }

        it_behaves_like "has name as", "pp"
        it_behaves_like "will not update"
        it_behaves_like "assert different property", :property_values_json
        it_behaves_like "raw json", "people", {}
      end
    end

    context "when DataSource property" do
      context "when created by new" do
        let(:target) { described_class.new "pp", base_type: "data_source" }

        it_behaves_like "has name as", "pp"
        it_behaves_like "filter test", described_class, %w[contains does_not_contain], value: true
        it_behaves_like "filter test", described_class, %w[is_empty is_not_empty]
        it_behaves_like "raw json", "people", {}
        it_behaves_like "property schema json", {"pp" => {"people" => {}}}

        describe "update_from_json" do
          before { target.update_from_json(tc.read_json("people_property_object")) }

          it_behaves_like "will not update"
          it_behaves_like "assert different property", :property_values_json
          it_behaves_like "update property schema json", {}
          it_behaves_like "raw json", "people", {}
        end

        describe "new_name=" do
          before { target.new_name = "new_name" }

          it_behaves_like "will update"
          it_behaves_like "assert different property", :property_values_json
          it_behaves_like "update property schema json", {"pp" => {"name" => "new_name"}}
        end

        describe "remove" do
          before { target.remove }

          it_behaves_like "will update"
          it_behaves_like "assert different property", :property_values_json
          it_behaves_like "update property schema json", {"pp" => nil}
        end
      end

      context "when created from json" do
        let(:target) { Property.create_from_json "pp", tc.read_json("people_property_object"), "data_source" }

        it_behaves_like "has name as", "pp"
        it_behaves_like "will not update"
        it_behaves_like "assert different property", :property_values_json
        it_behaves_like "update property schema json", {}
        it_behaves_like "raw json", "people", {}
      end
    end

    context "when Page property" do
      retrieve_user = {
        "pp" => {
          "type" => "people",
          "people" => [
            {
              "id" => "2200a9116a9644bbbd386bfb1e01b9f6",
              "object" => "user",
            },
          ],
        },
      }
      context "when created by new" do
        let(:target) { described_class.new "pp" }

        it_behaves_like "property values json", {"pp" => {"type" => "people", "people" => []}}
        it_behaves_like "will not update"
        it { expect(target.people).to eq [] }

        it_behaves_like "assert different property", :update_property_schema_json

        describe "people=" do
          context "when a value" do
            before { target.people = "P1" }

            it_behaves_like "property values json", {
              "pp" => {
                "type" => "people",
                "people" => [{"object" => "user", "id" => "P1"}],
              },
            }
            it_behaves_like "will update"
          end

          context "when an array value" do
            before { target.people = %w[P1 P2] }

            it_behaves_like "property values json", {"pp" => p_12}
            it_behaves_like "will update"
            it_behaves_like "assert different property", :update_property_schema_json
          end
        end

        describe "update_from_json" do
          before { target.update_from_json(tc.read_json("retrieve_property_people")) }

          it_behaves_like "will not update"
          it_behaves_like "property values json", retrieve_user
          it { expect(target.people.first).to be_an_instance_of(UserObject) }

          it_behaves_like "assert different property", :update_property_schema_json
        end
      end

      context "when created from json" do
        let(:target) { Property.create_from_json "pp", tc.read_json("retrieve_property_people") }

        it_behaves_like "has name as", "pp"
        it_behaves_like "will not update"
        it_behaves_like "property values json", retrieve_user
        it { expect(target.people.first).to be_an_instance_of(UserObject) }

        it_behaves_like "assert different property", :update_property_schema_json
      end

      context "when created from json (no content)" do
        let(:target) { Property.create_from_json "pp", no_content_json, "page", property_cache_first }

        it_behaves_like "has name as", "pp"
        it_behaves_like "will not update"
        it { expect(target).not_to be_contents }

        it_behaves_like "assert different property", :update_property_schema_json

        # hook property_values_json / created_by to retrieve a property item
        it_behaves_like "property values json", retrieve_user
      end
    end
  end
end
