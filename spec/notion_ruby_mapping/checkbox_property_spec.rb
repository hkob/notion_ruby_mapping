# frozen_string_literal: true

module NotionRubyMapping
  RSpec.describe CheckboxProperty do
    let(:property) { CheckboxProperty.new "cp" }
    describe "a checkbox property" do
      it "has name" do
        expect(property.name).to eq "cp"
      end

      context "create query" do
        subject { query.filter }
        %w[equals does_not_equal].each do |key|
          context key do
            let(:query) { property.send "filter_#{key}", true }
            it { is_expected.to eq({"property" => "cp", "checkbox" => {key => true}}) }
          end
        end
      end
    end
  end
end
