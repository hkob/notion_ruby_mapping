# frozen_string_literal: true

module NotionRubyMapping
  RSpec.describe FilesProperty do
    let(:property) { FilesProperty.new "fp" }
    describe "a files property" do
      it "has name" do
        expect(property.name).to eq "fp"
      end

      context "create query" do
        subject { query.filter }
        %w[is_empty is_not_empty].each do |key|
          context key do
            let(:query) { property.send "filter_#{key}" }
            it { is_expected.to eq({"property" => "fp", "files" => {key => true}}) }
          end
        end
      end
    end
  end
end
