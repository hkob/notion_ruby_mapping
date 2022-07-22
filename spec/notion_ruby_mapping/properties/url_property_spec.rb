# frozen_string_literal: true

module NotionRubyMapping
  RSpec.describe UrlProperty do
    tc = TestConnection.instance
    let(:no_content_json) { {"id" => "tvis"} }
    let(:first_page_id) { TestConnection::DB_FIRST_PAGE_ID }
    let(:property_cache_first) { PropertyCache.new base_type: :page, page_id: first_page_id }

    context "Database property" do
      context "created by new" do
        let(:target) { UrlProperty.new "up", base_type: :database }
        it_behaves_like :has_name_as, "up"
        it_behaves_like :filter_test, UrlProperty,
                        %w[equals does_not_equal contains does_not_contain starts_with ends_with], value: "abc"
        it_behaves_like :filter_test, UrlProperty, %w[is_empty is_not_empty]
        it_behaves_like :raw_json, :url, {}
        it_behaves_like :property_schema_json, {"up" => {"url" => {}}}

        describe "update_from_json" do
          before { target.update_from_json(tc.read_json("url_property_object")) }
          it_behaves_like :will_not_update
          it_behaves_like :assert_different_property, :property_values_json
          it_behaves_like :update_property_schema_json, {}
          it_behaves_like :raw_json, :url, {}
        end

        describe "new_name=" do
          before { target.new_name = "new_name" }
          it_behaves_like :will_update
          it_behaves_like :assert_different_property, :property_values_json
          it_behaves_like :update_property_schema_json, {"up" => {"name" => "new_name"}}
        end

        describe "remove" do
          before { target.remove }
          it_behaves_like :will_update
          it_behaves_like :assert_different_property, :property_values_json
          it_behaves_like :update_property_schema_json, {"up" => nil}
        end
      end

      context "created from json" do
        let(:target) { Property.create_from_json "up", tc.read_json("url_property_object"), :database }
        it_behaves_like :has_name_as, "up"
        it_behaves_like :will_not_update
        it_behaves_like :assert_different_property, :property_values_json
        it_behaves_like :update_property_schema_json, {}
        it_behaves_like :raw_json, :url, {}
      end
    end

    context "Page property" do
      context "created by new" do
        let(:target) { UrlProperty.new "up" }
        it_behaves_like :property_values_json, {"up" => {"type" => "url", "url" => nil}}
        it_behaves_like :will_not_update
        it { expect(target.url).to eq nil }
        it_behaves_like :assert_different_property, :update_property_schema_json

        describe "url=" do
          before { target.url = "another url" }
          it_behaves_like :property_values_json, {"up" => {"type" => "url", "url" => "another url"}}
          it_behaves_like :will_update
          it { expect(target.url).to eq "another url" }
          it_behaves_like :assert_different_property, :update_property_schema_json
        end

        describe "update_from_json" do
          before { target.update_from_json(tc.read_json("retrieve_property_url")) }
          it_behaves_like :will_not_update
          it_behaves_like :property_values_json, {"up" => {"type" => "url", "url" => "https://hkob.hatenablog.com/"}}
          it { expect(target.url).to eq "https://hkob.hatenablog.com/" }
          it_behaves_like :assert_different_property, :update_property_schema_json
        end
      end

      context "created from json" do
        let(:target) { Property.create_from_json "up", tc.read_json("retrieve_property_url") }
        it_behaves_like :has_name_as, "up"
        it_behaves_like :will_not_update
        it_behaves_like :property_values_json, {"up" => {"type" => "url", "url" => "https://hkob.hatenablog.com/"}}
        it { expect(target.url).to eq "https://hkob.hatenablog.com/" }
        it_behaves_like :assert_different_property, :update_property_schema_json
      end

      context "created from json (no content)" do
        let(:target) { Property.create_from_json "up", no_content_json, :page, property_cache_first }
        it_behaves_like :has_name_as, "up"
        it_behaves_like :will_not_update
        it { expect(target.contents?).to be_falsey }
        it_behaves_like :assert_different_property, :update_property_schema_json

        # hook property_values_json / created_by to retrieve a property item
        it_behaves_like :property_values_json, {"up" => {"type" => "url", "url" => "https://hkob.hatenablog.com/"}}
        it { expect(target.url).to eq "https://hkob.hatenablog.com/"}
      end
    end
  end
end
