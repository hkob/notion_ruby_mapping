# frozen_string_literal: true

require_relative "../spec_helper"

module NotionRubyMapping
  RSpec.describe List do
    tc = TestConnection.instance

    describe "query" do
      let(:database) { Database.new id: tc.database_id }
      subject { database.query_database query }
      context "limit 2" do
        let(:query) { Query.new page_size: 2 }

        it "count page count" do
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
  end
end
