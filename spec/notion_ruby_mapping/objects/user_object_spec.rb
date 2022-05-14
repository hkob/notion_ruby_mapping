# frozen_string_literal: true

module NotionRubyMapping
  RSpec.describe UserObject do
    tc = TestConnection.instance
    hkob_json = tc.read_json "retrieve_user_person_hkob"
    token_bot_json = tc.read_json "retrieve_user_token_bot"

    describe "self.user_object" do
      subject { UserObject.user_object uo }
      context "String" do
        let(:uo) { "user_id from String" }
        it { expect(subject).to be_is_a UserObject }
        it { expect(subject.user_id).to eq "user_id from String" }
      end

      context "UserObject" do
        let(:uo) { UserObject.new user_id: "user_id" }
        it { expect(subject).to be_is_a UserObject }
        it { expect(subject.user_id).to eq "user_id" }
      end
    end

    describe "property_values_json" do
      context "person object" do
        let(:target) { UserObject.new user_id: "user_id" }
        it_behaves_like :property_values_json, {
          "object" => "user",
          "id" => "user_id",
        }
      end
    end

    describe "create_from_json" do
      let(:target) { UserObject.new json: json }
      context "person object" do
        let(:json) { hkob_json }
        it_behaves_like :property_values_json, {
          "object" => "user",
          "id" => "2200a911-6a96-44bb-bd38-6bfb1e01b9f6",
        }
        it { expect(target.name).to eq "Hiroyuki KOBAYASHI" }
      end

      context "bot object" do
        let(:json) { token_bot_json }
        it_behaves_like :property_values_json, {
          "object" => "user",
          "id" => "019a87c7-d197-44a4-b19a-baa684400f81",
        }
      end
    end

    describe "user_id=" do
      let(:target) { UserObject.user_object "user_id" }
      before { target.user_id = "new_user_id" }
      it_behaves_like :property_values_json, {
        "object" => "user",
        "id" => "new_user_id",
      }
    end
  end
end
