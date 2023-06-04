# frozen_string_literal: true

module NotionRubyMapping
  RSpec.describe UniqueIdProperty do
    tc = TestConnection.instance
    let(:no_content_json) { {"id" => "%7BGE%7C"} }
    let(:first_page_id) { TestConnection::DB_FIRST_PAGE_ID }
    let(:property_cache_first) { PropertyCache.new base_type: :page, page_id: first_page_id }

    correct = {"uip" => {"type" => "unique_id", "unique_id" => {"prefix" => "ST", "number" => 3}}}

    context "Database property" do
      context "created by new" do
        let(:target) { UniqueIdProperty.new "uip", base_type: :database }
        it_behaves_like :has_name_as, "uip"
        it_behaves_like :filter_test, NumberProperty,
                        %w[equals does_not_equal greater_than less_than greater_than_or_equal_to less_than_or_equal_to],
                        value: 100
        it_behaves_like :filter_test, NumberProperty, %w[is_empty is_not_empty]
        it_behaves_like :raw_json, :unique_id, {}
        it_behaves_like :property_schema_json, {"uip" => {"unique_id" => {}}}

        describe "update_from_json" do
          before { target.update_from_json(tc.read_json("unique_id_property_object")) }
          it_behaves_like :will_not_update
          it_behaves_like :assert_different_property, :property_values_json
          it_behaves_like :update_property_schema_json, {}
          it_behaves_like :raw_json, :unique_id, {}
        end

        describe "new_name=" do
          before { target.new_name = "new_name" }
          it_behaves_like :will_update
          it_behaves_like :assert_different_property, :property_values_json
          it_behaves_like :update_property_schema_json, {"uip" => {"name" => "new_name"}}
        end

        describe "remove" do
          before { target.remove }
          it_behaves_like :will_update
          it_behaves_like :assert_different_property, :property_values_json
          it_behaves_like :update_property_schema_json, {"uip" => nil}
        end
      end

      context "created from json" do
        let(:target) { Property.create_from_json "uip", tc.read_json("unique_id_property_object"), :database }
        it_behaves_like :has_name_as, "uip"
        it_behaves_like :will_not_update
        it_behaves_like :assert_different_property, :property_values_json
        it_behaves_like :update_property_schema_json, {}
        it_behaves_like :raw_json, :unique_id, {}
      end
    end

    context "Page property" do
      context "created by new" do
        let(:target) do
          UniqueIdProperty.new "uip", json: {"prefix" => "ST", "number" => 3},
                               base_type: :page
        end

        it_behaves_like :property_values_json, correct
        it_behaves_like :will_not_update
        it_behaves_like :assert_different_property, :update_property_schema_json
        it_behaves_like :assert_different_property, :property_schema_json
      end


      context "created from json" do
        let(:target) { Property.create_from_json "uip", tc.read_json("retrieve_property_unique_id") }
        it_behaves_like :has_name_as, "uip"
        it_behaves_like :will_not_update
        it_behaves_like :property_values_json, correct
        it_behaves_like :assert_different_property, :update_property_schema_json
        it_behaves_like :assert_different_property, :property_schema_json
      end

      context "created from json (no content)" do
        let(:target) { Property.create_from_json "uip", no_content_json, :page, property_cache_first }
        it_behaves_like :has_name_as, "uip"
        it_behaves_like :will_not_update
        it { expect(target.contents?).to be_falsey }
        it_behaves_like :assert_different_property, :update_property_schema_json

        # hook property_values_json / created_by to retrieve a property item
        it_behaves_like :property_values_json, correct
      end
    end
  end
end
