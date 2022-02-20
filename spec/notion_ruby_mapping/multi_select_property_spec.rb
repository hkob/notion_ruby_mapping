# frozen_string_literal: true

module NotionRubyMapping
  RSpec.describe MultiSelectProperty do
    let(:nms1ms2) { [{"name" => "Multi Select 1"}, {"name" => "Multi Select 2"}] }
    let(:ms1ms2) { ["Multi Select 1", "Multi Select 2"] }
    describe "a select property with parameters" do
      let(:property) { MultiSelectProperty.new "msp", multi_select: ["Multi Select 1", "Multi Select 2"] }
      subject { property.create_json }
      it { is_expected.to eq({"multi_select" => nms1ms2}) }
      it "will not update" do
        expect(property.will_update).to be_falsey
      end

      describe "multi_select=" do
        context "a value" do
          before { property.multi_select = "Multi Select 1"}
          it { is_expected.to eq({"multi_select" => [{"name" => "Multi Select 1"}]}) }
          it "will update" do
            expect(property.will_update).to be_truthy
          end
        end

        context "an array value" do
          before { property.multi_select = ms1ms2 }
          it { is_expected.to eq({"multi_select" => nms1ms2}) }
          it "will update" do
            expect(property.will_update).to be_truthy
          end
        end
      end

      describe "multi_select_values=" do
        before { property.multi_select = ["Multi Select 1", "Multi Select 2"] }
        it { is_expected.to eq({"multi_select" => nms1ms2}) }
        it "will update" do
          expect(property.will_update).to be_truthy
        end
      end
    end

    describe "create_from_json" do
      let(:json) { {"multi_select" => nms1ms2 } }
      let(:property) { Property.create_from_json "msp", json }
      it "has_name" do
        expect(property.name).to eq "msp"

      end

      it "create_json" do
        expect(property.create_json).to eq json
      end

      it "will not update" do
        expect(property.will_update).to be_falsey
      end
    end
  end
end
