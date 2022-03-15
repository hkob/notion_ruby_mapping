# frozen_string_literal: true

require_relative "../spec_helper"

module NotionRubyMapping
  # NOTE: Common tests without API access
  RSpec.describe Base do
    context "Base created by new and assign" do
      let(:target) do
        Base.new id: "base created by new and assign",
                 assign: [NumberProperty, "np"]
      end
      let(:np) { target.properties["np"] }
      before { np.number = 12_345 }

      it "has an auto generated property_cache" do
        expect(target.properties).to be_an_instance_of(PropertyCache)
      end

      it_behaves_like :property_values_json, {
        "properties" => {
          "np" => {
            "number" => 12_345,
            "type" => "number",
          },
        },
      }
    end

    context "base created by json" do
      let(:json) do
        {
          "id" => "created by json",
          "properties" => {
            "Title" => {
              "type" => "title",
              "title" => [
                {
                  "type" => "text",
                  "text" => {
                    "content" => "ABC\n",
                  },
                  "plain_text" => "ABC\n",
                },
                {
                  "type" => "text",
                  "text" => {
                    "content" => "DEF",
                  },
                  "plain_text" => "DEF",
                },
              ],
            },
          },
        }
      end
      let(:target) { Page.new json: json }
      let(:tp) { target.properties["Title"] }

      it "has an auto generated property_cache" do
        expect(target.properties).to be_an_instance_of(PropertyCache)
      end

      context "before change" do
        it { expect(target.title).to eq "ABC\nDEF" }
        it_behaves_like :property_values_json, {}
      end

      context "after change" do
        before { tp[1].text = "updated text" }

        it { expect(target.title).to eq "ABC\nupdated text" }
        it_behaves_like :property_values_json, {
          "properties" => {
            "Title" => {
              "type" => "title",
              "title" => [
                {
                  "type" => "text",
                  "text" => {
                    "content" => "ABC\n",
                    "link" => nil,
                  },
                  "plain_text" => "ABC\n",
                  "href" => nil,
                },
                {
                  "type" => "text",
                  "text" => {
                    "content" => "updated text",
                    "link" => nil,
                  },
                  "plain_text" => "updated text",
                  "href" => nil,
                },
              ],
            },
          },
        }
      end
    end
  end
end
