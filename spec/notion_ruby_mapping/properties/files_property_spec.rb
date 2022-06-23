# frozen_string_literal: true

module NotionRubyMapping
  RSpec.describe FilesProperty do
    tc = TestConnection.instance

    context "Database property" do
      context "created by new" do
        let(:target) { FilesProperty.new "fp", base_type: :database }
        it_behaves_like :has_name_as, "fp"
        it_behaves_like :raw_json, :files, {}

        describe "update_from_json" do
          before { target.update_from_json(tc.read_json("files_property_object")) }
          it_behaves_like :will_not_update
          it_behaves_like :assert_different_property, :property_values_json
          it_behaves_like :update_property_schema_json, {}
          it_behaves_like :raw_json, :files, {}
          it_behaves_like :property_schema_json, {"fp" => {"files" => {}}}
        end

        describe "new_name=" do
          before { target.new_name = "new_name" }
          it_behaves_like :will_update
          it_behaves_like :assert_different_property, :property_values_json
          it_behaves_like :update_property_schema_json, {"fp" => {"name" => "new_name"}}
        end

        describe "remove" do
          before { target.remove }
          it_behaves_like :will_update
          it_behaves_like :assert_different_property, :property_values_json
          it_behaves_like :update_property_schema_json, {"fp" => nil}
        end
      end

      context "created from json" do
        let(:target) { Property.create_from_json "fp", tc.read_json("files_property_object"), :database }
        it_behaves_like :has_name_as, "fp"
        it_behaves_like :will_not_update
        it_behaves_like :assert_different_property, :property_values_json
        it_behaves_like :update_property_schema_json, {}
        it_behaves_like :raw_json, :files, {}
      end
    end

    context "Page property" do
      context "created by new" do
        let(:target) { FilesProperty.new "fp", files: files }

        context "no files" do
          let(:files) { [] }
          it_behaves_like :property_values_json, {"fp" => {"type" => "files", "files" => []}}

          describe "files=" do
            context "a file" do
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

            context "2 files" do
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

          describe "file_names=" do
            context "a file" do
              let(:files) { "f3" }
              it { expect { target.file_names = %w[A B] }.to raise_error(StandardError) }
              context "success" do
                before { target.file_names = "fn3" }
                it_behaves_like :property_values_json, {
                  "fp" => {
                    "type" => "files",
                    "files" => [
                      {
                        "type" => "external",
                        "name" => "fn3",
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

            context "2 files" do
              let(:files) { %w[f3 f4] }
              it { expect { target.file_names = "A" }.to raise_error(StandardError) }
              context "success" do
                before { target.file_names = %w[fn3 fn4] }
                it_behaves_like :property_values_json, {
                  "fp" => {
                    "type" => "files",
                    "files" => [
                      {
                        "type" => "external",
                        "name" => "fn3",
                        "external" => {
                          "url" => "f3",
                        },
                      },
                      {
                        "type" => "external",
                        "name" => "fn4",
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
          it_behaves_like :assert_different_property, :update_property_schema_json
          it_behaves_like :assert_different_property, :property_schema_json
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
        end
      end

      context "created from json" do
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
  end
end
