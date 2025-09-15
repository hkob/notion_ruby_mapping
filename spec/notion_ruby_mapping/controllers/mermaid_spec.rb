# frozen_string_literal: true

require_relative "../../spec_helper"

module NotionRubyMapping
  RSpec.describe Mermaid do
    test_mermaid_text = <<~"MERMAID_TEXT"
      erDiagram
        AsciiDataSource ||--o{ ds1 : "日本語s|ascii"
        ds1 ||--|| ds2 : "One way"

        AsciiDataSource {
          title Name
          number Number
        }

        ds1 {
          DataSource title "日本語データベース"
          title p0 "名前"
          number p1 "数値"
        }

        ds2 {
          DataSource title "English with space"
          title p0 "Title with space"
          select p1 "Selection for some tags|SEL1|SEL2|SEL3"
        }
    MERMAID_TEXT
    let(:mermaid) { Mermaid.new test_mermaid_text }

    describe "constructor" do
      let(:target) { described_class.new "abc" }

      it { expect(target).to be_a described_class }
    end

    describe "data source titles" do
      let(:target) { described_class.new full_text }

      subject { target.data_sources.values.map(&:name) }
      context "when no text" do
        let(:full_text) { "abc" }

        it { is_expected.to eq [] }
      end

      context "when AsciiDataSource" do
        let(:full_text) { "erDiagram\n  AsciiDataSource {\n    title Name\n  }\n" }

        it { is_expected.to eq %w[AsciiDataSource] }
      end

      context "when 日本語データベース" do
        let(:full_text) { %(erDiagram\n  ds1 {\n    DataSource title "日本語データベース"\n    title p0 "名前"\n  }\n) }

        it { is_expected.to eq %w[日本語データベース] }
      end

      context "when parallel values" do
        let(:full_text) { test_mermaid_text }

        it { is_expected.to eq ["AsciiDataSource", "日本語データベース", "English with space"] }
      end
    end

    describe "data source attributes" do
      {
        "title" => {AsciiDataSource: "Name", ds1: "名前"},
        "number" => {AsciiDataSource: "Number", ds1: "数値"},
      }.each do |property_type, hash|
        context "when #{property_type}" do
          subject { ds.properties[title_value] }
          hash.each do |key, title_value|
            context key do
              let(:ds) { mermaid.data_sources[key.to_s] }

              if property_type == "title"
                it { expect(ds.title).to eq title_value }
              else
                let(:title_value) { title_value }

                it { is_expected.to eq property_type }
              end
            end
          end
        end
      end
    end

    describe "data source relations" do
      let(:dss) { mermaid.data_sources }
      let(:ads) { dss["AsciiDataSource"] }
      let(:ds1) { dss["ds1"] }
      let(:ds2) { dss["ds2"] }

      it { expect(ads.relation_queue).to eq [["日本語s|ascii", ds1]] }
      it { expect(ds1.relation_queue).to eq [["One way", ds2]] }
    end

    describe "attach_data_source" do
      before { mermaid.attach_data_source ds }

      let(:ds) { instance_double(DataSource, data_source_title: instance_double(RichTextArray, full_text: ds_title)) }

      context "when exist data source" do
        let(:ds_title) { "AsciiDataSource" }

        it { expect(mermaid.data_sources["AsciiDataSource"].real_ds).to eq ds }
      end

      context "when 日本語データベース" do
        let(:ds_title) { "日本語データベース" }

        it { expect(mermaid.data_sources["ds1"].real_ds).to eq ds }
      end
    end
  end
end
