# frozen_string_literal: true

module NotionRubyMapping
  RSpec.describe Property do
    describe "create_from_json" do
      context "when the json is nil" do
        it "raises StandardError" do
          expect { described_class.create_from_json "np", nil }
            .to raise_error StandardError, "Property not found: np:"
        end
      end

      context "when the json has no type" do
        let(:input_json) { {"id" => "SQeZ"} }

        it "raises StandardError" do
          expect { described_class.create_from_json "np", input_json }
            .to raise_error StandardError, "Property value is not returned: np"
        end
      end

      context "when the json has an unsupported type" do
        let(:input_json) { {"id" => "SQeZ", "type" => "brand_new", "brand_new" => {}} }

        it "raises StandardError" do
          expect { described_class.create_from_json "np", input_json }
            .to raise_error StandardError,
                            "Unsupported property type: brand_new (np). Please update notion_ruby_mapping."
        end
      end
    end
  end
end
