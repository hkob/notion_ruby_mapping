# frozen_string_literal: true

module NotionRubyMapping
  RSpec.describe CheckboxProperty do
    tc = TestConnection.instance

    context "Database property" do
      context "created by new" do
        let(:target) { CheckboxProperty.new "cp", base_type: :database }
        it_behaves_like :has_name_as, "cp"
        it_behaves_like :filter_test, CheckboxProperty, %w[equals does_not_equal], value: true
        it_behaves_like :raw_json, :checkbox, {}
        it_behaves_like :property_schema_json, {"cp" => {"checkbox" => {}}}

        describe "update_from_json" do
          before { target.update_from_json(tc.read_json("checkbox_property_object")) }
          it_behaves_like :will_not_update
          it_behaves_like :assert_different_property, :property_values_json
          it_behaves_like :update_property_schema_json, {}
          it_behaves_like :raw_json, :checkbox, {}
        end

        describe "new_name=" do
          before { target.new_name = "new_name" }
          it_behaves_like :will_update
          it_behaves_like :assert_different_property, :property_values_json
          it_behaves_like :update_property_schema_json, {"cp" => {"name" => "new_name"}}
        end

        describe "remove" do
          before { target.remove }
          it_behaves_like :will_update
          it_behaves_like :assert_different_property, :property_values_json
          it_behaves_like :update_property_schema_json, {"cp" => nil}
        end
      end

      context "created from json" do
        let(:target) { Property.create_from_json "cp", tc.read_json("checkbox_property_object"), :database }
        it_behaves_like :has_name_as, "cp"
        it_behaves_like :will_not_update
        it_behaves_like :assert_different_property, :property_values_json
        it_behaves_like :update_property_schema_json, {}
        it_behaves_like :raw_json, :checkbox, {}
      end
    end

    context "Page property" do
      context "created by new" do
        let(:target) { CheckboxProperty.new "cp" }
        it_behaves_like :property_values_json, {"cp" => {"type" => "checkbox", "checkbox" => false}}
        it_behaves_like :will_not_update
        it { expect(target.checkbox).to eq false }
        it_behaves_like :assert_different_property, :update_property_schema_json

        describe "checkbox=" do
          before { target.checkbox = true }
          it_behaves_like :property_values_json, {"cp" => {"type" => "checkbox", "checkbox" => true}}
          it_behaves_like :will_update
          it { expect(target.checkbox).to eq true }
          it_behaves_like :assert_different_property, :update_property_schema_json
        end

        describe "update_from_json" do
          before { target.update_from_json(tc.read_json("checkbox_property_item")) }
          it_behaves_like :will_not_update
          it_behaves_like :property_values_json, {"cp" => {"type" => "checkbox", "checkbox" => true}}
          it { expect(target.checkbox).to eq true }
          it_behaves_like :assert_different_property, :update_property_schema_json
        end
      end

      context "created from json" do
        let(:target) { Property.create_from_json "cp", tc.read_json("checkbox_property_item") }
        it_behaves_like :has_name_as, "cp"
        it_behaves_like :will_not_update
        it_behaves_like :property_values_json, {"cp" => {"type" => "checkbox", "checkbox" => true}}
        it { expect(target.checkbox).to eq true }
        it_behaves_like :assert_different_property, :update_property_schema_json
      end
    end
  end
end
