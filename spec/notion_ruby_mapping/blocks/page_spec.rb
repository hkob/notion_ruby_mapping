# frozen_string_literal: true

require_relative "../../spec_helper"

module NotionRubyMapping
  RSpec.describe Page do
    tc = TestConnection.instance
    let!(:nc) { tc.nc }

    PAGE_TITLE_FOR_CREATED_PAGE = "New Page by data_source_id"
    PAGE_TITLE_FOR_CREATED_PAGE_WITH_TEMPLATE = "New Page by data_source_id with template"

    describe "find" do
      subject { -> { described_class.find page_id } }

      context "when For an existing top page" do
        let(:page_id) { TestConnection::TOP_PAGE_ID }

        it "receive id" do
          expect(subject.call.id).to eq nc.hex_id(TestConnection::TOP_PAGE_ID)
        end

        it "receive title, url, public_url" do
          page = subject.call
          page_id = "notion_ruby_mapping_test_data-c01166c613ae45cbb96818b4ef2f5a77"
          expect(page.title).to eq "notion_ruby_mapping_test_data"
          expect(page.url).to eq "https://www.notion.so/#{page_id}"
          expect(page.public_url).to eq "https://hkob.notion.site/#{page_id}"
        end

        describe "dry_run" do
          let(:dry_run) { Page.find "page_id", dry_run: true }

          it_behaves_like "dry run", :get, :page_path, id: "page_id"
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

          it_behaves_like "dry run", :get, :page_path, id: "page_id"
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
      let(:target) { page.properties[key.to_s] }

      context "For an existing top page" do
        let(:page) { Page.find TestConnection::DB_FIRST_PAGE_ID }

        [
          CheckboxProperty, :CheckboxTitle,
          {
            "CheckboxTitle" => {
              "type" => "checkbox",
              "checkbox" => true,
            },
          },
          CreatedTimeProperty, :CreatedTimeTitle, {},
          DateProperty, :DateTitle, {
            "DateTitle" => {
              "type" => "date",
              "date" => {
                "start" => "2022-02-25T01:23:00.000+09:00",
                "end" => nil,
                "time_zone" => nil,
              },
            },
          },
          LastEditedTimeProperty, :LastEditedTimeTitle, {},
          FormulaProperty, :FormulaTitle, {},
          RollupProperty, :RollupTitle, {},
          EmailProperty, :MailTitle, {
            "MailTitle" => {
              "email" => "hkobhkob@gmail.com",
              "type" => "email",
            },
          },
          FilesProperty, :"File&MediaTitle", {
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
          CreatedByProperty, :CreatedByTitle, {},
          LastEditedByProperty, :LastEditedByTitle, {},
          MultiSelectProperty, :MultiSelectTitle, {
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
          PeopleProperty, :UserTitle, {
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
          RelationProperty, :RelationTitle, {
            "RelationTitle" => {
              "type" => "relation",
              "relation" => [
                {
                  "id" => "860753bb-6d1f-48de-9621-1fa6e0e31f82",
                },
              ],
            },
          },
          NumberProperty, :NumberTitle, {
            "NumberTitle" => {
              "type" => "number",
              "number" => 1.41421356,
            },
          },
          PhoneNumberProperty, :TelTitle, {
            "TelTitle" => {
              "type" => "phone_number",
              "phone_number" => "xx-xxxx-xxxx",
            },
          },
          SelectProperty, :SelectTitle, {
            "SelectTitle" => {
              "type" => "select",
              "select" => {
                "color" => "purple",
                "id" => "b32c83bb-c9af-49e8-9b88-122139affdb7",
                "name" => "Select 3",
              },
            },
          },
          RichTextProperty, :TextTitle, {
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
          TitleProperty, :Title, {
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
          UniqueIdProperty, :ID, {
            "ID" => {
              "type" => "unique_id",
              "unique_id" => {
                "prefix" => "ST",
                "number" => 3,
              },
            },
          },
          UrlProperty, :UrlTitle, {
            "UrlTitle" => {
              "type" => "url",
              "url" => "https://hkob.hatenablog.com/",
            },
          }
        ].each_slice(3) do |(klass, title, ans)|
          context klass do
            let(:key) { title }

            it "is an object of #{klass}" do
              expect(target).to be_is_a Property
            end

            it_behaves_like "property values json", ans
          end
        end
      end
    end

    describe "retrieve a page with many relations" do
      let!(:target) { Page.find TestConnection::DB_MANY_CHILDREN_PAGE_ID }

      it "has 26 relations" do
        expect(target.properties["Children"].relation.size).to eq 26
      end
    end

    describe "set_icon" do
      let(:target) { Page.new id: TestConnection::TOP_PAGE_ID }

      before do
        target.set_icon(**params)
      end

      subject { target.icon }

      context "with emoji icon" do
        let(:params) { {emoji: "😀"} }

        describe "dry_run" do
          let(:dry_run) { target.save dry_run: true }

          it_behaves_like "dry run", :patch, :page_path, use_id: true, json_method: :property_values_json
        end

        describe "save" do
          before { target.save }

          it "update icon (emoji)" do
            expect(subject).to eq({"type" => "emoji", "emoji" => "😀"})
          end
        end
      end

      context "with icon link" do
        let(:url) { "https://cdn.profile-image.st-hatena.com/users/hkob/profile.png" }
        let(:params) { {url: url} }

        describe "dry_run" do
          let(:dry_run) { target.save dry_run: true }

          it_behaves_like "dry run", :patch, :page_path, use_id: true, json_method: :property_values_json
        end

        describe "save" do
          before { target.save }

          it "update icon (link)" do
            expect(subject).to eq({"type" => "external", "external" => {"url" => url}})
          end
        end
      end

      context "with file upload object" do
        let(:id) { TestConnection::FILE_UPLOAD_IMAGE_ID }
        let(:file_upload_object) { instance_double(FileUploadObject, id: id) }
        let(:params) { {file_upload_object: file_upload_object} }

        describe "dry_run" do
          let(:dry_run) { target.save dry_run: true }

          it_behaves_like "dry run", :patch, :page_path, use_id: true, json_method: :property_values_json
        end

        describe "save" do
          before { target.save }

          it "update icon (file upload object)" do
            expect(subject).to eq(
              {
                "file" => {
                  "url" => "https://prod-files-secure.s3.us-west-2.amazonaws.com/2b7b01f0-67a8-40f8-acd4-88dd2805f216/bf91dfb5-72e5-4c22-bab7-f4b9f343610f/ErSxuLeq.png-medium.png?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Content-Sha256=UNSIGNED-PAYLOAD&X-Amz-Credential=ASIAZI2LB466WMJXGZJ3%2F20250608%2Fus-west-2%2Fs3%2Faws4_request&X-Amz-Date=20250608T113658Z&X-Amz-Expires=3600&X-Amz-Security-Token=IQoJb3JpZ2luX2VjEK7%2F%2F%2F%2F%2F%2F%2F%2F%2F%2FwEaCXVzLXdlc3QtMiJHMEUCIQCRwDcy8FCGnwyLhq4HS25fQRC6TfVV3YQMrNHRsUrVsgIgXY2DAKoH34KEsqKA0qcrl6Bn5G7DFknz9YMcuew97noqiAQIh%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2FARAAGgw2Mzc0MjMxODM4MDUiDOdZh%2BfooUNxMlf5mircAx%2BEoEoF605FjkDX9BcjnNExp0PCtN3KIV6lpr1THqt788Ig9X995g5jPRHjn72DATXSuIjWR%2FKB7uUNe30FxVFZtDKfTX6zqXhdXwahhViHR27zkQs2wWlG8BHi3S4ntEzKDNGlCVz0wA%2BrMdL9OuB9gZK1%2FbS5QWvt005VgaHck9m33wXFSSAD1xaTay%2BDfjSjcFjc4Cgoz7Qi%2Bhk6ET3jeGrJum%2FbcXxGeFBmwNRlMyOTOIUKXOURj71UECsZKPbtyLvbBJ2Yk%2BAaciBPeatA%2BXmJWlYhTRJqsMKliWqcWMqgFlFkvjpAx2t%2BL0alsTP0ujVGhWXohshSNMJYm0FDp%2B72rToWzxRvN1XKxmLGlbrGjNd5TCzyaiBzoaEZQQYCoIi%2BTkqHfmBo7213Y20lURKLNnaR%2FmNn80kLM2fuOpcNShbWHfSktL2zg5Fsr7UGBw8AE5%2FD0shM0IUmx2N2%2B84WcAzpSvMH23IiPn%2FCrPdPqcr7Os9ZwozllQdx%2BAr3rezywUZCT63155cmcCiO1%2Byze7q56eGZ5UIh%2FAzHIxC0u1ZSNGwu1a664mQJbaCJlEN%2F%2BCRRJ4%2BbuJygd6pWsC2shrOPQtOgfq4AvkHXMLGKrc25al9LxNKNMIjNlMIGOqUBHSGCWMW2ZHjpvN%2FaN4T4k8RUXRhmpFmghjbdhEgA7NoAWanBwMery8qJLsOl2b0XEtd2ANBb6gfz3FFoVKjvzocpiYsubz39zOc2WHRsQuAweoeHcTjavNZqMueBqqFg0fbcMoRtSrE8nkgTgsNO8YIpNYC8C0tuJMx6Ve9QZKtY8TbrDBiegLKRBkDjWunt0cW5T8nP3Q6iG7uRMILII9ydjepg&X-Amz-Signature=835ffd4f0ae04a321cecdd3cc27d0e53461bda12f0e0789a57bee07823f96b45&X-Amz-SignedHeaders=host&x-id=GetObject",
                  "expiry_time" => "2025-06-08T12:36:58.153Z",
                },
                "type" => "file",
              },
            )
          end
        end
      end
    end

    describe "set_cover" do
      let(:target) { Page.new id: TestConnection::TOP_PAGE_ID }

      before do
        target.set_cover(**params)
      end

      subject { target.cover }

      context "with cover link" do
        let(:url) { "https://cdn.profile-image.st-hatena.com/users/hkob/profile.png" }
        let(:params) { {url: url} }

        describe "dry_run" do
          let(:dry_run) { target.save dry_run: true }

          it_behaves_like "dry run", :patch, :page_path, use_id: true, json_method: :property_values_json
        end

        describe "save" do
          before { target.save }

          it "update cover (link)" do
            expect(subject).to eq({"type" => "external", "external" => {"url" => url}})
          end
        end
      end

      context "with file upload object" do
        let(:id) { TestConnection::FILE_UPLOAD_IMAGE_ID }
        let(:file_upload_object) { instance_double(FileUploadObject, id: id) }
        let(:params) { {file_upload_object: file_upload_object} }

        describe "dry_run" do
          let(:dry_run) { target.save dry_run: true }

          it_behaves_like "dry run", :patch, :page_path, use_id: true, json_method: :property_values_json
        end

        describe "save" do
          before { target.save }

          it "update cover (file upload object)" do
            expect(subject).to eq(
              {
                "file" => {
                  "url" => "https://prod-files-secure.s3.us-west-2.amazonaws.com/2b7b01f0-67a8-40f8-acd4-88dd2805f216/bf91dfb5-72e5-4c22-bab7-f4b9f343610f/ErSxuLeq.png-medium.png?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Content-Sha256=UNSIGNED-PAYLOAD&X-Amz-Credential=ASIAZI2LB466SCWC6OQZ%2F20250608%2Fus-west-2%2Fs3%2Faws4_request&X-Amz-Date=20250608T113828Z&X-Amz-Expires=3600&X-Amz-Security-Token=IQoJb3JpZ2luX2VjELD%2F%2F%2F%2F%2F%2F%2F%2F%2F%2FwEaCXVzLXdlc3QtMiJHMEUCIQDe03nZgmH7Wn6IuW2LJ8zusL56DWxSXVuL4fCn7m%2FX7wIgPQUVMnT7H7AlHkOMYF24RP6syOfRN9TDtbFA%2BHv06coqiAQIif%2F%2F%2F%2F%2F%2F%2F%2F%2F%2FARAAGgw2Mzc0MjMxODM4MDUiDKbsbrsELLC9IAkAjyrcA51TQ0z5zUWBamgsA6Teq1kJYyjzsvpHmAoZYpHS7HeAAVwP%2BTcphLXbV8tMPH9JV1lcmDgPflGUZIbamcFPGHSzC%2F22be1cRRh5aDb0vSNqRr63rWGYthiXnJ8ynK4TXhQyfaNpKDLGm%2BdkVkMabCK2JpWvvDoBW4BUJGLC7S6Lt09QWTZT9P1YuyILW%2BnZvd4%2BRZd%2F3UVPwwhh%2FJtCIVcAon8APIlEZ%2B0YkhD8F95eMBRrvkbGzVQEv0SpAWcVwLOiISBlR4e0h9tlZoeG5%2Ff8Fhj92WypusgyDLH1F4Mmn74kXeK5WwwTxxOCkdexLOh4Rpd%2F84bkiSHVvtSk7UdyNvMaFp7vAmmAI%2Bis7FNA3z%2FcZ8D4z%2BHcXjgwB8lLSdEPU1pZw4mE2MWyuP8SKNiTIWHAcVkEPHOiB2Kd3ZP0B2r8%2BOc1%2FIPRr%2BynDYSOxbhBqlZElC77gjuBe2byLyHm67Ru2qVeDtSLSFCXEgFv0SlMFYwUb4n16cJbqPNKoLvV7ZeaJQIbdclSruAQPkj%2BAA%2FPJgTZQLOl%2Fg6PkEWJt6BoBULPNhnwzLfIqbyrmHci67%2F8RcfQlBVVkbYLL%2B94V%2Fr0xdn0ZQdA73nVnnpN85FxIJ0y%2BmppKuUHMPaJlcIGOqUB656TNrFS4EUM2b%2F4N%2F3CiBPAjL266ada7GcGy6dMEA1hkMKJnqBQI%2FX41gvrDLgMhuunoOIvRmj46fXQT8iYWgrBsO8jkIFE6YRT5PhsnxBfqhVfm1sJ0mIhg3p75JPVTgGqBdSkqoFifHrr0Nvp9ILsfu1qAJAHezeSdFEc%2BDbq%2BLFelG8jAy9qW3JAsM%2BoVYOlz%2BsTJIOSw9v3iGkOpeicieJT&X-Amz-Signature=43148ab23f35a6aad7e20f2cb910dc4382bfac5568fcd6b4481ab8eb91ef0234&X-Amz-SignedHeaders=host&x-id=GetObject",
                  "expiry_time" => "2025-06-08T12:38:28.886Z",
                },
                "type" => "file",
              },
            )
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
          described_class.new id: TestConnection::DB_UPDATE_PAGE_ID, assign: [
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

          it_behaves_like "dry run", :patch, :page_path, use_id: true, json_method: :property_values_json
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
                "plain_text" => PAGE_TITLE_FOR_CREATED_PAGE,
                "text" => {
                  "content" => PAGE_TITLE_FOR_CREATED_PAGE,
                  "link" => nil,
                },
                "type" => "text",
              },
            ],
            "type" => "title",
          },
        },
      }
      let(:parent_data_source) { DataSource.new id: TestConnection::PARENT_DATA_SOURCE_ID }

      context "when build_child_page" do
        let(:target) do
          parent_data_source.build_child_page TitleProperty, "Name" do |_, ps|
            ps["Name"] << "New Page by data_source_id"
          end
        end

        it { expect(target).to be_new_record }

        it_behaves_like "property values json", {
          "parent" => {
            "data_source_id" => TestConnection::PARENT_DATA_SOURCE_ID,
          },
        }.merge(create_page_title)

        describe "dry_run" do
          let(:dry_run) { target.save dry_run: true }

          it_behaves_like "dry run", :post, :pages_path, json_method: :property_values_json
        end

        describe "create" do
          before { target.save }

          it_behaves_like "property values json", {}
          it { expect(target.id).to eq "267d8e4e98ab81ce88f2c23f71324a63" }
          it { expect(target).not_to be_new_record }
        end
      end

      context "when create_child_page" do
        context "not dry_run" do
          let(:target) do
            parent_data_source.create_child_page TitleProperty, "Name" do |_, ps|
              ps["Name"] << PAGE_TITLE_FOR_CREATED_PAGE
            end
          end

          it_behaves_like "property values json", {}
          it { expect(target.id).to eq "267d8e4e98ab81ce88f2c23f71324a63" }
          it { expect(target).not_to be_new_record }
        end

        context "dry_run" do
          let(:target) do
            parent_data_source.build_child_page TitleProperty, "Name" do |_, ps|
              ps["Name"] << "New Page Title"
            end
          end
          let(:dry_run) do
            parent_data_source.create_child_page TitleProperty, "Name", dry_run: true do |_, ps|
              ps["Name"] << "New Page Title"
            end
          end

          it_behaves_like "dry run", :post, :pages_path, json_method: :property_values_json
        end
      end
    end

    describe "create with template" do
      create_page_title = {
        "properties" => {
          "Name" => {
            "title" => [
              {
                "href" => nil,
                "plain_text" => PAGE_TITLE_FOR_CREATED_PAGE_WITH_TEMPLATE,
                "text" => {
                  "content" => PAGE_TITLE_FOR_CREATED_PAGE_WITH_TEMPLATE,
                  "link" => nil,
                },
                "type" => "text",
              },
            ],
            "type" => "title",
          },
        },
      }
      let(:parent_data_source) { DataSource.new id: TestConnection::TEST_TEMPLATE_DATA_SOURCE_ID }
      let(:template_page) { instance_double Page, id: TestConnection::TEMPLATE_PAGE_ID }

      context "when build_child_page" do
        let(:target) do
          parent_data_source.build_child_page TitleProperty, "Name", template_page: template_page do |_, ps|
            ps["Name"] << PAGE_TITLE_FOR_CREATED_PAGE_WITH_TEMPLATE
          end
        end

        it { expect(target).to be_new_record }

        it_behaves_like "property values json", {
          "parent" => {
            "data_source_id" => TestConnection::TEST_TEMPLATE_DATA_SOURCE_ID,
          },
          "template" => {
            "type" => "template_id",
            "template_id" => TestConnection::TEMPLATE_PAGE_ID,
          },
        }.merge(create_page_title)

        describe "dry_run" do
          let(:dry_run) { target.save dry_run: true }

          it_behaves_like "dry run", :post, :pages_path, json_method: :property_values_json
        end

        describe "create" do
          before { target.save }

          it_behaves_like "property values json", {}
          it { expect(target.id).to eq "293d8e4e98ab81f9b18de613fc770ebb" }
          it { expect(target).not_to be_new_record }
        end
      end

      context "create_child_page" do
        context "not dry_run" do
          let(:target) do
            parent_data_source.create_child_page TitleProperty, "Name", template_page: template_page do |_, ps|
              ps["Name"] << PAGE_TITLE_FOR_CREATED_PAGE_WITH_TEMPLATE
            end
          end

          it_behaves_like "property values json", {}
          it { expect(target.id).to eq "293d8e4e98ab81f9b18de613fc770ebb" }
          it { expect(target).not_to be_new_record }
        end

        context "dry_run" do
          let(:target) do
            parent_data_source.build_child_page TitleProperty, "Name", template_page: template_page do |_, ps|
              ps["Name"] << "New Page Title"
            end
          end
          let(:dry_run) do
            parent_data_source.create_child_page TitleProperty, "Name", template_page: template_page,
                                                                        dry_run: true do |_, ps|
              ps["Name"] << "New Page Title"
            end
          end

          it_behaves_like "dry run", :post, :pages_path, json_method: :property_values_json
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

        it_behaves_like "dry run", :post, :comments_path, json: {
          "rich_text" => [
            {
              "type" => "text",
              "text" => {
                "content" => "test comment",
                "link" => nil,
              },
              "plain_text" => "test comment",
              "href" => nil,
            },
          ],
          "parent": {"page_id" => TestConnection::TOP_PAGE_ID},
        }
      end
    end
  end
end
