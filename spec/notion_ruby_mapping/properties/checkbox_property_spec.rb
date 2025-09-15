# frozen_string_literal: true

module NotionRubyMapping
  RSpec.describe CheckboxProperty do
    tc = TestConnection.instance
    let(:no_content_json) { {"id" => "Lbi%5D"} }
    let(:first_page_id) { TestConnection::DB_FIRST_PAGE_ID }
    let(:property_cache_first) { PropertyCache.new base_type: "page", page_id: first_page_id }

    context "Database property" do
      context "created by new" do
        let(:target) { described_class.new "cp", base_type: "database" }

        it_behaves_like "has name as", "cp"
        it_behaves_like "filter test", described_class, %w[equals does_not_equal], value: true
        it_behaves_like "raw json", "checkbox", {}
        it_behaves_like "property schema json", {"cp" => {"checkbox" => {}}}

        describe "update_from_json" do
          before { target.update_from_json(tc.read_json("checkbox_property_object")) }

          it_behaves_like "will not update"
          it_behaves_like "assert different property", :property_values_json
          it_behaves_like "update property schema json", {}
          it_behaves_like "raw json", "checkbox", {}
        end
      end

      context "when created from json" do
        let(:target) { Property.create_from_json "cp", tc.read_json("checkbox_property_object"), "database" }

        it_behaves_like "has name as", "cp"
        it_behaves_like "will not update"
        it_behaves_like "assert different property", :property_values_json
        it_behaves_like "update property schema json", {}
        it_behaves_like "raw json", "checkbox", {}
      end
    end

    context "DataSource property" do
      context "created by new" do
        let(:target) { described_class.new "cp", base_type: "data_source" }

        it_behaves_like "has name as", "cp"
        it_behaves_like "filter test", described_class, %w[equals does_not_equal], value: true
        it_behaves_like "raw json", "checkbox", {}
        it_behaves_like "property schema json", {"cp" => {"checkbox" => {}}}

        describe "update_from_json" do
          before { target.update_from_json(tc.read_json("checkbox_property_object")) }

          it_behaves_like "will not update"
          it_behaves_like "assert different property", :property_values_json
          it_behaves_like "update property schema json", {}
          it_behaves_like "raw json", "checkbox", {}
        end

        describe "new_name=" do
          before { target.new_name = "new_name" }

          it_behaves_like "will update"
          it_behaves_like "assert different property", :property_values_json
          it_behaves_like "update property schema json", {"cp" => {"name" => "new_name"}}
        end

        describe "remove" do
          before { target.remove }

          it_behaves_like "will update"
          it_behaves_like "assert different property", :property_values_json
          it_behaves_like "update property schema json", {"cp" => nil}
        end
      end

      context "when created from json" do
        let(:target) { Property.create_from_json "cp", tc.read_json("checkbox_property_object"), "data_source" }

        it_behaves_like "has name as", "cp"
        it_behaves_like "will not update"
        it_behaves_like "assert different property", :property_values_json
        it_behaves_like "update property schema json", {}
        it_behaves_like "raw json", "checkbox", {}
      end
    end

    context "when Page property" do
      context "when created by new" do
        let(:target) { described_class.new "cp", property_cache: property_cache_first }

        it_behaves_like "property values json", {"cp" => {"type" => "checkbox", "checkbox" => false}}
        it_behaves_like "will not update"
        it { expect(target.checkbox).to be false }

        it_behaves_like "assert different property", :update_property_schema_json

        describe "checkbox=" do
          before { target.checkbox = true }

          it_behaves_like "property values json", {"cp" => {"type" => "checkbox", "checkbox" => true}}
          it_behaves_like "will update"
          it { expect(target.checkbox).to be true }

          it_behaves_like "assert different property", :update_property_schema_json
        end

        describe "update_from_json" do
          before { target.update_from_json(tc.read_json("retrieve_property_checkbox")) }

          it_behaves_like "will not update"
          it_behaves_like "property values json", {"cp" => {"type" => "checkbox", "checkbox" => true}}
          it { expect(target.checkbox).to be true }

          it_behaves_like "assert different property", :update_property_schema_json
        end

        describe "update_from_json (2022-06-28)" do
          before { target.update_from_json no_content_json }

          it_behaves_like "will not update"
          it_behaves_like "property values json", {"cp" => {"type" => "checkbox", "checkbox" => false}}
          it { expect(target.checkbox).to be false }

          it_behaves_like "assert different property", :update_property_schema_json
        end
      end

      context "created from json (no content)" do
        let(:target) { Property.create_from_json "cp", no_content_json, "page", property_cache_first }

        it_behaves_like "has name as", "cp"
        it_behaves_like "will not update"
        it { expect(target).not_to be_contents }

        it_behaves_like "assert different property", :update_property_schema_json

        # hook property_values_json / checkbox to retrieve a property item
        it_behaves_like "property values json", {"cp" => {"type" => "checkbox", "checkbox" => true}}
        it { expect(target.checkbox).to be true }
      end

      context "created from json" do
        let(:target) { Property.create_from_json "cp", tc.read_json("retrieve_property_checkbox") }

        it_behaves_like "has name as", "cp"
        it_behaves_like "will not update"
        it_behaves_like "property values json", {"cp" => {"type" => "checkbox", "checkbox" => true}}
        it { expect(target.checkbox).to be true }

        it_behaves_like "assert different property", :update_property_schema_json
      end
    end
  end
end
