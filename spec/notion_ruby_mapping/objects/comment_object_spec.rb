# frozen_string_literal: true

module NotionRubyMapping
  RSpec.describe CommentObject do
    tc = TestConnection.instance
    comment_json = tc.read_json "comment_object_top_page"

    describe "create from json" do
      let(:target) { CommentObject.new json: comment_json }

      it { expect(target.full_text).to eq "Comment to a page" }
    end

    describe "find" do
      let(:target) { CommentObject.find TestConnection::EDIT_TEXT_COMMENT_ID }

      it { expect(target.full_text).to eq "comment for edit text" }
    end

    describe "update_comment" do
      let(:target) { CommentObject.find TestConnection::EDIT_TEXT_COMMENT_ID }

      context "when update by rich_text" do
        before { target.rich_text_objects = "update comment by rich text" }

        context "when dry_run" do
          let(:dry_run) { target.save dry_run: true }

          it_behaves_like "dry run", :patch, :comment_path, use_id: true, json: {
            "rich_text" => [
              {
                "type" => "text",
                "text" => {
                  "content": "update comment by rich text",
                  "link": nil,
                },
                "plain_text" => "update comment by rich text",
                "href" => nil,
              },
            ],
          }
        end

        context "when save" do
          before { target.save }

          it { expect(target.full_text).to eq "update comment by rich text" }
        end
      end

      context "when update by markdown" do
        before { target.markdown = "update comment by markdown" }

        context "when dry_run" do
          let(:dry_run) { target.save dry_run: true }

          it_behaves_like "dry run", :patch, :comment_path, use_id: true, json: {
            "markdown" => "update comment by markdown",
          }
        end

        context "when save" do
          before { target.save }

          it { expect(target.full_text).to eq "update comment by markdown" }
        end
      end
    end

    describe "destroy" do
      let(:id) { TestConnection::EDIT_TEXT_COMMENT_ID }
      let(:target) { CommentObject.find id }

      context "dry_run" do
        let(:dry_run) { target.destroy dry_run: true }

        it_behaves_like "dry run", :delete, :comment_path, use_id: true
      end

      context "delete" do
        let(:deleted_item) { target.destroy }

        it "receive id" do
          expect(deleted_item.id).to eq id
        end
      end
    end

    # describe "self.comment_object" do
    #   subject { CommentObject.comment_object eo
    #   context "String" do
    #     let(:eo) { "🐶" }
    #     it { expect(subject).to be_is_a CommentObject }
    #     it { expect(subject.comment).to eq "🐶" }
    #   end
    #
    #   context "CommentObject" do
    #     let(:eo) { CommentObject.new comment: "💿" }
    #     it { expect(subject).to be_is_a CommentObject }
    #     it { expect(subject.comment).to eq "💿" }
    #   end
    # end
    #
    # describe "property_values_json" do
    #   let(:target) { CommentObject.new comment: "🟠" }
    #   it_behaves_like :property_values_json, {
    #     "type" => "comment",
    #     "comment" => "🟠",
    #   }
    # end
    #
    # describe "comment=" do
    #   let(:target) { CommentObject.new comment: "🟠" }
    #   before { target.comment = "✅" }
    #   it { expect(target.comment).to eq "✅" }
    #   it { expect(target.will_update).to eq true }
    # end
  end
end
