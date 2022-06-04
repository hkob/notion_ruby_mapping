# frozen_string_literal: true

require_relative "../../spec_helper"

module NotionRubyMapping
  RSpec.describe List do
    # tc = TestConnection.instance

    describe "query" do
      let(:database) { Database.new id: TestConnection::DATABASE_ID }
      subject { database.query_database query }
      context "limit 2" do
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

        it "retrieve each_page" do
          expect(subject.map { |page| page.properties["Title"].text_objects.first.text }).to eq %w[JKL MNO DEF GHI ABC]
        end
      end
    end

    describe "Page#children" do
      let(:target) { Page.find TestConnection::BLOCK_TEST_PAGE_ID }
      let(:query) { Query.new }
      describe "dry_run" do
        let(:dry_run) { target.children dry_run: true }
        it_should_behave_like :dry_run, :get, :block_children_page_path, use_id: true, use_query: true
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
  end
end
