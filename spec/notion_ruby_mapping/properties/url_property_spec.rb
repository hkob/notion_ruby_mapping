# frozen_string_literal: true

module NotionRubyMapping
  RSpec.describe UrlProperty do
    tc = TestConnection.instance
    let(:first_page_id) { TestConnection::DB_FIRST_PAGE_ID }
    let(:property_cache_first) { PropertyCache.new base_type: "page", page_id: first_page_id }

    context "when Database property" do
      context "when created by new" do
        let(:target) { described_class.new "up", base_type: "database" }

        it_behaves_like "has name as", "up"
        it_behaves_like "filter test", described_class,
                        %w[equals does_not_equal contains does_not_contain starts_with ends_with], value: "abc"
        it_behaves_like "filter test", described_class, %w[is_empty is_not_empty]
        it_behaves_like "raw json", "url", {}
        it_behaves_like "property schema json", {"up" => {"url" => {}}}

        describe "update_from_json" do
          before { target.update_from_json(tc.read_json("url_property_object")) }

          it_behaves_like "will not update"
          it_behaves_like "assert different property", :property_values_json
          it_behaves_like "update property schema json", {}
          it_behaves_like "raw json", "url", {}
        end
      end

      context "when created from json" do
        let(:target) { Property.create_from_json "up", tc.read_json("url_property_object"), "database" }

        it_behaves_like "has name as", "up"
        it_behaves_like "will not update"
        it_behaves_like "assert different property", :property_values_json
        it_behaves_like "update property schema json", {}
        it_behaves_like "raw json", "url", {}
      end
    end

    context "when DataSource property" do
      context "when created by new" do
        let(:target) { described_class.new "up", base_type: "data_source" }

        it_behaves_like "has name as", "up"
        it_behaves_like "filter test", described_class,
                        %w[equals does_not_equal contains does_not_contain starts_with ends_with], value: "abc"
        it_behaves_like "filter test", described_class, %w[is_empty is_not_empty]
        it_behaves_like "raw json", "url", {}
        it_behaves_like "property schema json", {"up" => {"url" => {}}}

        describe "update_from_json" do
          before { target.update_from_json(tc.read_json("url_property_object")) }

          it_behaves_like "will not update"
          it_behaves_like "assert different property", :property_values_json
          it_behaves_like "update property schema json", {}
          it_behaves_like "raw json", "url", {}
        end

        describe "new_name=" do
          before { target.new_name = "new_name" }

          it_behaves_like "will update"
          it_behaves_like "assert different property", :property_values_json
          it_behaves_like "update property schema json", {"up" => {"name" => "new_name"}}
        end

        describe "remove" do
          before { target.remove }

          it_behaves_like "will update"
          it_behaves_like "assert different property", :property_values_json
          it_behaves_like "update property schema json", {"up" => nil}
        end
      end

      context "when created from json" do
        let(:target) { Property.create_from_json "up", tc.read_json("url_property_object"), "data_source" }

        it_behaves_like "has name as", "up"
        it_behaves_like "will not update"
        it_behaves_like "assert different property", :property_values_json
        it_behaves_like "update property schema json", {}
        it_behaves_like "raw json", "url", {}
      end
    end

    context "when Page property" do
      context "when created by new" do
        let(:target) { described_class.new "up" }

        it_behaves_like "property values json", {"up" => {"type" => "url", "url" => nil}}
        it_behaves_like "will not update"
        it { expect(target.url).to be_nil }

        it_behaves_like "assert different property", :update_property_schema_json

        describe "url=" do
          ["another url", nil, ""].each do |value|
            context "when url = #{value.inspect}" do
              before { target.url = value }

              it_behaves_like "property values json", {"up" => {"type" => "url", "url" => value}}
              it_behaves_like "will update"
              it { expect(target.url).to eq value }

              it_behaves_like "assert different property", :update_property_schema_json
            end
          end
        end

        describe "update_from_json" do
          before { target.update_from_json(tc.read_json("retrieve_property_url")) }

          it_behaves_like "will not update"
          it_behaves_like "property values json", {"up" => {"type" => "url", "url" => "https://hkob.hatenablog.com/"}}
          it { expect(target.url).to eq "https://hkob.hatenablog.com/" }

          it_behaves_like "assert different property", :update_property_schema_json
        end
      end

      context "when created from json" do
        let(:target) { Property.create_from_json "up", tc.read_json("retrieve_property_url") }

        it_behaves_like "has name as", "up"
        it_behaves_like "will not update"
        it_behaves_like "property values json", {"up" => {"type" => "url", "url" => "https://hkob.hatenablog.com/"}}
        it { expect(target.url).to eq "https://hkob.hatenablog.com/" }

        it_behaves_like "assert different property", :update_property_schema_json
      end
    end
  end
end
