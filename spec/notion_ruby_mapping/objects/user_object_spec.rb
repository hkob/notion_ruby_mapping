# frozen_string_literal: true

module NotionRubyMapping
  RSpec.describe UserObject do
    tc = TestConnection.instance
    hkob_json = tc.read_json "retrieve_user_person_hkob"
    token_bot_json = tc.read_json "retrieve_user_token_bot"

    describe "self.user_object" do
      subject { UserObject.user_object uo }
      context "when String" do
        let(:uo) { "user_id from String" }

        it { expect(subject).to be_is_a UserObject }
        it { expect(subject.user_id).to eq "user_id from String" }
      end

      context "when UserObject" do
        let(:uo) { UserObject.new user_id: "user_id" }

        it { expect(subject).to be_is_a UserObject }
        it { expect(subject.user_id).to eq "user_id" }
      end
    end

    describe "property_values_json" do
      context "when person object" do
        let(:target) { UserObject.new user_id: "user_id" }

        it_behaves_like "property values json", {
          "object" => "user",
          "id" => "user_id",
        }
      end
    end

    describe "create_from_json" do
      let(:target) { UserObject.new json: json }

      context "when person object" do
        let(:json) { hkob_json }

        it_behaves_like "property values json", {
          "object" => "user",
          "id" => "2200a9116a9644bbbd386bfb1e01b9f6",
        }
        it { expect(target.name).to eq "Hiroyuki KOBAYASHI" }
      end

      context "when bot object" do
        let(:json) { token_bot_json }

        it_behaves_like "property values json", {
          "object" => "user",
          "id" => "019a87c7d19744a4b19abaa684400f81",
        }
      end
    end

    describe "self.find" do
      user_id = TestConnection::USER_HKOB_ID
      context "dry_run: false" do
        let(:target) { UserObject.find user_id }

        it_behaves_like "property values json", {
          "object" => "user",
          "id" => user_id,
        }
        it { expect(target.name).to eq "Hiroyuki KOBAYASHI" }
      end

      context "dry_run: true" do
        let(:dry_run) { UserObject.find user_id, dry_run: true }

        it_behaves_like "dry run", :get, :user_path, id: user_id
      end
    end

    describe "self.find_me" do
      user_id = TestConnection::USER_BOT_ID
      context "dry_run: false" do
        let(:target) { UserObject.find_me }

        it_behaves_like "property values json", {
          "object" => "user",
          "id" => user_id,
        }
        it { expect(target.name).to eq "notion_ruby_mapping" }
      end

      context "dry_run: true" do
        let(:dry_run) { UserObject.find_me dry_run: true }

        it_behaves_like "dry run", :get, :user_path, id: "me"
      end
    end

    describe "self.all" do
      context "dry_run: false" do
        let(:target) { UserObject.all }

        it { expect(target.count).to eq 7 }
      end

      context "dry_run: true" do
        let(:dry_run) { UserObject.all dry_run: true }

        it_behaves_like "dry run", :get, :users_path
      end
    end

    describe "user_id=" do
      let(:target) { UserObject.user_object "user_id" }

      before { target.user_id = "new_user_id" }

      it_behaves_like "property values json", {
        "object" => "user",
        "id" => "new_user_id",
      }
    end
  end
end
