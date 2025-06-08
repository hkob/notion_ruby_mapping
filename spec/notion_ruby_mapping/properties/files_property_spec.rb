# frozen_string_literal: true

module NotionRubyMapping
  RSpec.describe FilesProperty do
    tc = TestConnection.instance
    let(:no_content_json) { {id: "qEdK"} }
    let(:first_page_id) { TestConnection::DB_FIRST_PAGE_ID }
    let(:second_page_id) { TestConnection::DB_SECOND_PAGE_ID }
    let(:property_cache_first) { PropertyCache.new base_type: :page, page_id: first_page_id }
    let(:property_cache_second) { PropertyCache.new base_type: :page, page_id: second_page_id }

    context "when Database property" do
      context "when created by new" do
        let(:target) { described_class.new "fp", base_type: :database }

        it_behaves_like "has name as", :fp
        it_behaves_like "raw json", :files, {}

        describe "update_from_json" do
          before { target.update_from_json(tc.read_json("files_property_object")) }

          it_behaves_like "will not update"
          it_behaves_like "assert different property", :property_values_json
          it_behaves_like "update property schema json", {}
          it_behaves_like "raw json", :files, {}
          it_behaves_like "property schema json", {fp: {files: {}}}
        end

        describe "new_name=" do
          before { target.new_name = "new_name" }

          it_behaves_like "will update"
          it_behaves_like "assert different property", :property_values_json
          it_behaves_like "update property schema json", {fp: {name: :new_name}}
        end

        describe "remove" do
          before { target.remove }

          it_behaves_like "will update"
          it_behaves_like "assert different property", :property_values_json
          it_behaves_like "update property schema json", {fp: nil}
        end
      end

      context "created from json" do
        let(:target) { Property.create_from_json "fp", tc.read_json("files_property_object"), :database }

        it_behaves_like "has name as", :fp
        it_behaves_like "will not update"
        it_behaves_like "assert different property", :property_values_json
        it_behaves_like "update property schema json", {}
        it_behaves_like "raw json", :files, {}
      end
    end

    context "Page property" do
      external_json = {
        fp: {
          type: "files",
          files: [
            {
              type: "external",
              name: "https://img.icons8.com/ios-filled/250/000000/mac-os.png",
              external: {
                url: "https://img.icons8.com/ios-filled/250/000000/mac-os.png",
              },
            },
          ],
        },
      }

      context "created by new" do
        let(:target) { described_class.new "fp", files: files }

        context "no files" do
          let(:files) { [] }

          it_behaves_like "property values json", {fp: {type: "files", files: []}}

          describe "files=" do
            context "a file" do
              before { target.files = "f3" }

              it_behaves_like "property values json", {
                fp: {
                  type: "files",
                  files: [
                    {
                      type: "external",
                      name: "f3",
                      external: {
                        url: "f3",
                      },
                    },
                  ],
                },
              }
              it_behaves_like "will update"
            end

            context "2 files" do
              before { target.files = %w[f3 f4] }

              it_behaves_like "property values json", {
                fp: {
                  type: "files",
                  files: [
                    {
                      type: "external",
                      name: "f3",
                      external: {
                        url: "f3",
                      },
                    },
                    {
                      type: "external",
                      name: "f4",
                      external: {
                        url: "f4",
                      },
                    },
                  ],
                },
              }
              it_behaves_like "will update"
            end
          end

          describe "file_names=" do
            context "a file" do
              let(:files) { "f3" }

              it { expect { target.file_names = %w[A B] }.to raise_error(StandardError) }

              context "success" do
                before { target.file_names = "fn3" }

                it_behaves_like "property values json", {
                  fp: {
                    type: "files",
                    files: [
                      {
                        type: "external",
                        name: "fn3",
                        external: {
                          url: "f3",
                        },
                      },
                    ],
                  },
                }
                it_behaves_like "will update"
              end
            end

            context "2 files" do
              let(:files) { %w[f3 f4] }

              it { expect { target.file_names = "A" }.to raise_error(StandardError) }

              context "success" do
                before { target.file_names = %w[fn3 fn4] }

                it_behaves_like "property values json", {
                  fp: {
                    type: "files",
                    files: [
                      {
                        type: "external",
                        name: "fn3",
                        external: {
                          url: "f3",
                        },
                      },
                      {
                        type: "external",
                        name: "fn4",
                        external: {
                          url: "f4",
                        },
                      },
                    ],
                  },
                }
                it_behaves_like "will update"
              end
            end
          end

          describe "update_from_json(internal)" do
            before { target.update_from_json(tc.read_json("retrieve_property_files_internal")) }

            let(:files) { "f1" }

            it_behaves_like "will not update"
            it_behaves_like "property values json", {}
          end

          describe "update_from_json(external)" do
            before { target.update_from_json(tc.read_json("retrieve_property_files_external")) }

            let(:files) { "f1" }

            it_behaves_like "will not update"
            it_behaves_like "property values json", {
              fp: {
                type: "files",
                files: [
                  {
                    type: "external",
                    name: "https://img.icons8.com/ios-filled/250/000000/mac-os.png",
                    external: {
                      url: "https://img.icons8.com/ios-filled/250/000000/mac-os.png",
                    },
                  },
                ],
              },
            }
          end
        end

        context "a single file" do
          let(:files) { "f1" }

          it_behaves_like "property values json", {
            fp: {
              type: "files",
              files: [
                {
                  type: "external",
                  name: "f1",
                  external: {
                    url: "f1",
                  },
                },
              ],
            },
          }
          it_behaves_like "will not update"
          it_behaves_like "assert different property", :update_property_schema_json
          it_behaves_like "assert different property", :property_schema_json
        end

        context "multiple files" do
          let(:files) { %w[f1 f2] }

          it_behaves_like "property values json", {
            fp: {
              type: "files",
              files: [
                {
                  type: "external",
                  name: "f1",
                  external: {
                    url: "f1",
                  },
                },
                {
                  type: "external",
                  name: "f2",
                  external: {
                    url: "f2",
                  },
                },
              ],
            },
          }
          it_behaves_like "will not update"
        end
      end

      context "created from json" do
        describe "an internal files property from property_item_json (not update)" do
          let(:target) { Property.create_from_json "fp", tc.read_json("retrieve_property_files_internal") }

          it_behaves_like "has name as", :fp
          it_behaves_like "will not update"
          it_behaves_like "property values json", {}
        end

        describe "an external files property from property_item_json" do
          let(:target) { Property.create_from_json "fp", tc.read_json("retrieve_property_files_external") }

          it_behaves_like "has name as", :fp
          it_behaves_like "will not update"
          it_behaves_like "property values json", external_json
        end
      end

      context "created from json (no content:external)" do
        let(:target) { Property.create_from_json "fp", no_content_json, :page, property_cache_first }

        it_behaves_like "has name as", :fp
        it_behaves_like "will not update"
        it { expect(target).not_to be_contents }

        it_behaves_like "assert different property", :update_property_schema_json

        # hook property_values_json / created_by to retrieve a property item
        it_behaves_like "property values json", external_json
        it { expect(target.files.map(&:url)).to eq ["https://img.icons8.com/ios-filled/250/000000/mac-os.png"] }
      end

      context "created from json (no content:internal)" do
        let(:target) { Property.create_from_json "fp", no_content_json, :page, property_cache_second }

        it_behaves_like "has name as", :fp
        it_behaves_like "will not update"
        it { expect(target).not_to be_contents }

        it_behaves_like "assert different property", :update_property_schema_json

        # hook property_values_json / created_by to retrieve a property item
        it_behaves_like "property values json", {}
        it { expect(target.files.map(&:url)).to eq ["https://s3.us-west-2.amazonaws.com/secure.notion-static.com/f7b6864c-f809-498d-8725-03fc7e85a9ff/nr.png?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Content-Sha256=UNSIGNED-PAYLOAD&X-Amz-Credential=AKIAT73L2G45EIPT3X45%2F20220902%2Fus-west-2%2Fs3%2Faws4_request&X-Amz-Date=20220902T011420Z&X-Amz-Expires=3600&X-Amz-Signature=f0941c6678b9c2122a8b96ddc884c263451eb45de90c1ce607e82b713096eeb6&X-Amz-SignedHeaders=host&x-id=GetObject"] }
      end
    end
  end
end
