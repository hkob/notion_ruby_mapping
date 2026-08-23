# frozen_string_literal: true

module NotionRubyMapping
  RSpec.describe CheckboxProperty do
    tc = TestConnection.instance
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
          [true, false].each do |value|
            context "checkbox = #{value.inspect}" do
              before { target.checkbox = value }

              it_behaves_like "property values json", {"cp" => {"type" => "checkbox", "checkbox" => value}}
              it_behaves_like "will update"
              it { expect(target.checkbox).to be value }

              it_behaves_like "assert different property", :update_property_schema_json
            end
          end
        end

        describe "update_from_json" do
          context "with true" do
            before { target.update_from_json(tc.read_json("retrieve_property_checkbox")) }

            it_behaves_like "will not update"
            it_behaves_like "property values json", {"cp" => {"type" => "checkbox", "checkbox" => true}}
            it { expect(target.checkbox).to be true }

            it_behaves_like "assert different property", :update_property_schema_json
          end

          context "with false after true" do
            before do
              target.checkbox = true
              target.update_from_json({"id" => "%3CnJT", "type" => "checkbox", "checkbox" => false})
            end

            it_behaves_like "will not update"
            it_behaves_like "property values json", {"cp" => {"type" => "checkbox", "checkbox" => false}}
            it { expect(target.checkbox).to be false }
          end
        end
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
