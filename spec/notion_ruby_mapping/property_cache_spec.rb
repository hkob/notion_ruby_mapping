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
      let(:property_cache) { PropertyCache.new }
      let(:np) { NumberProperty.new "np", number: 123 }
      context "no update" do
        subject { property_cache.add_property np }
        it "has the NumberProperty" do
          expect(subject["np"]).to eq np
        end

        it "the NumberProperty will not update" do
          expect(subject["np"].will_update).to be_falsey
        end
      end

      context "no update" do
        subject { property_cache.add_property np, will_update: true }
        it "has the NumberProperty" do
          expect(subject["np"]).to eq np
        end

        it "the NumberProperty will not update" do
          expect(subject["np"].will_update).to be_truthy
        end

        it "can generate json" do
          expect(subject.create_json).to eq({"properties" => {"np" => {"type" => "number", "number" => 123}}})
        end
      end
    end
  end
end
