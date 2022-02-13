# frozen_string_literal: true

module NotionRubyMapping
  RSpec.describe NumberProperty do
    let(:property) { NumberProperty.new "np" }
    describe "a number property" do
      it "has name" do
        expect(property.name).to eq "np"
      end

      context "create query" do
        subject { query.filter }
        %i[equals does_not_equal greater_than less_than	greater_than_or_equal_to less_than_or_equal_to].each do |key|
          context key do
            let(:query) { property.send "filter_#{key}", 100 }
            it { is_expected.to eq({property: "np", number: {key => 100}}) }
          end
        end

        %i[is_empty is_not_empty].each do |key|
          context key do
            let(:query) { property.send "filter_#{key}" }
            it { is_expected.to eq({property: "np", number: {key => true}}) }
          end
        end
      end
    end
  end
end
