# frozen_string_literal: true

require_relative "../../spec_helper"

module NotionRubyMapping
  RSpec.describe MermaidDatabase do
    DATABASE_ID = TestConnection::DATABASE_ID

    let(:mdb1) { described_class.new "abc" }
    let(:mdb2) { described_class.new "def" }

    describe "constructor" do
      let(:target) { mdb1 }

      it { expect(target).to be_a described_class }
      it { expect(target.name).to eq "abc" }
    end

    describe "name=" do
      before { mdb1.name = "db_title" }

      it { expect(mdb1.name).to eq "db_title" }
    end

    describe "add_property" do
      context "when title" do
        before { mdb1.add_property "title", "titleValue" }

        it { expect(mdb1.title).to eq "titleValue" }
      end

      context "when other property" do
        before { mdb1.add_property "number", "Price|yen" }

        it { expect(mdb1.properties["Price|yen"]).to eq "number" }
      end
    end

    describe "append_relation" do
      before { mdb1.append_relation mdb2, "forward" }

      it { expect(mdb1.relations).to eq({"forward" => mdb2}) }
    end

    describe "update_properties" do
      subject { mdb1.update_properties["properties"][check_key] }
      {
        checkbox: ["Done", {}],
        created_by: ["Created by", {}],
        created_time: ["Created at", {}],
        date: ["Date", {}],
        email: ["E-mail", {}],
        files: ["File & media", {}],
        last_edited_by: ["Last edited by", {}],
        last_edited_time: ["Last edited at", {}],
        people: ["Staff", {}],
        phone_number: ["Tel", {}],
        rich_text: ["Description", {}],
        url: ["Link", {}],
        formula: [
          "non expression", {"expression" => nil},
          "now|now()", {"expression" => "now()"}
        ],
        multi_select: [
          "non multi selection", {"options" => []},
          "multi_select_tags|SEL1|SEL2|SEL3", {
            "options" => %w[SEL1 SEL2 SEL3].map do |s|
              {"color" => "default", "name" => s}
            end,
          }
        ],
        number: [
          "no format", {"format" => "number"},
          "price|yen", {"format" => "yen"}
        ],
        select: [
          "non selection", {"options" => []},
          "select_tags|SEL1|SEL2|SEL3", {
            "options" => %w[SEL1 SEL2 SEL3].map do |s|
              {"color" => "default", "name" => s}
            end,
          }
        ],
      }.each do |key, array|
        key_str = key.to_s
        array.each_slice(2) do |str, ans|
          str_only = str.split("|")[0]
          context "#{key}:#{str}" do
            let(:check_key) { str_only }

            before do
              mdb1.add_property key_str, str
              mdb1.attach_database Database.find(DATABASE_ID)
            end

            it { is_expected.to eq({key_str => ans}) }
          end
        end
      end
    end

    describe "relation" do
      before do
        mdb1.attach_database Database.find(DATABASE_ID)
        mdb2.attach_database Database.find(DATABASE_ID)
      end

      subject { mdb1.update_properties["properties"]["forward"] }
      context "when single_property" do
        before do
          mdb1.append_relation mdb2, "forward"
        end
        let(:one_way_ans) {
          {"database_id" => DATABASE_ID, "type" => "single_property", "single_property" => {}}
        }

        it { is_expected.to eq("relation" => one_way_ans) }
      end

      context "dual_property" do
        before do
          mdb1.append_relation mdb2, "forward|reverse"
        end
        let(:dual_property_ans) {
          {
            "database_id" => DATABASE_ID,
            "type" => "dual_property",
            "dual_property" => {}
          }
        }

        it { is_expected.to eq("relation" => dual_property_ans) }
      end
    end

    describe "update_rollup_schema" do
      subject { mdb1.update_rollup_schema["properties"][check_key] }
      {
        rollup: [
          "progress|tasks|Status|percent_per_group",
          {
            "function" => "percent_per_group",
            "relation_property_name" => "tasks",
            "rollup_property_name" => "Status",
          },
        ],
      }.each do |key, array|
        key_str = key.to_s
        array.each_slice(2) do |str, ans|
          str_only = str.split("|")[0]
          context "#{key}:#{str}" do
            let(:check_key) { str_only }

            before do
              mdb1.add_property key_str, str
              mdb1.attach_database Database.find(DATABASE_ID)
            end

            it { is_expected.to eq({key_str => ans}) }
          end
        end
      end
    end
  end
end
