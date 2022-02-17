# frozen_string_literal: true

module NotionRubyMapping
  RSpec.describe FormulaProperty do
    let(:property) { FormulaProperty.new "fp" }
    describe "a formula property" do
      it "has name" do
        expect(property.name).to eq "fp"
      end

      context "create query" do
        subject { query.filter }
        [
          ["date", Date.new(2022, 2, 12), "2022-02-12"],
          ["time", Time.new(2022, 2, 12, 1, 23, 45, "+09:00"), "2022-02-12T01:23:45+09:00"],
        ].each do |(title, d, ds)|
          context "on parameter #{title}" do
            %w[equals before after on_or_before on_or_after].each do |key|
              context key do
                let(:query) { property.send "filter_#{key}", d }
                it { is_expected.to eq({"property" => "fp", "formula" => {key => ds}}) }
              end
            end
          end
        end

        %w[does_not_equal contains does_not_contain starts_with ends_with on_or_before on_or_after].each do |key|
          context key do
            let(:query) { property.send "filter_#{key}", "abc" }
            it { is_expected.to eq({"property" => "fp", "formula" => {key => "abc"}}) }
          end
        end

        %w[is_empty is_not_empty].each do |key|
          context key do
            let(:query) { property.send "filter_#{key}" }
            it { is_expected.to eq({"property" => "fp", "formula" => {key => true}}) }
          end
        end

        %w[past_week past_month past_year next_week next_month next_year].each do |key|
          context key do
            let(:query) { property.send "filter_#{key}" }
            it { is_expected.to eq({"property" => "fp", "formula" => {key => {}}}) }
          end
        end
      end
    end
  end
end
