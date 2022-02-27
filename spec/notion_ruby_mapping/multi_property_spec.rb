# frozen_string_literal: true

module NotionRubyMapping
  [MultiSelectProperty, CreatedByProperty, LastEditedByProperty, RelationProperty].each do |c|
    RSpec.describe c do
      let(:property) { c.new "up" }
      describe "a user property" do
        it "has name" do
          expect(property.name).to eq "up"
        end

        context "create query" do
          it_behaves_like :filter_test, c, %w[contains does_not_contain], value: "abc"
          it_behaves_like :filter_test, c, %w[is_empty is_not_empty]
          subject { query.filter }
        end
      end
    end
  end
end
