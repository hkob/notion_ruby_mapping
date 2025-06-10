# frozen_string_literal: true

module NotionRubyMapping
  RSpec.describe UniqueIdProperty do
    tc = TestConnection.instance
    let(:no_content_json) { {id: "%7BGE%7C"} }
    let(:first_page_id) { TestConnection::DB_FIRST_PAGE_ID }
    let(:property_cache_first) { PropertyCache.new base_type: :page, page_id: first_page_id }

    correct = {uip: {type: "unique_id", unique_id: {prefix: "ST", number: 3}}}

    context "when Database property" do
      context "when created by new" do
        let(:target) { described_class.new "uip", base_type: :database }

        it_behaves_like "has name as", :uip
        it_behaves_like "filter test", described_class,
                        %i[equals does_not_equal greater_than less_than greater_than_or_equal_to less_than_or_equal_to],
                        value: 100
        it_behaves_like "filter test", described_class, %i[is_empty is_not_empty]
        it_behaves_like "raw json", :unique_id, {}
        it_behaves_like "property schema json", {uip: {unique_id: {}}}

        describe "update_from_json" do
          before { target.update_from_json(tc.read_json("unique_id_property_object")) }

          it_behaves_like "will not update"
          it_behaves_like "assert different property", :property_values_json
          it_behaves_like "update property schema json", {}
          it_behaves_like "raw json", :unique_id, {}
        end

        describe "new_name=" do
          before { target.new_name = "new_name" }

          it_behaves_like "will update"
          it_behaves_like "assert different property", :property_values_json
          it_behaves_like "update property schema json", {uip: {name: :new_name}}
        end

        describe "remove" do
          before { target.remove }

          it_behaves_like "will update"
          it_behaves_like "assert different property", :property_values_json
          it_behaves_like "update property schema json", {uip: nil}
        end
      end

      context "when created from json" do
        let(:target) { Property.create_from_json "uip", tc.read_json("unique_id_property_object"), :database }

        it_behaves_like "has name as", :uip
        it_behaves_like "will not update"
        it_behaves_like "assert different property", :property_values_json
        it_behaves_like "update property schema json", {}
        it_behaves_like "raw json", :unique_id, {}
      end
    end

    context "when Page property" do
      context "when created by new" do
        let(:target) do
          described_class.new "uip", json: {prefix: "ST", number: 3},
                                     base_type: :page
        end

        it_behaves_like "property values json", correct
        it_behaves_like "will not update"
        it_behaves_like "assert different property", :update_property_schema_json
        it_behaves_like "assert different property", :property_schema_json
      end

      context "when created from json" do
        let(:target) { Property.create_from_json "uip", tc.read_json("retrieve_property_unique_id") }

        it_behaves_like "has name as", :uip
        it_behaves_like "will not update"
        it_behaves_like "property values json", correct
        it_behaves_like "assert different property", :update_property_schema_json
        it_behaves_like "assert different property", :property_schema_json
      end

      context "when created from json (no content)" do
        let(:target) { Property.create_from_json "uip", no_content_json, :page, property_cache_first }

        it_behaves_like "has name as", :uip
        it_behaves_like "will not update"
        it { expect(target).not_to be_contents }

        it_behaves_like "assert different property", :update_property_schema_json

        # hook property_values_json / created_by to retrieve a property item
        it_behaves_like "property values json", correct
      end
    end
  end
end
