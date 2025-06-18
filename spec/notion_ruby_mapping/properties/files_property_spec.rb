# frozen_string_literal: true

module NotionRubyMapping
  RSpec.describe FilesProperty do
    tc = TestConnection.instance
    let(:no_content_json) { {id: "qEdK"} }
    let(:first_page_id) { TestConnection::DB_FIRST_PAGE_ID }
    let(:second_page_id) { TestConnection::DB_SECOND_PAGE_ID }
    let(:property_cache_first) { PropertyCache.new base_type: :page, page_id: first_page_id }
    let(:property_cache_second) { PropertyCache.new base_type: :page, page_id: second_page_id }
    let(:file_upload_object) do
      instance_double(FileUploadObject, id: TestConnection::FILE_UPLOAD_IMAGE_ID, fname: "test.png")
    end

    before { allow(file_upload_object).to receive(:is_a?).with(FileUploadObject).and_return(true) }

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

      context "when created from json" do
        let(:target) { Property.create_from_json "fp", tc.read_json("files_property_object"), :database }

        it_behaves_like "has name as", :fp
        it_behaves_like "will not update"
        it_behaves_like "assert different property", :property_values_json
        it_behaves_like "update property schema json", {}
        it_behaves_like "raw json", :files, {}
      end
    end

    context "when Page property" do
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

      context "when created by new" do
        let(:target) { described_class.new "fp", files: files }

        context "when no files" do
          let(:files) { [] }

          it_behaves_like "property values json", {fp: {type: "files", files: []}}

          describe "files=" do
            context "with a file url" do
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

            context "with a file upload object" do
              before { target.files = file_upload_object }

              it_behaves_like "property values json", {
                fp: {
                  type: "files",
                  files: [
                    {
                      type: "file_upload",
                      file_upload: {
                        id: TestConnection::FILE_UPLOAD_IMAGE_ID,
                      },
                      name: "test.png",
                    },
                  ],
                },
              }
              it_behaves_like "will update"
            end

            context "with 2 file urls" do
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

          context "with a file url and a file upload object" do
            before { target.files = ["f3", file_upload_object] }

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
                    type: "file_upload",
                    name: "test.png",
                    file_upload: {
                      id: TestConnection::FILE_UPLOAD_IMAGE_ID,
                    },
                  },
                ],
              },
            }
            it_behaves_like "will update"
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

    describe "update_page_set_file_property_file_upload" do
      let(:target) { Page.find TestConnection::FILE_UPLOAD_PAGE_ID }
      let(:file_upload_object) do
        instance_double FileUploadObject, id: TestConnection::FILE_UPLOAD_IMAGE_ID, fname: "test.png"
      end

      before do
        allow(file_upload_object).to receive(:is_a?).with(FileUploadObject).and_return(true)
        target.properties[:files].files = file_upload_object
      end

      describe "dry_run" do
        let(:dry_run) { target.save dry_run: true }

        it_behaves_like "dry run", :patch, :page_path, use_id: true, json_method: :property_values_json
      end

      describe "save" do
        before { target.save }

        subject { target.properties[:files].files.first.property_values_json }

        it "update files property with file upload object" do
          expect(subject).to eq(
            {
              "type": "file",
              "file": {
                "url": "https://prod-files-secure.s3.us-west-2.amazonaws.com/2b7b01f0-67a8-40f8-acd4-88dd2805f216/bf91dfb5-72e5-4c22-bab7-f4b9f343610f/ErSxuLeq.png-medium.png?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Content-Sha256=UNSIGNED-PAYLOAD&X-Amz-Credential=ASIAZI2LB466VJRYGJCE%2F20250616%2Fus-west-2%2Fs3%2Faws4_request&X-Amz-Date=20250616T114259Z&X-Amz-Expires=3600&X-Amz-Security-Token=IQoJb3JpZ2luX2VjEHQaCXVzLXdlc3QtMiJHMEUCIQD0E8dP%2F%2BzS5z7cq265pOJ2TCwtWcsI18R9LixNBgcSkwIgQqbS2KaIxR45oN4MT3EFiWmLk5KMcE1o2ZEGrP0JVKUq%2FwMIXRAAGgw2Mzc0MjMxODM4MDUiDFrW4E3yE1A5P6rtTyrcA%2FyvZ3E46Ow%2BafVD3xtUBD7Bue6jwaklkp0tMZ%2BlTGGbMuIOOD3U%2F3d0%2F5QNz7dP3VcG7Wz9uOxBlgiwNQ8YQ4w%2FLWzgxpyJsKaknGqb%2BlF0tli6lVVyZGP6HjxUVUs3wK%2FMVMMUqmouGdXSB%2BoakInlRs6zXQfbn0%2BIk7M65Tglom0apy%2B3EBRC6mAT83zj29Xee%2BY8XBlhBY7LOEDgCgpayXfaGvxxW6DozoPs9ff1LJgt6Zm6mhMFGGEy3qj%2BnQl%2BEyx7EOyRjl7HEX3BpGX5wX2fBEzjGlP%2Fa66IXS9xV363gWZJSxIR98TDmYCS2sNJ88rlJxfUQdyf4nX5miouy7cJi%2BC3K5jBCnCBU3jY99m1ht6xfKkAi7JmsPhSZNa%2FIL8tCUKfv64kxtq%2FHINoRvVJVfsysg5uzMUwNeFqxnECTQ0EpjygWjziBtUZQSvA%2FCkdQ3M4tu0hiXEf1dOjKzwhqHa0YiW8QluFeUI7TxdC6ubdEceCJo1zDSG7zToM0ynHVpjsdUeE%2FqGembHkBmVC8ZyfFV9nWC7fFFYmLp8uwmxOPf5Nxx79ig69Bzc1jQM46ev%2FwdmLL%2B3CNJcJZ8v%2F9bgpz8fEx4MA7cpqKvzHyWQUoEWaRcufMMv%2Fv8IGOqUBqS8jCM3xIg%2F79eDsSgHLpcgpGlYozBf2mKOxn321b8JP2sUUO%2B8q2JLbaBy6%2BoLAeAWjkjgiQxgS967fdr3XjYMTYyorrXiON4yrnTdZs4AWB4QWDCtmkbpDR1nca%2BU20M7nONNXwYJ%2F3bZXrXAM%2FEEXBeOMqIwQQgA4UdLNyXY0KF6cKoPOU3r8idGi83tm7a9Tkvurc2X1TaGKzhqnZ4YLPdyz&X-Amz-Signature=c7eac743bb0ce89b2755c4e381f21ebd6e4c6f7802462b274eb1d5c8570a5dfc&X-Amz-SignedHeaders=host&x-amz-checksum-mode=ENABLED&x-id=GetObject",
                "expiry_time": "2025-06-16T12:42:59.075Z",
              },
            },
          )
        end
      end
    end
  end
end
