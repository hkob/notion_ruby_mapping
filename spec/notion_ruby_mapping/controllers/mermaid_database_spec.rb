# frozen_string_literal: true

require_relative "../../spec_helper"

module NotionRubyMapping
  RSpec.describe MermaidDatabase do
    DATABASE_ID = TestConnection::DATABASE_ID

    let(:mdb_abc) { described_class.new "abc" }
    let(:mdb_def) { described_class.new "def" }

    describe "constructor" do
      let(:target) { mdb_abc }

      it { expect(target).to be_a described_class }
      it { expect(target.name).to eq "abc" }
    end

    describe "name=" do
      before { mdb_abc.name = "db_title" }

      it { expect(mdb_abc.name).to eq "db_title" }
    end

    describe "add_property" do
      context "when title" do
        before { mdb_abc.add_property "title", "titleValue" }

        it { expect(mdb_abc.title).to eq "titleValue" }
      end

      context "when other property" do
        before { mdb_abc.add_property "number", "Price|yen" }

        it { expect(mdb_abc.properties["Price|yen"]).to eq "number" }
      end
    end

    describe "append_relation_queue" do
      before { mdb_abc.append_relation_queue mdb_def, "forward" }

      it { expect(mdb_abc.relation_queue).to eq [["forward", mdb_def]] }
    end

    describe "update_properties" do
      subject { mdb_abc.update_properties["properties"][check_key] }
      before { mdb_abc.attach_database Database.find(DATABASE_ID) }

      context "when non-dependent properties" do
        {
          checkbox: ["Done", {}],
          created_by: ["Created by", {}],
          created_time: ["Created at", {}],
          date: ["Date", {}],
          email: ["E-mail", {}],
          files: ["File & media", {}],
          formula: [
            "non expression", {"expression" => nil},
            "now|now()", {"expression" => "now()"}
          ],
          last_edited_by: ["Last edited by", {}],
          last_edited_time: ["Last edited at", {}],
          people: ["Staff", {}],
          phone_number: ["Tel", {}],
          rich_text: ["Description", {}],
          url: ["Link", {}],
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
            context "#{key_str}:#{str}" do
              let(:check_key) { str_only }

              before { mdb_abc.add_property key_str, str }

              it { is_expected.to eq({key_str => ans}) }
            end
          end
        end
      end

      context "when dependent formula" do
        let(:str) { "Week number|formatDate(prop(@Date@), @w@)" }
        let(:check_key) { str.split("|")[0] }

        before { mdb_abc.add_property "formula", str }

        context "when dependent properties were not created/updated" do
          it { is_expected.to be_nil }
        end

        context "when dependent properties were created" do
          before { mdb_abc.finish_flag["Date"] = true }

          let(:formula_ans) do
            {
              "formula" => {
                "expression" => %[formatDate(prop("Date"), "w")],
              },
            }
          end

          it { is_expected.to eq formula_ans }
        end
      end

      describe "relation" do
        before do
          mdb_abc.attach_database Database.find(DATABASE_ID)
          mdb_def.attach_database Database.find(DATABASE_ID)
        end

        let(:target) { mdb_abc.update_properties }

        subject { target["properties"]["forward"] }
        context "when single_property" do
          before do
            mdb_abc.append_relation_queue mdb_def, "forward"
          end

          let(:one_way_ans) do
            {"database_id" => DATABASE_ID, "type" => "single_property", "single_property" => {}}
          end

          it { is_expected.to eq("relation" => one_way_ans) }
        end

        context "when dual_property" do
          before { mdb_abc.append_relation_queue mdb_def, "forward|reverse" }

          let(:dual_property_ans) do
            {
              "database_id" => DATABASE_ID,
              "type" => "dual_property",
              "dual_property" => {},
            }
          end

          it { is_expected.to eq({"relation" => dual_property_ans}) }

          it {
            target
            expect(mdb_def.properties["reverse"]).to eq "relation"
          }
        end
      end

      describe "when rollup" do
        let(:str) { "progress|tasks|Status|percent_per_group" }
        let(:check_key) { str.split("|")[0] }
        let(:rollup_ans) do
          {
            "rollup" => {
              "function" => "percent_per_group",
              "relation_property_name" => "tasks",
              "rollup_property_name" => "Status",
            },
          }
        end

        before do
          mdb_abc.add_property "rollup", str
          mdb_abc.relations["tasks"] = mdb_def
          mdb_def.attach_database Database.find(DATABASE_ID)
        end

        context "when relation property was not created/updated" do
          it { is_expected.to be_nil }
        end

        context "when rollup property was not created/updated" do
          before { mdb_abc.finish_flag["tasks"] = true }

          it { is_expected.to be_nil }
        end

        context "when rollup property was created" do
          before do
            mdb_abc.finish_flag["tasks"] = true
            mdb_def.finish_flag["Status"] = true
          end

          it { is_expected.to eq rollup_ans }
        end
      end
    end
  end
end
