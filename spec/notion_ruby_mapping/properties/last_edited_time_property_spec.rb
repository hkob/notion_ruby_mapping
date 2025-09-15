# frozen_string_literal: true

module NotionRubyMapping
  RSpec.describe LastEditedTimeProperty do
    tc = TestConnection.instance
    let(:no_content_json) { {"id" => "X%3E%40X"} }
    let(:first_page_id) { TestConnection::DB_FIRST_PAGE_ID }
    let(:property_cache_first) { PropertyCache.new base_type: "page", page_id: first_page_id }

    context "when Database property" do
      context "when created by new" do
        let(:target) { described_class.new "letp", base_type: "database" }

        it_behaves_like "has name as", "letp"
        it_behaves_like "raw json", :last_edited_time, {}

        describe "update_from_json" do
          before { target.update_from_json(tc.read_json("last_edited_time_property_object")) }

          it_behaves_like "will not update"
          it_behaves_like "assert different property", :property_values_json
          it_behaves_like "raw json", :last_edited_time, {}
          it_behaves_like "property schema json", {"letp" => {"last_edited_time" => {}}}
        end
      end

      context "when created from json" do
        let(:target) { Property.create_from_json "letp", tc.read_json("last_edited_time_property_object"), "database" }

        it_behaves_like "has name as", "letp"
        it_behaves_like "will not update"
        it_behaves_like "assert different property", :property_values_json
        it_behaves_like "raw json", :last_edited_time, {}
      end
    end

    context "when DataSource property" do
      context "when created by new" do
        let(:target) { described_class.new "letp", base_type: "data_source" }

        it_behaves_like "has name as", "letp"
        it_behaves_like "raw json", :last_edited_time, {}

        describe "update_from_json" do
          before { target.update_from_json(tc.read_json("last_edited_time_property_object")) }

          it_behaves_like "will not update"
          it_behaves_like "assert different property", :property_values_json
          it_behaves_like "update property schema json", {}
          it_behaves_like "raw json", :last_edited_time, {}
          it_behaves_like "property schema json", {"letp" => {"last_edited_time" => {}}}
        end

        describe "new_name=" do
          before { target.new_name = "new_name" }

          it_behaves_like "will update"
          it_behaves_like "assert different property", :property_values_json
          it_behaves_like "update property schema json", {"letp" => {"name" => "new_name"}}
        end

        describe "remove" do
          before { target.remove }

          it_behaves_like "will update"
          it_behaves_like "assert different property", :property_values_json
          it_behaves_like "update property schema json", {"letp" => nil}
        end
      end

      context "when created from json" do
        let(:target) do
          Property.create_from_json "letp", tc.read_json("last_edited_time_property_object"), "data_source"
        end

        it_behaves_like "has name as", "letp"
        it_behaves_like "will not update"
        it_behaves_like "assert different property", :property_values_json
        it_behaves_like "update property schema json", {}
        it_behaves_like "raw json", :last_edited_time, {}
      end
    end

    context "when Page property" do
      context "when created by new" do
        let(:target) { described_class.new "letp", json: "2022-02-06T21:29:00.000Z" }

        it_behaves_like "property values json", {}
        it_behaves_like "will not update"
        it { expect(target.last_edited_time).to eq "2022-02-06T21:29:00.000Z" }

        it_behaves_like "assert different property", :update_property_schema_json

        describe "update_from_json" do
          before { target.update_from_json(tc.read_json("retrieve_property_last_edited_time")) }

          it_behaves_like "will not update"
          it_behaves_like "property values json", {}
          it { expect(target.last_edited_time).to eq "2022-09-01T04:35:00.000Z" }

          it_behaves_like "assert different property", :update_property_schema_json
        end
      end

      context "when created from json" do
        let(:target) { Property.create_from_json "letp", tc.read_json("retrieve_property_last_edited_time") }

        it_behaves_like "has name as", "letp"
        it_behaves_like "will not update"
        it_behaves_like "property values json", {}
        it { expect(target.last_edited_time).to eq "2022-09-01T04:35:00.000Z" }

        it_behaves_like "assert different property", :update_property_schema_json
      end

      context "when created from json (no content)" do
        let(:target) { Property.create_from_json "letp", no_content_json, "page", property_cache_first }

        it_behaves_like "has name as", "letp"
        it_behaves_like "will not update"
        it { expect(target).not_to be_contents }

        it_behaves_like "assert different property", :update_property_schema_json

        # hook property_values_json / created_by to retrieve a property item
        it_behaves_like "property values json", {}
        it { expect(target.last_edited_time).to eq "2022-09-01T04:35:00.000Z" }
      end
    end
  end
end
