# frozen_string_literal: true

require_relative "../../spec_helper"

module NotionRubyMapping
  RSpec.describe Mermaid do
    TEST_MERMAID_TEXT = <<~"MERMAID_TEXT"
      erDiagram
        AsciiDatabase ||--o{ db1 : "日本語s|ascii"
        db1 ||--|| db2 : "One way"

        AsciiDatabase {
          title Name
          number Number
        }

        db1 {
          Database title "日本語データベース"
          title p0 "名前"
          number p1 "数値"
        }

        db2 {
          Database title "English with space"
          title p0 "Title with space"
          select p1 "Selection for some tags|SEL1|SEL2|SEL3"
        }
    MERMAID_TEXT
    let(:mermaid) { described_class.new TEST_MERMAID_TEXT }

    describe "constructor" do
      let(:target) { described_class.new "abc" }

      it { expect(target).to be_a described_class }
    end

    describe "database titles" do
      let(:target) { described_class.new full_text }

      subject { target.databases.values.map(&:name) }
      context "when no text" do
        let(:full_text) { "abc" }

        it { is_expected.to eq [] }
      end

      context "when AsciiDatabase" do
        let(:full_text) { "erDiagram\n  AsciiDatabase {\n    title Name\n  }\n" }

        it { is_expected.to eq %w[AsciiDatabase] }
      end

      context "when 日本語データベース" do
        let(:full_text) { %(erDiagram\n  db1 {\n    Database title "日本語データベース"\n    title p0 "名前"\n  }\n) }

        it { is_expected.to eq %w[日本語データベース] }
      end

      context "when parallel values" do
        let(:full_text) { TEST_MERMAID_TEXT }

        it { is_expected.to eq ["AsciiDatabase", "日本語データベース", "English with space"] }
      end
    end

    describe "database attributes" do
      {
        "title" => {"AsciiDatabase" => "Name", "db1" => "名前"},
        "number" => {"AsciiDatabase" => "Number", "db1" => "数値"},
      }.each do |property_type, hash|
        context "when #{property_type}" do
          subject { db.properties[title_value] }
          hash.each do |key, title_value|
            context key do
              let(:db) { mermaid.databases[key] }
              if property_type == "title"
                it { expect(db.title).to eq title_value }
              else
                let(:title_value) { title_value }

                it { is_expected.to eq property_type }
              end
            end
          end
        end
      end
    end

    describe "database relations" do
      let(:dbs) { mermaid.databases }
      let(:adb) { dbs["AsciiDatabase"] }
      let(:db1) { dbs["db1"] }
      let(:db2) { dbs["db2"] }

      it { expect(adb.relations).to eq({"日本語s|ascii" => db1}) }
      it { expect(db1.relations).to eq({"One way" => db2}) }
    end

    describe "attach_database" do
      before { mermaid.attach_database db }

      let(:db) { instance_double(Database, database_title: instance_double(RichTextArray, full_text: db_title)) }

      context "when exist database" do
        let(:db_title) { "AsciiDatabase" }

        it { expect(mermaid.databases["AsciiDatabase"].real_db).to eq db }
      end

      context "when 日本語データベース" do
        let(:db_title) { "日本語データベース" }

        it { expect(mermaid.databases["db1"].real_db).to eq db }
      end
    end
  end
end
