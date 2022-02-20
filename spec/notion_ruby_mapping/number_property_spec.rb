# frozen_string_literal: true

module NotionRubyMapping
  RSpec.describe NumberProperty do
    describe "a number property without parameter" do
      let(:property) { NumberProperty.new "np" }
      it "has name" do
        expect(property.name).to eq "np"
      end

      context "create query" do
        subject { query.filter }
        %w[equals does_not_equal greater_than less_than	greater_than_or_equal_to less_than_or_equal_to].each do |key|
          context key do
            let(:query) { property.send "filter_#{key}", 100 }
            it { is_expected.to eq({"property" => "np", "number" => {key => 100}}) }
          end
        end

        %w[is_empty is_not_empty].each do |key|
          context key do
            let(:query) { property.send "filter_#{key}" }
            it { is_expected.to eq({"property" => "np", "number" => {key => true}}) }
          end
        end
      end
    end

    describe "a number property with parameters" do
      let(:property) { NumberProperty.new "np", number: 3.14 }
      subject { property.create_json }
      it { is_expected.to eq({"number" => 3.14}) }
      it "will not update" do
        expect(property.will_update).to be_falsey
      end

      describe "number=" do
        before { property.number = 2022 }
        it { is_expected.to eq({"number" => 2022}) }
        it "will update" do
          expect(property.will_update).to be_truthy
        end
      end
    end

    describe "create_from_json" do
      let(:json) { {"type" => "number", "number" => 123} }
      let(:property) { Property.create_from_json "np", json }
      it "has_name" do
        expect(property.name).to eq "np"
      end

      it "create_json" do
        expect(property.create_json).to eq({"number" => 123})
      end

      it "will not update" do
        expect(property.will_update).to be_falsey
      end
    end
  end
end
