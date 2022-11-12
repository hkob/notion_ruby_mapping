# frozen_string_literal: true

require_relative "../../spec_helper"

module NotionRubyMapping
  RSpec.describe Page do
    tc = TestConnection.instance
    let!(:nc) { tc.nc }

    describe "find" do
      subject { -> { Page.find page_id } }

      context "For an existing top page" do
        let(:page_id) { TestConnection::TOP_PAGE_ID }
        it "receive id" do
          expect(subject.call.id).to eq nc.hex_id(TestConnection::TOP_PAGE_ID)
        end

        it "receive title" do
          expect(subject.call.title).to eq "notion_ruby_mapping_test_data"
        end

        describe "dry_run" do
          let(:dry_run) { Page.find "page_id", dry_run: true }
          it_behaves_like :dry_run, :get, :page_path, id: "page_id"
        end
      end

      context "For an existing top page (url)" do
        let(:page_id) { TestConnection::TOP_PAGE_URL }
        it "receive id" do
          expect(subject.call.id).to eq nc.hex_id(TestConnection::TOP_PAGE_ID)
        end

        it "receive title" do
          expect(subject.call.title).to eq "notion_ruby_mapping_test_data"
        end

        describe "dry_run" do
          let(:dry_run) { Page.find "page_id", dry_run: true }
          it_behaves_like :dry_run, :get, :page_path, id: "page_id"
        end
      end

      context "Wrong page" do
        context "wrong format id" do
          let(:page_id) { "AAA" }
          it "raise exception" do
            expect { subject.call }.to raise_error(StandardError)
          end
        end

        context "wrong id" do
          let(:page_id) { TestConnection::UNPERMITTED_PAGE_ID }
          it "Can't receive page" do
            expect { subject.call }.to raise_error(StandardError)
          end
        end
      end
    end

    describe "new and reload" do
      let(:page) { Page.new id: page_id }
      subject { -> { page.reload } }

      context "For an existing top page" do
        let(:page_id) { TestConnection::TOP_PAGE_ID }
        it "has not json before reload" do
          expect(page.json).to be_nil
        end

        it "receive id" do
          expect(subject.call.id).to eq nc.hex_id(TestConnection::TOP_PAGE_ID)
        end

        it "has json after reloading" do
          expect(subject.call.json).not_to be_nil
        end

        it "receive title" do
          expect(subject.call.title).to eq "notion_ruby_mapping_test_data"
        end
      end

      context "Wrong page" do
        context "wrong format id" do
          let(:page_id) { "AAA" }
          it "has not json before reload" do
            expect(page.json).to be_nil
          end

          it "raise exception" do
            expect { subject.call }.to raise_error(StandardError)
          end
        end

        context "wrong id" do
          let(:page_id) { TestConnection::UNPERMITTED_PAGE_ID }
          it "has not json before reload" do
            expect(page.json).to be_nil
          end

          it "raise exception" do
            expect { subject.call }.to raise_error(StandardError)
          end
        end
      end
    end

    describe "properties" do
      let(:target) { page.properties[key] }
      context "For an existing top page" do
        let(:page) { Page.find TestConnection::DB_FIRST_PAGE_ID }
        [
          CheckboxProperty, "CheckboxTitle",
          {
            "CheckboxTitle" => {
              "type" => "checkbox",
              "checkbox" => true,
            },
          },
          CreatedTimeProperty, "CreatedTimeTitle", {},
          DateProperty, "DateTitle", {
            "DateTitle" => {
              "type" => "date",
              "date" => {
                "start" => "2022-02-25T01:23:00.000+09:00",
                "end" => nil,
                "time_zone" => nil,
              },
            },
          },
          LastEditedTimeProperty, "LastEditedTimeTitle", {},
          FormulaProperty, "FormulaTitle", {},
          RollupProperty, "RollupTitle", {},
          EmailProperty, "MailTitle", {
            "MailTitle" => {
              "email" => "hkobhkob@gmail.com",
              "type" => "email",
            },
          },
          FilesProperty, "File&MediaTitle", {
            "File&MediaTitle" => {
              "type" => "files",
              "files" => [
                {
                  "external" => {
                    "url" => "https://img.icons8.com/ios-filled/250/000000/mac-os.png",
                  },
                  "name" => "https://img.icons8.com/ios-filled/250/000000/mac-os.png",
                  "type" => "external",
                },
              ],
            },
          },
          CreatedByProperty, "CreatedByTitle", {},
          LastEditedByProperty, "LastEditedByTitle", {},
          MultiSelectProperty, "MultiSelectTitle", {
            "MultiSelectTitle" => {
              "multi_select" => [
                {
                  "color" => "default",
                  "id" => "5f554552-b77a-474b-b5c7-4ae819966e32",
                  "name" => "Multi Select 2",
                },
                {
                  "color" => "yellow",
                  "id" => "2a0eeeee-b3fd-4072-96a9-865f67cfa6ff",
                  "name" => "Multi Select 1",
                },
              ],
              "type" => "multi_select",
            },
          },
          PeopleProperty, "UserTitle", {
            "UserTitle" => {
              "people" => [
                {
                  "object" => "user",
                  "id" => "2200a9116a9644bbbd386bfb1e01b9f6",
                },
              ],
              "type" => "people",
            },
          },
          RelationProperty, "RelationTitle", {
            "RelationTitle" => {
              "type" => "relation",
              "relation" => [
                {
                  "id" => "860753bb-6d1f-48de-9621-1fa6e0e31f82",
                },
              ],
            },
          },
          NumberProperty, "NumberTitle", {
            "NumberTitle" => {
              "type" => "number",
              "number" => 1.41421356,
            },
          },
          PhoneNumberProperty, "TelTitle", {
            "TelTitle" => {
              "type" => "phone_number",
              "phone_number" => "xx-xxxx-xxxx",
            },
          },
          SelectProperty, "SelectTitle", {
            "SelectTitle" => {
              "type" => "select",
              "select" => {
                "color" => "purple",
                "id" => "b32c83bb-c9af-49e8-9b88-122139affdb7",
                "name" => "Select 3",
              },
            },
          },
          RichTextProperty, "TextTitle", {
            "TextTitle" => {
              "type" => "rich_text",
              "rich_text" => [
                {
                  "annotations" => {
                    "bold" => false,
                    "code" => false,
                    "color" => "default",
                    "italic" => false,
                    "strikethrough" => false,
                    "underline" => false,
                  },
                  "href" => nil,
                  "plain_text" => "def",
                  "text" => {
                    "content" => "def",
                    "link" => nil,
                  },
                  "type" => "text",
                },
              ],
            },
          },
          TitleProperty, "Title", {
            "Title" => {
              "type" => "title",
              "title" => [
                {
                  "annotations" => {
                    "bold" => false,
                    "code" => false,
                    "color" => "default",
                    "italic" => false,
                    "strikethrough" => false,
                    "underline" => false,
                  },
                  "href" => nil,
                  "plain_text" => "ABC",
                  "text" => {
                    "content" => "ABC",
                    "link" => nil,
                  },
                  "type" => "text",
                },
              ],
            },
          },
          UrlProperty, "UrlTitle", {
            "UrlTitle" => {
              "type" => "url",
              "url" => "https://hkob.hatenablog.com/",
            },
          }
        ].each_slice(3) do |(klass, title, ans)|
          context klass do
            let(:key) { title }
            it "should be an object of #{klass}" do
              expect(target).to be_is_a Property
            end
            it_behaves_like :property_values_json, ans
          end
        end
      end
    end

    describe "update_icon" do
      let(:target) { Page.new id: TestConnection::TOP_PAGE_ID }
      before do
        target.set_icon(**params)
      end

      subject { target.icon }

      context "for emoji icon" do
        let(:params) { {emoji: "😀"} }
        describe "dry_run" do
          let(:dry_run) { target.save dry_run: true }
          it_behaves_like :dry_run, :patch, :page_path, use_id: true, json_method: :property_values_json
        end

        describe "save" do
          before { target.save }
          it "update icon (emoji)" do
            is_expected.to eq({"type" => "emoji", "emoji" => "😀"})
          end
        end
      end

      context "for link icon" do
        let(:url) { "https://cdn.profile-image.st-hatena.com/users/hkob/profile.png" }
        let(:params) { {url: url} }
        describe "dry_run" do
          let(:dry_run) { target.save dry_run: true }
          it_behaves_like :dry_run, :patch, :page_path, use_id: true, json_method: :property_values_json
        end

        describe "save" do
          before { target.save }
          it "update icon (link)" do
            is_expected.to eq({"type" => "external", "external" => {"url" => url}})
          end
        end
      end
    end

    describe "update" do
      context "update payload check for loaded object" do
        let(:target) { Page.find TestConnection::DB_FIRST_PAGE_ID }
        let(:properties) { target.properties }
        {
          "CheckboxTitle" => [
            :checkbox=,
            true,
            {
              "CheckboxTitle" => {
                "type" => "checkbox",
                "checkbox" => true,
              },
            },
          ],
          "DateTitle" => [
            :start_date=,
            Date.new(2022, 3, 13),
            {
              "DateTitle" => {
                "type" => "date",
                "date" => {
                  "start" => "2022-03-13",
                  "end" => nil,
                  "time_zone" => nil,
                },
              },
            },
          ],
          "MailTitle" => [
            :email=,
            "hkobhkob@gmail.com",
            {
              "MailTitle" => {
                "type" => "email",
                "email" => "hkobhkob@gmail.com",
              },
            },
          ],
          "File&MediaTitle" => [
            :files=,
            "F1",
            {
              "File&MediaTitle" => {
                "type" => "files",
                "files" => [
                  {
                    "type" => "external",
                    "external" => {
                      "url" => "F1",
                    },
                    "name" => "F1",
                  },
                ],
              },
            },
          ],
          "MultiSelectTitle" => [
            :multi_select=,
            %w[M1 M2],
            {
              "MultiSelectTitle" => {
                "type" => "multi_select",
                "multi_select" => [
                  {
                    "name" => "M1",
                  },
                  {
                    "name" => "M2",
                  },
                ],
              },
            },
          ],
          "UserTitle" => [
            :people=,
            "U1",
            {
              "UserTitle" => {
                "type" => "people",
                "people" => [
                  {
                    "object" => "user",
                    "id" => "U1",
                  },
                ],
              },
            },
          ],
          "RelationTitle" => [
            :relation=,
            "R1",
            {
              "RelationTitle" => {
                "type" => "relation",
                "relation" => [
                  {
                    "id" => "R1",
                  },
                ],
              },
            },
          ],
          "NumberTitle" => [
            :number=,
            12_345,
            {
              "NumberTitle" => {
                "type" => "number",
                "number" => 12_345,
              },
            },
          ],
          "TelTitle" => [
            :phone_number=,
            "yy-yyyy-yyyy",
            {
              "TelTitle" => {
                "type" => "phone_number",
                "phone_number" => "yy-yyyy-yyyy",
              },
            },
          ],
          "SelectTitle" => [
            :select=,
            "Select 3",
            {
              "SelectTitle" => {
                "type" => "select",
                "select" => {
                  "name" => "Select 3",
                },
              },
            },
          ],
          "TextTitle" => [
            :text=,
            TextObject.new("abcdefg"),
            {
              "TextTitle" => {
                "type" => "rich_text",
                "rich_text" => [
                  {
                    "href" => nil,
                    "plain_text" => "abcdefg",
                    "text" => {
                      "content" => "abcdefg",
                      "link" => nil,
                    },
                    "type" => "text",
                  },
                ],
              },
            },
          ],
          "Title" => [
            :text=,
            TextObject.new("ABCDEFG"),
            {
              "Title" => {
                "type" => "title",
                "title" => [
                  {
                    "type" => "text",
                    "href" => nil,
                    "plain_text" => "ABCDEFG",
                    "text" => {
                      "content" => "ABCDEFG",
                      "link" => nil,
                    },
                  },
                ],
              },
            },
          ],
          "UrlTitle" => [
            :url=,
            "URL",
            {
              "UrlTitle" => {
                "type" => "url",
                "url" => "URL",
              },
            },
          ],
        }.each do |key, (method, value, json)|
          context key do
            it {
              tc.clear_object_hash
              if %w[Title TextTitle].include? key
                properties[key][0].send(method, value)
              else
                properties[key].send(method, value)
              end
              expect(target.property_values_json).to eq({"properties" => json})
            }
          end
        end
      end

      context "update check using API" do
        let(:target) do
          Page.new id: TestConnection::DB_UPDATE_PAGE_ID, assign: [
            CheckboxProperty, "CheckboxTitle",
            DateProperty, "DateTitle",
            EmailProperty, "MailTitle",
            FilesProperty, "File&MediaTitle",
            MultiSelectProperty, "MultiSelectTitle",
            PeopleProperty, "UserTitle",
            RelationProperty, "RelationTitle",
            NumberProperty, "NumberTitle",
            PhoneNumberProperty, "TelTitle",
            SelectProperty, "SelectTitle",
            StatusProperty, "StatusTitle",
            RichTextProperty, "TextTitle",
            TitleProperty, "Title",
            UrlProperty, "UrlTitle"
          ]
        end

        before do
          ps = target.properties.values_at "CheckboxTitle", "DateTitle", "MailTitle", "File&MediaTitle",
                                           "MultiSelectTitle", "UserTitle", "RelationTitle", "NumberTitle",
                                           "TelTitle", "SelectTitle", "TextTitle", "Title", "UrlTitle", "StatusTitle"
          @cp, @dp, @mp, @fp, @msp, @up, @rp, @np, @telp, @sp, @tp, @titlep, @urlp, @stp = ps
          @cp.checkbox = true
          @dp.start_date = "2022-03-14"
          @mp.email = "hkobhkob@gmail.com"
          @fp.files = "https://img.icons8.com/ios-filled/250/000000/mac-os.png"
          @msp.multi_select = "Multi Select 2"
          @up.people = TestConnection::USER_HKOB_ID
          @rp.relation = TestConnection::PARENT1_PAGE_ID
          @np.number = 3.1415926535
          @telp.phone_number = "zz-zzzz-zzzz"
          @sp.select = "Select 3"
          @tp << TextObject.new("new text")
          @titlep << "MNO"
          @urlp.url = "https://www.google.com/"
          @stp.status = "Design"
        end

        describe "dry_run" do
          let(:dry_run) { target.save dry_run: true }
          it_behaves_like :dry_run, :patch, :page_path, use_id: true, json_method: :property_values_json
        end

        it "updates properties" do
          # print target.save dry_run: true
          target.save # update page and reload properties
          aggregate_failures do
            {
              @cp => {
                "type" => "checkbox",
                "checkbox" => true,
              },
              @dp => {
                "type" => "date",
                "date" => {
                  "start" => "2022-03-14",
                  "end" => nil,
                  "time_zone" => nil,
                },
              },
              @mp => {
                "type" => "email",
                "email" => "hkobhkob@gmail.com",
              },
              @fp => {
                "type" => "files",
                "files" => [
                  {
                    "external" => {
                      "url" => "https://img.icons8.com/ios-filled/250/000000/mac-os.png",
                    },
                    "name" => "https://img.icons8.com/ios-filled/250/000000/mac-os.png",
                    "type" => "external",
                  },
                ],
              },
              @msp => {
                "type" => "multi_select",
                "multi_select" => [
                  {
                    "id" => "5f554552-b77a-474b-b5c7-4ae819966e32",
                    "name" => "Multi Select 2",
                    "color" => "default",
                  },
                ],
              },
              @up => {
                "people" => [
                  {
                    "object" => "user",
                    "id" => "2200a9116a9644bbbd386bfb1e01b9f6",
                  },
                ],
                "type" => "people",
              },
              @rp => {
                "type" => "relation",
                "relation" => [
                  {
                    "id" => "860753bb-6d1f-48de-9621-1fa6e0e31f82",
                  },
                ],
              },
              @np => {
                "type" => "number",
                "number" => 3.1415926535,
              },
              @telp => {
                "type" => "phone_number",
                "phone_number" => "zz-zzzz-zzzz",
              },
              @sp => {
                "type" => "select",
                "select" => {
                  "color" => "purple",
                  "id" => "b32c83bb-c9af-49e8-9b88-122139affdb7",
                  "name" => "Select 3",
                },
              },
              @tp => {
                "type" => "rich_text",
                "rich_text" => [
                  {
                    "href" => nil,
                    "plain_text" => "new text",
                    "text" => {
                      "content" => "new text",
                      "link" => nil,
                    },
                    "annotations" => {
                      "bold" => false,
                      "code" => false,
                      "color" => "default",
                      "italic" => false,
                      "strikethrough" => false,
                      "underline" => false,
                    },
                    "type" => "text",
                  },
                ],
              },
              @titlep => {
                "type" => "title",
                "title" => [
                  {
                    "href" => nil,
                    "plain_text" => "MNO",
                    "text" => {
                      "content" => "MNO",
                      "link" => nil,
                    },
                    "annotations" => {
                      "bold" => false,
                      "code" => false,
                      "color" => "default",
                      "italic" => false,
                      "strikethrough" => false,
                      "underline" => false,
                    },
                    "type" => "text",
                  },
                ],
              },
              @urlp => {
                "type" => "url",
                "url" => "https://www.google.com/",
              },
              @stp => {
                "type" => "status",
                "status" => {
                  "color" => "purple",
                  "id" => "F<XA",
                  "name" => "Design",
                },
              },
            }.each do |pp, json|
              expect(pp.property_values_json[pp.name]).to eq json
              expect(target.property_values_json).to eq({})
            end
          end
        end
      end
    end

    describe "create" do
      create_page_title = {
        "properties" => {
          "Name" => {
            "title" => [
              {
                "href" => nil,
                "plain_text" => "New Page Title",
                "text" => {
                  "content" => "New Page Title",
                  "link" => nil},
                "type" => "text",
              },
            ],
            "type" => "title",
          },
        },
      }
      let(:parent_db) { Database.new id: TestConnection::PARENT_DATABASE_ID }
      context "build_child_database" do
        let(:target) do
          parent_db.build_child_page TitleProperty, "Name" do |_, ps|
            ps["Name"] << "New Page Title"
          end
        end

        it { expect(target.new_record?).to be_truthy }
        it_behaves_like :property_values_json, {
          "parent" => {
            "database_id" => "1d6b1040a9fb48d99a3d041429816e9f",
          },
        }.merge(create_page_title)

        describe "dry_run" do
          let(:dry_run) { target.save dry_run: true }
          it_behaves_like :dry_run, :post, :pages_path, json_method: :property_values_json
        end

        describe "create" do
          before { target.save }
          it_behaves_like :property_values_json, {}
          it { expect(target.id).to eq "b6e9af0269cd4999bce9e28593f65070" }
          it { expect(target.new_record?).to be_falsey }
        end
      end

      context "create_child_database" do
        context "not dry_run" do
          let(:target) do
            parent_db.create_child_page TitleProperty, "Name" do |_, ps|
              ps["Name"] << "New Page Title"
            end
          end

          it_behaves_like :property_values_json, {}
          it { expect(target.id).to eq "b6e9af0269cd4999bce9e28593f65070" }
          it { expect(target.new_record?).to be_falsey }
        end

        context "dry_run" do
          let(:target) do
            parent_db.build_child_page TitleProperty, "Name" do |_, ps|
              ps["Name"] << "New Page Title"
            end
          end
          let(:dry_run) do
            parent_db.create_child_page TitleProperty, "Name", dry_run: true do |_, ps|
              ps["Name"] << "New Page Title"
            end
          end
          it_behaves_like :dry_run, :post, :pages_path, json_method: :property_values_json
        end
      end
    end

    describe "append_comment" do
      let(:page) { Page.find TestConnection::TOP_PAGE_ID }
      context "dry_run: false" do
        let(:target) { page.append_comment "test comment" }
        it { expect(target.discussion_id).to eq "4475361640994a5f97c653eb758e7a9d" }
      end

      context "dry_run: true" do
        let(:dry_run) { page.append_comment "test comment", dry_run: true }
        it_behaves_like :dry_run, :post, :comments_path, json: {
          "rich_text": [
            {
              "type" => "text",
              "text" => {
                "content" => "test comment",
                "link" => nil,
              },
              "plain_text" => "test comment",
              "href" => nil,
            }
          ],
          "parent": {"page_id" => TestConnection::TOP_PAGE_ID},
        }
      end
    end
  end
end
