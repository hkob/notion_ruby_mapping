# frozen_string_literal: true

module NotionRubyMapping
  RSpec.describe EquationObject do
    tc = TestConnection.instance
    equation_json = tc.read_json "equation_object"

    describe "self.equation_object" do
      subject { EquationObject.equation_object eo }
      context "String" do
        let(:eo) { "y = x^2 + 2x + 1" }

        it { expect(subject).to be_is_a EquationObject }
        it { expect(subject.expression).to eq "y = x^2 + 2x + 1" }
      end

      context "EquationObject" do
        let(:eo) { EquationObject.new "y = f(x)" }

        it { expect(subject).to be_is_a EquationObject }
        it { expect(subject.expression).to eq "y = f(x)" }
      end
    end

    describe "property_values_json" do
      let(:target) { EquationObject.new "x^2 + y^2 = 1" }

      it_behaves_like "property values json", {
        "type" => "equation",
        "equation" => {
          "expression" => "x^2 + y^2 = 1",
        },
        "href" => nil,
        "plain_text" => "x^2 + y^2 = 1",
      }
    end

    describe "create_from_json" do
      let(:target) { RichTextObject.create_from_json json }
      let(:json) { equation_json }

      it_behaves_like "property values json", {
        "type" => "equation",
        "equation" => {
          "expression" => "y = f(x)",
        },
        "annotations" => {
          "bold" => false,
          "code" => false,
          "color" => "default",
          "italic" => false,
          "strikethrough" => false,
          "underline" => false,
        },
        "href" => nil,
        "plain_text" => "y = f(x)",
      }
      it { expect(target.expression).to eq "y = f(x)" }
    end

    describe "expression=" do
      let(:target) { EquationObject.new "x^2 + y^2 = 1" }

      before { target.expression = "y = f(x)" }

      it { expect(target.expression).to eq "y = f(x)" }
      it { expect(target.will_update).to eq true }
    end
  end
end
