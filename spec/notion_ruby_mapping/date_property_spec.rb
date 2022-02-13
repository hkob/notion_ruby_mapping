# frozen_string_literal: true

module NotionRubyMapping
  [
    [DateProperty, :date],
    [CreatedTimeProperty, :created_time],
    # [LastEditedTime, :last_edited_time],
  ].each do |c, sym|
    RSpec.describe c do
      let(:property) { c.new "dp" }
      describe "a date property" do
        it "has name" do
          expect(property.name).to eq "dp"
        end

        context "create query for date" do
          subject { query.filter }
          [
            ["date", Date.new(2022, 2, 12), "2022-02-12"],
            ["time", Time.new(2022, 2, 12, 1, 23, 45, "+09:00"), "2022-02-12T01:23:45+09:00"],
          ].each do |(title, d, ds)|
            context "on parameter #{title}" do
              %i[equals before after on_or_before on_or_after].each do |key|
                context key do
                  let(:query) { property.send "filter_#{key}", d }
                  it { is_expected.to eq({property: "dp", sym => {key => ds}}) }
                end
              end
            end
          end

          %i[is_empty is_not_empty].each do |key|
            context key do
              let(:query) { property.send "filter_#{key}" }
              it { is_expected.to eq({property: "dp", sym => {key => true}}) }
            end
          end

          %i[past_week past_month past_year next_week next_month next_year].each do |key|
            context key do
              let(:query) { property.send "filter_#{key}" }
              it { is_expected.to eq({property: "dp", sym => {key => {}}}) }
            end
          end
        end
      end
    end
  end
end
