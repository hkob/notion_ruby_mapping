# frozen_string_literal: true

module NotionRubyMapping
  RSpec.describe PhoneNumberProperty do
    tc = TestConnection.instance

    it_behaves_like :filter_test, PhoneNumberProperty,
                    %w[equals does_not_equal contains does_not_contain starts_with ends_with], value: "abc"
    it_behaves_like :filter_test, PhoneNumberProperty, %w[is_empty is_not_empty]

    describe "a phone_number property with parameters" do
      let(:target) { PhoneNumberProperty.new "up", phone_number: "xx-xxxx-xxxx" }

      it_behaves_like :property_values_json, {"up" => {"type" => "phone_number", "phone_number" => "xx-xxxx-xxxx"}}
      it_behaves_like :will_not_update

      describe "phone_number=" do
        before { target.phone_number = "yy-yyyy-yyyy" }
        it_behaves_like :property_values_json, {"up" => {"type" => "phone_number", "phone_number" => "yy-yyyy-yyyy"}}
        it_behaves_like :will_update
      end

      describe "update_from_json" do
        before { target.update_from_json(tc.read_json("phone_number_property_item")) }
        it_behaves_like :will_not_update
        it_behaves_like :property_values_json, {"up" => {"type" => "phone_number", "phone_number" => "xx-xxxx-xxxx"}}
      end
    end

    describe "a phone_number property from property_item_json" do
      let(:target) { Property.create_from_json "up", tc.read_json("phone_number_property_item") }
      it_behaves_like :has_name_as, "up"
      it_behaves_like :will_not_update
      it_behaves_like :property_values_json, {"up" => {"type" => "phone_number", "phone_number" => "xx-xxxx-xxxx"}}
    end
  end
end
