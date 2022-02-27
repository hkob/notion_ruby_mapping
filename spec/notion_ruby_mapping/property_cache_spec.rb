# frozen_string_literal: true

require_relative "../spec_helper"

module NotionRubyMapping
  RSpec.describe PropertyCache do
    describe "constructor" do
      context "without json" do
        let(:property_cache) { PropertyCache.new }
        it "can create an object" do
          expect(property_cache).not_to be_nil
        end
      end

      context "with json" do
        let(:json) { {"np" => {"type" => "number", "number" => 123}} }
        let(:property_cache) { PropertyCache.new json }
        context "without json" do
          it "can create an object" do
            expect(property_cache).not_to be_nil
          end

          it "has a NumberProperty" do
            expect(property_cache["np"]).to be_an_instance_of(NumberProperty)
          end
        end
      end
    end

    describe "add_property" do
      subject { PropertyCache.new }
      let(:np) { NumberProperty.new "np", number: 123 }
      before { subject.add_property np }
      context "no update" do
        it "has the NumberProperty" do
          expect(subject["np"]).to eq np
        end

        it "the NumberProperty will not update" do
          expect(subject["np"].will_update).to be_falsey
        end
      end

      context "update value" do
        before { np.number = 456 }
        it "has the NumberProperty" do
          expect(subject["np"]).to eq np
        end

        it "the NumberProperty will not update" do
          expect(subject["np"].will_update).to be_truthy
        end

        it "can generate json" do
          expect(subject.property_values_json).to eq({"properties" => {"np" => {"number" => 456, "type" => "number"}}})
        end
      end
    end

    describe "enumerators" do
      subject { PropertyCache.new }
      let(:np) { NumberProperty.new "np", number: 123 }
      let(:tp) { TitleProperty.new "tp", text_objects: [TextObject.new("ABC")] }
      before { [np, tp].each { |p| subject.add_property p } }
      it "can map properties" do
        expect(subject.map(&:name)).to eq %w[np tp]
      end

      it "can select properties" do
        expect(subject.filter { |p| p.is_a? TitleProperty }).to eq [tp]
      end

      it "can obtain some properties using values_at" do
        expect(subject.values_at("np", "tp")).to eq [np, tp]
      end
    end
  end
end
