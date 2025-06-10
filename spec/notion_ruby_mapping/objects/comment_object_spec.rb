# frozen_string_literal: true

module NotionRubyMapping
  RSpec.describe CommentObject do
    tc = TestConnection.instance
    comment_json = tc.read_json "comment_object_top_page"

    describe "create from json" do
      let(:target) { CommentObject.new json: comment_json }

      it { expect(target.full_text).to eq "Comment to a page" }
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
