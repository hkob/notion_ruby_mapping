# frozen_string_literal: true

module NotionRubyMapping
  RSpec.describe FilesProperty do
    let(:property) { FilesProperty.new "fp" }
    tc = TestConnection.instance

    describe "a files property" do
      it "has name" do
        expect(property.name).to eq "fp"
      end

      context "create query" do
        subject { query.filter }
        %w[is_empty is_not_empty].each do |key|
          context key do
            let(:query) { property.send "filter_#{key}" }
            it { is_expected.to eq({"property" => "fp", "files" => {key => true}}) }
          end
        end
      end
    end

    describe "a files property with parameters" do
      let(:target) { FilesProperty.new "fp", files: files }

      context "a single file" do
        let(:files) { "f1" }
        it_behaves_like :property_values_json, {
          "fp" => {
            "type" => "files",
            "files" => [
              {
                "type" => "external",
                "name" => "f1",
                "external" => {
                  "url" => "f1",
                },
              },
            ],
          },
        }
        it_behaves_like :will_not_update

        describe "files=" do
          before { target.files = "f3" }
          it_behaves_like :property_values_json, {
            "fp" => {
              "type" => "files",
              "files" => [
                {
                  "type" => "external",
                  "name" => "f3",
                  "external" => {
                    "url" => "f3",
                  },
                },
              ],
            },
          }
          it_behaves_like :will_update
        end
      end

      context "multiple files" do
        let(:files) { %w[f1 f2] }
        it_behaves_like :property_values_json, {
          "fp" => {
            "type" => "files",
            "files" => [
              {
                "type" => "external",
                "name" => "f1",
                "external" => {
                  "url" => "f1",
                },
              },
              {
                "type" => "external",
                "name" => "f2",
                "external" => {
                  "url" => "f2",
                },
              },
            ],
          },
        }
        it_behaves_like :will_not_update

        describe "files=" do
          before { target.files = %w[f3 f4] }
          it_behaves_like :property_values_json, {
            "fp" => {
              "type" => "files",
              "files" => [
                {
                  "type" => "external",
                  "name" => "f3",
                  "external" => {
                    "url" => "f3",
                  },
                },
                {
                  "type" => "external",
                  "name" => "f4",
                  "external" => {
                    "url" => "f4",
                  },
                },
              ],
            },
          }
          it_behaves_like :will_update
        end
      end

      describe "update_from_json(internal)" do
        before { target.update_from_json(tc.read_json("files_property_internal_item")) }
        let(:files) { "f1" }
        it_behaves_like :will_not_update
        it_behaves_like :property_values_json, {}
      end

      describe "update_from_json(external)" do
        before { target.update_from_json(tc.read_json("files_property_external_item")) }
        let(:files) { "f1" }
        it_behaves_like :will_not_update
        it_behaves_like :property_values_json, {
          "fp" => {
            "type" => "files",
            "files" => [
              {
                "type" => "external",
                "name" => "https://img.icons8.com/ios-filled/250/000000/mac-os.png",
                "external" => {
                  "url" => "https://img.icons8.com/ios-filled/250/000000/mac-os.png",
                },
              },
            ],
          },
        }
      end
    end

    describe "an internal files property from property_item_json (not update)" do
      let(:target) { Property.create_from_json "fp", tc.read_json("files_property_internal_item") }
      it_behaves_like :has_name_as, "fp"
      it_behaves_like :will_not_update
      it_behaves_like :property_values_json, {}
    end

    describe "an external files property from property_item_json" do
      let(:target) { Property.create_from_json "fp", tc.read_json("files_property_external_item") }
      it_behaves_like :has_name_as, "fp"
      it_behaves_like :will_not_update
      it_behaves_like :property_values_json, {
        "fp" => {
          "type" => "files",
          "files" => [
            {
              "type" => "external",
              "name" => "https://img.icons8.com/ios-filled/250/000000/mac-os.png",
              "external" => {
                "url" => "https://img.icons8.com/ios-filled/250/000000/mac-os.png",
              },
            },
          ],
        },
      }
    end
  end
end
