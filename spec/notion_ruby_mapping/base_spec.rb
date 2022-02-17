# frozen_string_literal: true

require_relative "../spec_helper"

module NotionRubyMapping
  # note Common tests without API access
  RSpec.describe Base do
    context "base with id only" do
      let(:base) { Page.new json: {"id" => "without API"} }

      describe "Base instances" do
        it "has an auto generated payload" do
          expect(base.payload).to be_an_instance_of(Payload)
        end

        it "has an auto generated property_cache" do
          expect(base.properties).to be_an_instance_of(PropertyCache)
        end

        it "can generate empty json" do
          expect(base.create_json).to eq({})
        end
      end

      describe "add_property_for_update" do
        let(:np) { NumberProperty.new "np", number: 123 }
        subject { base.add_property_for_update np }
        it "property_cache has the NumberProperty" do
          expect(subject["properties"]["np"]).to eq np
        end

        it "can generate json" do
          expect(subject.create_json).to eq({"properties" => {"np" => {"type" => "number", "number" => 123}}})
        end
      end
    end

    context "base with id and NumberProperty json" do
      let(:json) {
        {
          "id" => "with NumberProperty(without API)",
          "properties" => {
            "np" => {
              "type" => "number",
              "number" => 123,
            },
          },
        }
      }
      let(:base) { Page.new json: json }
      it "property_cache has the NumberProperty" do
        expect(base["properties"]["np"]).to be_an_instance_of NumberProperty
      end
    end
  end
end
