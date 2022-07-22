# frozen_string_literal: true

module NotionRubyMapping
  RSpec.describe PhoneNumberProperty do
    tc = TestConnection.instance
    let(:no_content_json) { {"id" => "%7CNHO"} }
    let(:first_page_id) { TestConnection::DB_FIRST_PAGE_ID }
    let(:property_cache_first) { PropertyCache.new base_type: :page, page_id: first_page_id }

    context "Database property" do
      context "created by new" do
        let(:target) { PhoneNumberProperty.new "php", base_type: :database }
        it_behaves_like :has_name_as, "php"
        it_behaves_like :filter_test, PhoneNumberProperty,
                        %w[equals does_not_equal contains does_not_contain starts_with ends_with], value: "abc"
        it_behaves_like :filter_test, PhoneNumberProperty, %w[is_empty is_not_empty]
        it_behaves_like :raw_json, :phone_number, {}
        it_behaves_like :property_schema_json, {"php" => {"phone_number" => {}}}

        describe "update_from_json" do
          before { target.update_from_json(tc.read_json("phone_number_property_object")) }
          it_behaves_like :will_not_update
          it_behaves_like :assert_different_property, :property_values_json
          it_behaves_like :update_property_schema_json, {}
          it_behaves_like :raw_json, :phone_number, {}
        end

        describe "new_name=" do
          before { target.new_name = "new_name" }
          it_behaves_like :will_update
          it_behaves_like :assert_different_property, :property_values_json
          it_behaves_like :update_property_schema_json, {"php" => {"name" => "new_name"}}
        end

        describe "remove" do
          before { target.remove }
          it_behaves_like :will_update
          it_behaves_like :assert_different_property, :property_values_json
          it_behaves_like :update_property_schema_json, {"php" => nil}
        end
      end

      context "created from json" do
        let(:target) { Property.create_from_json "php", tc.read_json("phone_number_property_object"), :database }
        it_behaves_like :has_name_as, "php"
        it_behaves_like :will_not_update
        it_behaves_like :assert_different_property, :property_values_json
        it_behaves_like :update_property_schema_json, {}
        it_behaves_like :raw_json, :phone_number, {}
      end
    end

    context "Page property" do
      context "created by new" do
        let(:target) { PhoneNumberProperty.new "php" }
        it_behaves_like :property_values_json, {"php" => {"type" => "phone_number", "phone_number" => nil}}
        it_behaves_like :will_not_update
        it { expect(target.phone_number).to eq nil }
        it_behaves_like :assert_different_property, :update_property_schema_json

        describe "phone_number=" do
          before { target.phone_number = "yy-yyyy-yyyy" }
          it_behaves_like :property_values_json, {"php" => {"type" => "phone_number", "phone_number" => "yy-yyyy-yyyy"}}
          it_behaves_like :will_update
          it { expect(target.phone_number).to eq "yy-yyyy-yyyy" }
          it_behaves_like :assert_different_property, :update_property_schema_json
        end

        describe "update_from_json" do
          before { target.update_from_json(tc.read_json("retrieve_property_phone_number")) }
          it_behaves_like :will_not_update
          it_behaves_like :property_values_json, {"php" => {"type" => "phone_number", "phone_number" => "xx-xxxx-xxxx"}}
          it { expect(target.phone_number).to eq "xx-xxxx-xxxx" }
          it_behaves_like :assert_different_property, :update_property_schema_json
        end
      end

      context "created from json" do
        let(:target) { Property.create_from_json "php", tc.read_json("retrieve_property_phone_number") }
        it_behaves_like :has_name_as, "php"
        it_behaves_like :will_not_update
        it_behaves_like :property_values_json, {"php" => {"type" => "phone_number", "phone_number" => "xx-xxxx-xxxx"}}
        it { expect(target.phone_number).to eq "xx-xxxx-xxxx" }
        it_behaves_like :assert_different_property, :update_property_schema_json
      end

      context "created from json (no content)" do
        let(:target) { Property.create_from_json "php", no_content_json, :page, property_cache_first }
        it_behaves_like :has_name_as, "php"
        it_behaves_like :will_not_update
        it { expect(target.contents?).to be_falsey }
        it_behaves_like :assert_different_property, :update_property_schema_json

        # hook property_values_json / phone_number to retrieve a property item
        it_behaves_like :property_values_json, {"php" => {"type" => "phone_number", "phone_number" => "xx-xxxx-xxxx"}}
        it { expect(target.phone_number).to eq "xx-xxxx-xxxx" }
      end
    end
  end
end
