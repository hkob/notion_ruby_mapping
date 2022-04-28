# frozen_string_literal: true

module NotionRubyMapping
  RSpec.describe EmailProperty do
    tc = TestConnection.instance

    context "Database property" do
      context "created by new" do
        let(:target) { EmailProperty.new "ep", base_type: :database }
        it_behaves_like :has_name_as, "ep"
        it_behaves_like :filter_test, EmailProperty,
                        %w[equals does_not_equal contains does_not_contain starts_with ends_with], value: "abc"
        it_behaves_like :filter_test, EmailProperty, %w[is_empty is_not_empty]
        it_behaves_like :raw_json, :email, {}
        it_behaves_like :property_schema_json, {"ep" => {"email" => {}}}

        describe "update_from_json" do
          before { target.update_from_json(tc.read_json("email_property_object")) }
          it_behaves_like :will_not_update
          it_behaves_like :assert_different_property, :property_values_json
          it_behaves_like :update_property_schema_json, {}
          it_behaves_like :raw_json, :email, {}
        end

        describe "new_name=" do
          before { target.new_name = "new_name" }
          it_behaves_like :will_update
          it_behaves_like :assert_different_property, :property_values_json
          it_behaves_like :update_property_schema_json, {"ep" => {"name" => "new_name"}}
        end

        describe "remove" do
          before { target.remove }
          it_behaves_like :will_update
          it_behaves_like :assert_different_property, :property_values_json
          it_behaves_like :update_property_schema_json, {"ep" => nil}
        end
      end

      context "created from json" do
        let(:target) { Property.create_from_json "ep", tc.read_json("email_property_object"), :database }
        it_behaves_like :has_name_as, "ep"
        it_behaves_like :will_not_update
        it_behaves_like :assert_different_property, :property_values_json
        it_behaves_like :update_property_schema_json, {}
        it_behaves_like :raw_json, :email, {}
      end
    end

    it_behaves_like :filter_test, EmailProperty,
                    %w[equals does_not_equal contains does_not_contain starts_with ends_with], value: "abc"
    it_behaves_like :filter_test, EmailProperty, %w[is_empty is_not_empty]

    describe "a email property with parameters" do
      let(:target) { EmailProperty.new "ep", json: "hkobhkob@gmail.com" }

      it_behaves_like :property_values_json, {"ep" => {"type" => "email", "email" => "hkobhkob@gmail.com"}}
      it_behaves_like :will_not_update

      describe "email=" do
        before { target.email = "hkob@me.com" }
        it_behaves_like :property_values_json, {"ep" => {"type" => "email", "email" => "hkob@me.com"}}
        it_behaves_like :will_update
      end
      describe "update_from_json" do
        before { target.update_from_json(tc.read_json("email_property_item")) }
        it_behaves_like :will_not_update
        it_behaves_like :property_values_json, {"ep" => {"type" => "email", "email" => "hkobhkob@gmail.com"}}
      end
    end

    describe "a email property from property_item_json" do
      let(:target) { Property.create_from_json "ep", tc.read_json("email_property_item") }
      it_behaves_like :has_name_as, "ep"
      it_behaves_like :will_not_update
      it_behaves_like :property_values_json, {"ep" => {"type" => "email", "email" => "hkobhkob@gmail.com"}}
    end
  end
end
