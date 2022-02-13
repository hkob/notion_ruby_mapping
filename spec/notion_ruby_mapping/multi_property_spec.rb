# frozen_string_literal: true

module NotionRubyMapping
  [
    [MultiSelectProperty, :multi_select],
    [PeopleProperty, :people],
    [CreatedByProperty, :created_by],
    [LastEditedByProperty, :last_edited_by],
    [RelationProperty, :relation],
  ].each do |c, sym|
    RSpec.describe c do
      let(:property) { c.new "up" }
      describe "a user property" do
        it "has name" do
          expect(property.name).to eq "up"
        end

        context "create query" do
          subject { query.filter }
          %i[contains does_not_contain].each do |key|
            context key do
              let(:query) { property.send "filter_#{key}", "abc" }
              it { is_expected.to eq({property: "up", sym => {key => "abc"}}) }
            end
          end

          %i[is_empty is_not_empty].each do |key|
            context key do
              let(:query) { property.send "filter_#{key}" }
              it { is_expected.to eq({property: "up", sym => {key => true}}) }
            end
          end
        end
      end
    end
  end
end
