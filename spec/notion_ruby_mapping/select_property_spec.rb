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

    describe "a select property with parameters" do
      let(:property) { SelectProperty.new "sp", select: "Select 1" }
      subject { property.create_json }
      it { is_expected.to eq({"select" => {"name" => "Select 1"}}) }
      it "will not update" do
        expect(property.will_update).to be_falsey
      end

      describe "select=" do
        before { property.select = "Select 1" }
        it { is_expected.to eq({"select" => {"name" => "Select 1"}}) }
        it "will update" do
          expect(property.will_update).to be_truthy
        end
      end
    end

    describe "create_from_json" do
      let(:json) { {"select" => {"name" => "Select 1"}} }
      let(:property) { Property.create_from_json "sp", json }
      it "has_name" do
        expect(property.name).to eq "sp"
      end

      it "create_json" do
        expect(property.create_json).to eq({"select" => {"name" => "Select 1"}})
      end

      it "will not update" do
        expect(property.will_update).to be_falsey
      end
    end
  end
end
