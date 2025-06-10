# frozen_string_literal: true

module NotionRubyMapping
  RSpec.describe CreatedTimeProperty do
    tc = TestConnection.instance
    let(:no_content_json) { {id: "WsEj"} }
    let(:first_page_id) { TestConnection::DB_FIRST_PAGE_ID }
    let(:property_cache_first) { PropertyCache.new base_type: :page, page_id: first_page_id }

    context "when Database property" do
      context "when created by new" do
        let(:target) { described_class.new "ctp", base_type: :database }

        it_behaves_like "has name as", :ctp
        it_behaves_like "raw json", :created_time, {}

        describe "update_from_json" do
          before { target.update_from_json(tc.read_json("created_time_property_object")) }

          it_behaves_like "will not update"
          it_behaves_like "assert different property", :property_values_json
          it_behaves_like "update property schema json", {}
          it_behaves_like "raw json", :created_time, {}
          it_behaves_like "property schema json", {ctp: {created_time: {}}}
        end

        describe "new_name=" do
          before { target.new_name = "new_name" }

          it_behaves_like "will update"
          it_behaves_like "assert different property", :property_values_json
          it_behaves_like "update property schema json", {ctp: {name: :new_name}}
        end

        describe "remove" do
          before { target.remove }

          it_behaves_like "will update"
          it_behaves_like "assert different property", :property_values_json
          it_behaves_like "update property schema json", {ctp: nil}
        end
      end

      context "when created from json" do
        let(:target) { Property.create_from_json "ctp", tc.read_json("created_time_property_object"), :database }

        it_behaves_like "has name as", :ctp
        it_behaves_like "will not update"
        it_behaves_like "assert different property", :property_values_json
        it_behaves_like "update property schema json", {}
        it_behaves_like "raw json", :created_time, {}
      end
    end

    context "when Page property" do
      context "when created by new" do
        let(:target) { described_class.new "ctp", json: "2022-02-06T21:29:00.000Z" }

        it_behaves_like "property values json", {}
        it_behaves_like "will not update"
        it { expect(target.created_time).to eq "2022-02-06T21:29:00.000Z" }

        it_behaves_like "assert different property", :update_property_schema_json

        describe "update_from_json" do
          before { target.update_from_json(tc.read_json("retrieve_property_created_time")) }

          it_behaves_like "will not update"
          it_behaves_like "property values json", {}
          it { expect(target.created_time).to eq "2022-02-07T21:29:00.000Z" }

          it_behaves_like "assert different property", :update_property_schema_json
        end
      end

      context "when created from json" do
        let(:target) { Property.create_from_json "ctp", tc.read_json("retrieve_property_created_time") }

        it_behaves_like "has name as", :ctp
        it_behaves_like "will not update"
        it_behaves_like "property values json", {}
        it { expect(target.created_time).to eq "2022-02-07T21:29:00.000Z" }

        it_behaves_like "assert different property", :update_property_schema_json
      end

      context "when created from json (no content)" do
        let(:target) { Property.create_from_json "ctp", no_content_json, :page, property_cache_first }

        it_behaves_like "has name as", :ctp
        it_behaves_like "will not update"
        it { expect(target).not_to be_contents }

        it_behaves_like "assert different property", :update_property_schema_json

        # hook property_values_json / created_time to retrieve a property item
        it_behaves_like "property values json", {}
        it { expect(target.created_time).to eq "2022-02-07T21:29:00.000Z" }
      end
    end
  end
end
