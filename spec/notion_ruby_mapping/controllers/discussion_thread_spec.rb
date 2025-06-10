# frozen_string_literal: true

require_relative "../../spec_helper"

module NotionRubyMapping
  RSpec.describe Payload do
    tc = TestConnection.instance
    tc.read_json "retrieve_comments_top_page"
    tc.read_json "retrieve_comments_h1_block"
    context "create a discussion_thread" do
      let(:target) { DiscussionThread.new "dt_id" }

      it { expect(target.discussion_id).to eq "dt_id" }
    end

    describe "base.comments" do
      context "when dry_run: false" do
        subject { base.comments }

        context "page.comments" do
          let(:base) { Page.find TestConnection::TOP_PAGE_ID }

          it { expect(subject.keys).to eq %w[4475361640994a5f97c653eb758e7a9d] }
        end

        context "block.comments" do
          let(:base) { Block.find TestConnection::H1_BLOCK_ID }

          it { expect(subject.keys).to eq %w[d5946de25da24be6adc55b1436585c60 02faa2c0f7e243ae9a0a56546cbe34f0] }
        end
      end

      context "dry_run: true" do
        let(:dry_run) { target.comments dry_run: true }

        context "page.comments" do
          let(:target) { Page.find TestConnection::TOP_PAGE_ID }

          it_behaves_like "dry run", :get, :retrieve_comments_path, use_id: true
        end

        context "block.comments" do
          let(:target) { Block.find TestConnection::H1_BLOCK_ID }

          it_behaves_like "dry run", :get, :retrieve_comments_path, use_id: true
        end
      end
    end

    describe "append_comment" do
      let(:discussion) { Page.find(TestConnection::TOP_PAGE_ID).comments.values.first }

      context "dry_run: false" do
        let(:target) { discussion.append_comment "test comment to discussion" }

        it { expect(target.discussion_id).to eq "4475361640994a5f97c653eb758e7a9d" }
      end

      context "dry_run: true" do
        let(:dry_run) { discussion.append_comment "test comment to discussion", dry_run: true }

        it_behaves_like "dry run", :post, :comments_path, json: {
          "rich_text": [
            {
              type: "text",
              text: {
                content: "test comment to discussion",
                link: nil,
              },
              plain_text: "test comment to discussion",
              href: nil,
            },
          ],
          discussion_id: "4475361640994a5f97c653eb758e7a9d",
        }
      end
    end
  end
end
