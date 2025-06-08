# frozen_string_literal: true

module NotionRubyMapping
  RSpec.describe VerificationProperty do
    tc = TestConnection.instance
    let(:no_content_json) { {id: "verification"} }
    let(:verification_database_id) { TestConnection::WIKI_DATABASE_ID }
    let(:verification_page_id) { TestConnection::WIKI_PAGE_ID }
    let(:property_cache_verification) { PropertyCache.new base_type: :page, page_id: verification_page_id }

    context "when Page property" do
      retrieve_verification = {
        vp: {
          type: :verification,
          verification: {
            state: "verified",
            verified_by: {id: "2200a911-6a96-44bb-bd38-6bfb1e01b9f6", object: "user"},
            date: {
              start: "2025-02-10T15:00:00.000Z",
              end: "2025-02-17T15:00:00.000Z",
              time_zone: nil,
            },
          },
        },
      }
      context "when created by new" do
        let(:target) { VerificationProperty.new "vp" }

        it_behaves_like "property values json", {vp: {verification: {}, type: :verification}}
        it_behaves_like "will not update"
        it_behaves_like "assert different property", :update_property_schema_json

        describe "when update_from_json" do
          before { target.update_from_json(tc.read_json("retrieve_property_verification")) }

          it_behaves_like "will not update"
          it_behaves_like "property values json", retrieve_verification
          it_behaves_like "assert different property", :update_property_schema_json
        end
      end

      context "when created from json" do
        let(:target) { Property.create_from_json "vp", tc.read_json("retrieve_property_verification") }

        it_behaves_like "has name as", :vp
        it_behaves_like "will not update"
        it_behaves_like "property values json", retrieve_verification
        it_behaves_like "assert different property", :update_property_schema_json
      end

      context "when created from json (no content)" do
        let(:target) { Property.create_from_json "vp", no_content_json, :page, property_cache_verification }

        it_behaves_like "has name as", :vp
        it_behaves_like "will not update"
        it { expect(target.contents?).to be_falsey }

        it_behaves_like "assert different property", :update_property_schema_json

        # hook property_values_json / verification to retrieve a property item
        it_behaves_like "property values json", retrieve_verification
      end
    end
  end
end
