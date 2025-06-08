# frozen_string_literal: true

require_relative "../../spec_helper"

module NotionRubyMapping
  # NOTE: Common tests without API access
  RSpec.describe Base do
    context "when Base created by new and assign" do
      let(:target) do
        described_class.new id: "base created by new and assign",
                            assign: [NumberProperty, "np"]
      end
      let(:np) { target.properties["np"] }

      before { np.number = 12_345 }

      it "has an auto generated property_cache" do
        expect(target.properties).to be_an_instance_of(PropertyCache)
      end

      it_behaves_like "property values json", {
        properties: {
          np: {
            number: 12_345,
            type: "number",
          },
        },
      }
    end

    context "when base created by json" do
      let(:json) do
        {
          id: "created by json",
          properties: {
            Title: {
              type: "title",
              title: [
                {
                  type: "text",
                  text: {
                    content: "ABC\n",
                  },
                  plain_text: "ABC\n",
                },
                {
                  type: "text",
                  text: {
                    content: "DEF",
                  },
                  plain_text: "DEF",
                },
              ],
            },
          },
        }
      end
      let(:target) { Page.new json: json }
      let(:tp) { target.properties["Title"] }

      it "has an auto generated property_cache" do
        expect(target.properties).to be_an_instance_of(PropertyCache)
      end

      context "when before change" do
        it { expect(target.title).to eq "ABC\nDEF" }

        it_behaves_like "property values json", {}
      end

      context "when after change" do
        before { tp[1].text = "updated text" }

        it { expect(target.title).to eq "ABC\nupdated text" }

        it_behaves_like "property values json", {
          properties: {
            Title: {
              type: "title",
              title: [
                {
                  type: "text",
                  text: {
                    content: "ABC\n",
                    link: nil,
                  },
                  plain_text: "ABC\n",
                  href: nil,
                },
                {
                  type: "text",
                  text: {
                    content: "updated text",
                    link: nil,
                  },
                  plain_text: "updated text",
                  href: nil,
                },
              ],
            },
          },
        }
      end
    end

    describe "parent" do
      let(:ans) do
        [
          "#!/bin/sh\n",
          "curl  'https://api.notion.com/v1/",
          klass,
          "/parent_id' \\\n",
          "  -H 'Notion-Version: 2022-06-28' \\\n",
          "  -H 'Authorization: Bearer '\"$NOTION_API_KEY\"''",
        ].join ""
      end

      subject { target.parent dry_run: true }

      context "when Database - page_id" do
        let(:target) { Database.new json: {id: "ABC", parent: {type: "page_id", page_id: "parent_id"}} }
        let(:klass) { "pages" }

        it { is_expected.to eq ans }
      end

      context "when Database - block_id" do
        let(:target) do
          Database.new json: {id: "ABC", parent: {type: "block_id", block_id: "parent_id"}}
        end
        let(:klass) { "blocks" }

        it { is_expected.to eq ans }
      end

      context "when Page - database_id" do
        let(:target) do
          Page.new json: {id: "ABC", parent: {type: "database_id", database_id: "parent_id"}}
        end
        let(:klass) { "databases" }

        it { is_expected.to eq ans }
      end

      context "when Page - page_id" do
        let(:target) { Page.new json: {id: "ABC", parent: {type: "page_id", page_id: "parent_id"}} }
        let(:klass) { "pages" }

        it { is_expected.to eq ans }
      end

      context "when Page - block_id" do
        let(:target) { Page.new json: {id: "ABC", parent: {type: "block_id", block_id: "parent_id"}} }
        let(:klass) { "blocks" }

        it { is_expected.to eq ans }
      end

      context "when Block - page_id" do
        let(:target) { Block.new json: {id: "ABC", parent: {type: "page_id", page_id: "parent_id"}} }
        let(:klass) { "pages" }

        it { is_expected.to eq ans }
      end

      context "when Block - block_id" do
        let(:target) { Block.new json: {id: "ABC", parent: {type: "block_id", block_id: "parent_id"}} }
        let(:klass) { "blocks" }

        it { is_expected.to eq ans }
      end
    end

    describe "self.database_id" do
      subject { described_class.database_id str }
      context "when full url" do
        let(:str) { TestConnection::DATABASE_URL }

        it { is_expected.to eq TestConnection::DATABASE_ID }
      end

      context "when id only" do
        let(:str) { TestConnection::DATABASE_ID }

        it { is_expected.to eq TestConnection::DATABASE_ID }
      end
    end

    describe "self.page_id" do
      subject { described_class.page_id str }
      context "when full url with ?pvs=4" do
        let(:str) { "#{TestConnection::TOP_PAGE_URL}?pvs=4" }

        it { is_expected.to eq TestConnection::TOP_PAGE_ID }
      end

      context "when full url" do
        let(:str) { TestConnection::TOP_PAGE_URL }

        it { is_expected.to eq TestConnection::TOP_PAGE_ID }
      end

      context "when id only" do
        let(:str) { TestConnection::TOP_PAGE_ID }

        it { is_expected.to eq TestConnection::TOP_PAGE_ID }
      end
    end

    describe "self.block_id" do
      subject { described_class.block_id str }
      context "when full url" do
        let(:str) { TestConnection::H1_BLOCK_URL }

        it { is_expected.to eq TestConnection::H1_BLOCK_ID }
      end

      context "when id only" do
        let(:str) { TestConnection::H1_BLOCK_ID }

        it { is_expected.to eq TestConnection::H1_BLOCK_ID }
      end
    end
  end
end
