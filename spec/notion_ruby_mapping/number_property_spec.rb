# frozen_string_literal: true

module NotionRubyMapping
  RSpec.describe NumberProperty do
    tc = TestConnection.instance

    describe "a number property without parameter" do
      let(:property) { NumberProperty.new "np" }
      it "has name" do
        expect(property.name).to eq "np"
      end

      it_behaves_like :filter_test, NumberProperty,
                      %w[equals does_not_equal greater_than less_than greater_than_or_equal_to less_than_or_equal_to],
                      value: 100
      it_behaves_like :filter_test, NumberProperty, %w[is_empty is_not_empty]
    end

    describe "a number property with parameters" do
      let(:target) { NumberProperty.new "np", number: 3.14 }

      it_behaves_like :property_values_json, {"np" => {"type" => "number", "number" => 3.14}}
      it_behaves_like :will_not_update

      describe "number=" do
        before { target.number = 2022 }
        it_behaves_like :property_values_json, {"np" => {"type" => "number", "number" => 2022}}
        it_behaves_like :will_update
      end

      describe "update_from_json" do
        before { target.update_from_json(tc.read_json("number_property_item")) }
        it_behaves_like :will_not_update
        it_behaves_like :property_values_json, {"np" => {"type" => "number", "number" => 1.41421356}}
      end
    end

    describe "a number property from property_item_json" do
      let(:json) { {"type" => "number", "number" => 123} }
      let(:target) { Property.create_from_json "np", tc.read_json("number_property_item") }
      it_behaves_like :has_name_as, "np"
      it_behaves_like :will_not_update
      it_behaves_like :property_values_json, {"np" => {"type" => "number", "number" => 1.41421356}}
    end
  end
end
