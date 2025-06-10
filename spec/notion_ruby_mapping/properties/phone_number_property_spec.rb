# frozen_string_literal: true

module NotionRubyMapping
  RSpec.describe PhoneNumberProperty do
    tc = TestConnection.instance
    let(:no_content_json) { {id: "%7CNHO"} }
    let(:first_page_id) { TestConnection::DB_FIRST_PAGE_ID }
    let(:property_cache_first) { PropertyCache.new base_type: :page, page_id: first_page_id }

    context "when Database property" do
      context "when created by new" do
        let(:target) { described_class.new "php", base_type: :database }

        it_behaves_like "has name as", :php
        it_behaves_like "filter test", described_class,
                        %i[equals does_not_equal contains does_not_contain starts_with ends_with], value: "abc"
        it_behaves_like "filter test", described_class, %i[is_empty is_not_empty]
        it_behaves_like "raw json", :phone_number, {}
        it_behaves_like "property schema json", {php: {phone_number: {}}}

        describe "update_from_json" do
          before { target.update_from_json(tc.read_json("phone_number_property_object")) }

          it_behaves_like "will not update"
          it_behaves_like "assert different property", :property_values_json
          it_behaves_like "update property schema json", {}
          it_behaves_like "raw json", :phone_number, {}
        end

        describe "new_name=" do
          before { target.new_name = "new_name" }

          it_behaves_like "will update"
          it_behaves_like "assert different property", :property_values_json
          it_behaves_like "update property schema json", {php: {name: :new_name}}
        end

        describe "remove" do
          before { target.remove }

          it_behaves_like "will update"
          it_behaves_like "assert different property", :property_values_json
          it_behaves_like "update property schema json", {php: nil}
        end
      end

      context "when created from json" do
        let(:target) { Property.create_from_json "php", tc.read_json("phone_number_property_object"), :database }

        it_behaves_like "has name as", :php
        it_behaves_like "will not update"
        it_behaves_like "assert different property", :property_values_json
        it_behaves_like "update property schema json", {}
        it_behaves_like "raw json", :phone_number, {}
      end
    end

    context "when Page property" do
      context "when created by new" do
        let(:target) { described_class.new "php" }

        it_behaves_like "property values json", {php: {type: "phone_number", phone_number: nil}}
        it_behaves_like "will not update"
        it { expect(target.phone_number).to be_nil }

        it_behaves_like "assert different property", :update_property_schema_json

        describe "phone_number=" do
          before { target.phone_number = "yy-yyyy-yyyy" }

          it_behaves_like "property values json",
                          {php: {type: "phone_number", phone_number: "yy-yyyy-yyyy"}}
          it_behaves_like "will update"
          it { expect(target.phone_number).to eq "yy-yyyy-yyyy" }

          it_behaves_like "assert different property", :update_property_schema_json
        end

        describe "update_from_json" do
          before { target.update_from_json(tc.read_json("retrieve_property_phone_number")) }

          it_behaves_like "will not update"
          it_behaves_like "property values json",
                          {php: {type: "phone_number", phone_number: "xx-xxxx-xxxx"}}
          it { expect(target.phone_number).to eq "xx-xxxx-xxxx" }

          it_behaves_like "assert different property", :update_property_schema_json
        end
      end

      context "when created from json" do
        let(:target) { Property.create_from_json "php", tc.read_json("retrieve_property_phone_number") }

        it_behaves_like "has name as", :php
        it_behaves_like "will not update"
        it_behaves_like "property values json", {php: {type: "phone_number", phone_number: "xx-xxxx-xxxx"}}
        it { expect(target.phone_number).to eq "xx-xxxx-xxxx" }

        it_behaves_like "assert different property", :update_property_schema_json
      end

      context "when created from json (no content)" do
        let(:target) { Property.create_from_json "php", no_content_json, :page, property_cache_first }

        it_behaves_like "has name as", :php
        it_behaves_like "will not update"
        it { expect(target).not_to be_contents }

        it_behaves_like "assert different property", :update_property_schema_json

        # hook property_values_json / phone_number to retrieve a property item
        it_behaves_like "property values json", {php: {type: "phone_number", phone_number: "xx-xxxx-xxxx"}}
        it { expect(target.phone_number).to eq "xx-xxxx-xxxx" }
      end
    end
  end
end
