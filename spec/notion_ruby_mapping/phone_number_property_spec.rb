# frozen_string_literal: true

module NotionRubyMapping
  RSpec.describe PhoneNumberProperty do
    tc = TestConnection.instance

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
          before { target.update_from_json(tc.read_json("phone_number_property_item")) }
          it_behaves_like :will_not_update
          it_behaves_like :property_values_json, {"php" => {"type" => "phone_number", "phone_number" => "xx-xxxx-xxxx"}}
          it { expect(target.phone_number).to eq "xx-xxxx-xxxx" }
          it_behaves_like :assert_different_property, :update_property_schema_json
        end
      end

      context "created from json" do
        let(:target) { Property.create_from_json "php", tc.read_json("phone_number_property_item") }
        it_behaves_like :has_name_as, "php"
        it_behaves_like :will_not_update
        it_behaves_like :property_values_json, {"php" => {"type" => "phone_number", "phone_number" => "xx-xxxx-xxxx"}}
        it { expect(target.phone_number).to eq "xx-xxxx-xxxx" }
        it_behaves_like :assert_different_property, :update_property_schema_json
      end
    end
  end
end
