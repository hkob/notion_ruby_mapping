# frozen_string_literal: true

module NotionRubyMapping
  RSpec.describe UrlProperty do
    tc = TestConnection.instance

    it_behaves_like :filter_test, UrlProperty,
                    %w[equals does_not_equal contains does_not_contain starts_with ends_with], value: "abc"
    it_behaves_like :filter_test, UrlProperty, %w[is_empty is_not_empty]

    describe "a url property with parameters" do
      let(:target) { UrlProperty.new "up", url: "https://hkob.hatenablog.com/" }

      it_behaves_like :property_values_json, {"up" => {"type" => "url", "url" => "https://hkob.hatenablog.com/"}}
      it_behaves_like :will_not_update

      describe "url=" do
        before { target.url = "https://www.google.com/" }
        it_behaves_like :property_values_json, {"up" => {"type" => "url", "url" => "https://www.google.com/"}}
        it_behaves_like :will_update
      end

      describe "update_from_json" do
        before { target.update_from_json(tc.read_json("url_property_item")) }
        it_behaves_like :will_not_update
        it_behaves_like :property_values_json, {"up" => {"type" => "url", "url" => "https://hkob.hatenablog.com/"}}
      end
    end

    describe "a url property from property_item_json" do
      let(:target) { Property.create_from_json "up", tc.read_json("url_property_item") }
      it_behaves_like :has_name_as, "up"
      it_behaves_like :will_not_update
      it_behaves_like :property_values_json, {"up" => {"type" => "url", "url" => "https://hkob.hatenablog.com/"}}
    end
  end
end
