# frozen_string_literal: true

module NotionRubyMapping
  RSpec.describe SelectProperty do
    let(:property) { SelectProperty.new "sp" }
    describe "a select property" do
      it "has name" do
        expect(property.name).to eq "sp"
      end

      context "create query" do
        subject { query.filter }
        %w[equals does_not_equal].each do |key|
          context key do
            let(:query) { property.send "filter_#{key}", "abc" }
            it { is_expected.to eq({"property" => "sp", "select" => {key => "abc"}}) }
          end
        end

        %w[is_empty is_not_empty].each do |key|
          context key do
            let(:query) { property.send "filter_#{key}" }
            it { is_expected.to eq({"property" => "sp", "select" => {key => true}}) }
          end
        end
      end
    end
  end
end
