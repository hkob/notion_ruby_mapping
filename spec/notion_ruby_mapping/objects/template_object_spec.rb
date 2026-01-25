# frozen_string_literal: true

module NotionRubyMapping
  RSpec.describe TemplateObject do
    tc = TestConnection.instance
    template_json = tc.read_json "template_object"

    describe "create from json" do
      let(:target) { TemplateObject.new json: template_json }

      it_behaves_like "property values json", {
        "id" => "88f4a106-b84b-4d35-9c2d-256bcd55901f",
        "name" => "template",
        "is_default" => true,
      }

      it { expect(target.id).to eq "88f4a106-b84b-4d35-9c2d-256bcd55901f" }
      it { expect(target.name).to eq "template" }
      it { expect(target.is_default).to eq true }
    end
  end
end
