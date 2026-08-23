# frozen_string_literal: true

require_relative "../../spec_helper"

module NotionRubyMapping
  RSpec.describe List do
    tc = TestConnection.instance

    describe "query" do
      let(:data_source) { DataSource.new id: TestConnection::DATA_SOURCE_ID }

      subject { data_source.query_data_source query }
      context "when limit 2" do
        let(:query) { Query.new page_size: 2 }

        it "count page count" do
          expect(subject.count).to eq 5
        end

        it "count page count (again)" do
          subject.count
          expect(subject.count).to eq 5
        end

        it "has_more" do
          expect(subject.has_more).to be_truthy
        end

        # it "retrieve each_page" do
        #  expect(subject.map { |page| page.properties["Title"].text_objects.first.text }).to eq %w[JKL MNO DEF GHI ABC]
        # end
      end
    end

    describe "Page#children" do
      let(:target) { Page.find TestConnection::BLOCK_TEST_PAGE_ID }
      let(:query) { Query.new }

      describe "dry_run" do
        let(:dry_run) { target.children dry_run: true }

        it_behaves_like "dry run", :get, :block_children_page_path, use_id: true, use_query: true
      end

      describe "children" do
        context "without query" do
          subject { target.children }
          it "count page count" do
            expect(subject.count).to eq 36
          end
        end
      end
    end

    describe "Property#people" do
      let(:people_json) { tc.read_json "retrieve_property_people" }
      let(:first_page_id) { TestConnection::DB_FIRST_PAGE_ID }
      let(:property_cache) { PropertyCache.new base_type: "page", page_id: first_page_id }
      let(:target) { Property.create_from_json "pp", people_json, "page", property_cache }

      it { expect(target.people.first).to be_an_instance_of(UserObject) }
    end
  end
end
