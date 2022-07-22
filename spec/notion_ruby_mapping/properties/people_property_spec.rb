# frozen_string_literal: true

module NotionRubyMapping
  RSpec.describe PeopleProperty do
    tc = TestConnection.instance
    let(:no_content_json) { {"id" => "_x%3E%3D"} }
    let(:first_page_id) { TestConnection::DB_FIRST_PAGE_ID }
    let(:property_cache_first) { PropertyCache.new base_type: :page, page_id: first_page_id }
    p12 = {"type" => "people", "people" => (%w[P1 P2].map { |id| {"object" => "user", "id" => id} })}

    context "Database property" do
      context "created by new" do
        let(:target) { PeopleProperty.new "pp", base_type: :database }
        it_behaves_like :has_name_as, "pp"
        it_behaves_like :filter_test, PeopleProperty, %w[contains does_not_contain], value: true
        it_behaves_like :filter_test, PeopleProperty, %w[is_empty is_not_empty]
        it_behaves_like :raw_json, :people, {}
        it_behaves_like :property_schema_json, {"pp" => {"people" => {}}}

        describe "update_from_json" do
          before { target.update_from_json(tc.read_json("people_property_object")) }
          it_behaves_like :will_not_update
          it_behaves_like :assert_different_property, :property_values_json
          it_behaves_like :update_property_schema_json, {}
          it_behaves_like :raw_json, :people, {}
        end

        describe "new_name=" do
          before { target.new_name = "new_name" }
          it_behaves_like :will_update
          it_behaves_like :assert_different_property, :property_values_json
          it_behaves_like :update_property_schema_json, {"pp" => {"name" => "new_name"}}
        end

        describe "remove" do
          before { target.remove }
          it_behaves_like :will_update
          it_behaves_like :assert_different_property, :property_values_json
          it_behaves_like :update_property_schema_json, {"pp" => nil}
        end
      end

      context "created from json" do
        let(:target) { Property.create_from_json "pp", tc.read_json("people_property_object"), :database }
        it_behaves_like :has_name_as, "pp"
        it_behaves_like :will_not_update
        it_behaves_like :assert_different_property, :property_values_json
        it_behaves_like :update_property_schema_json, {}
        it_behaves_like :raw_json, :people, {}
      end
    end

    context "Page property" do
      retrieve_user = {
        "pp" => {
          "type" => "people",
          "people" => [
            {
              "id" => "2200a911-6a96-44bb-bd38-6bfb1e01b9f6",
              "object" => "user",
            },
          ],
        },
      }
      context "created by new" do
        let(:target) { PeopleProperty.new "pp" }
        it_behaves_like :property_values_json, {"pp" => {"type" => "people", "people" => []}}
        it_behaves_like :will_not_update
        it { expect(target.people).to eq [] }
        it_behaves_like :assert_different_property, :update_property_schema_json

        describe "people=" do
          context "a value" do
            before { target.people = "P1" }
            it_behaves_like :property_values_json, {
              "pp" => {
                "type" => "people",
                "people" => [{"object" => "user", "id" => "P1"}],
              },
            }
            it_behaves_like :will_update
          end

          context "an array value" do
            before { target.people = %w[P1 P2] }
            it_behaves_like :property_values_json, {"pp" => p12}
            it_behaves_like :will_update
            it_behaves_like :assert_different_property, :update_property_schema_json
          end
        end

        describe "update_from_json" do
          before { target.update_from_json(tc.read_json("retrieve_property_people")) }
          it_behaves_like :will_not_update
          it_behaves_like :property_values_json, retrieve_user
          it { expect(target.people.first).to be_an_instance_of(UserObject) }
          it_behaves_like :assert_different_property, :update_property_schema_json
        end
      end

      context "created from json" do
        let(:target) { Property.create_from_json "pp", tc.read_json("retrieve_property_people") }
        it_behaves_like :has_name_as, "pp"
        it_behaves_like :will_not_update
        it_behaves_like :property_values_json, retrieve_user
        it { expect(target.people.first).to be_an_instance_of(UserObject) }
        it_behaves_like :assert_different_property, :update_property_schema_json
      end

      context "created from json (no content)" do
        let(:target) { Property.create_from_json "pp", no_content_json, :page, property_cache_first }
        it_behaves_like :has_name_as, "pp"
        it_behaves_like :will_not_update
        it { expect(target.contents?).to be_falsey }
        it_behaves_like :assert_different_property, :update_property_schema_json

        # hook property_values_json / created_by to retrieve a property item
        it_behaves_like :property_values_json, retrieve_user
      end
    end
  end
end
