# frozen_string_literal: true

require_relative "../spec_helper"

module NotionRubyMapping
  RSpec.describe Page do
    let(:tc) { TestConnection.instance }
    let!(:nc) { tc.nc }

    describe "find" do
      subject { -> { Page.find page_id } }

      context "For an existing top page" do
        let(:page_id) { tc.top_page_id }
        it "receive id" do
          expect(subject.call.id).to eq nc.hex_id(tc.top_page_id)
        end

        it "receive title" do
          expect(subject.call.title).to eq "notion_ruby_mapping_test_data"
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
          let(:page_id) { tc.unpermitted_page }
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
        let(:page_id) { tc.top_page_id }
        it "has not json before reload" do
          expect(page.json).to be_nil
        end

        it "receive id" do
          expect(subject.call.id).to eq nc.hex_id(tc.top_page_id)
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
          let(:page_id) { tc.unpermitted_page_id }
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
        let(:page) { Page.find tc.db_first_page_id }
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
              "type" => "multi_select",
              "multi_select" => [
                {
                  "name" => "Multi Select 2",
                },
                {
                  "name" => "Multi Select 1",
                },
              ],
            },
          },
          PeopleProperty, "UserTitle", {
            "UserTitle" => {
              "people" => [
                {
                  "object" => "user",
                  "id" => "2200a911-6a96-44bb-bd38-6bfb1e01b9f6",
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
              p klass
              expect(target).to be_is_a klass
            end
            it_behaves_like :property_values_json, ans
          end
        end
      end
    end

    describe "update_icon" do
      let(:top_page) { Page.new id: tc.top_page_id }
      before { top_page.set_icon(**params) }
      subject { top_page.icon }

      context "for emoji icon" do
        let(:params) { {emoji: "😀"} }
        it "update icon (emoji)" do
          is_expected.to eq({"type" => "emoji", "emoji" => "😀"})
        end
      end

      context "for link icon" do
        let(:url) { "https://cdn.profile-image.st-hatena.com/users/hkob/profile.png" }
        let(:params) { {url: url} }
        it "update icon (link)" do
          is_expected.to eq({"type" => "external", "external" => {"url" => url}})
        end
      end
    end

    describe "update" do
      context "update payload check for loaded object" do
        let(:page) { Page.find tc.db_first_page_id }
        let(:properties) { page.properties }
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
              if %w[Title TextTitle].include? key
                properties[key][0].send(method, value)
              else
                properties[key].send(method, value)
              end
              expect(page.property_values_json).to eq({"properties" => json})
            }
          end
        end
      end

      context "update check using API" do
        let(:page) do
          Page.new id: tc.db_update_page_id, assign: [
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
            RichTextProperty, "TextTitle",
            TitleProperty, "Title",
            UrlProperty, "UrlTitle"
          ]
        end
        it "updates properties" do
          ps = page.properties.values_at "CheckboxTitle", "DateTitle", "MailTitle", "File&MediaTitle",
                                         "MultiSelectTitle", "UserTitle", "RelationTitle", "NumberTitle",
                                         "TelTitle", "SelectTitle", "TextTitle", "Title", "UrlTitle"
          cp, dp, mp, fp, msp, up, rp, np, telp, sp, tp, titlep, urlp = ps
          cp.checkbox = true
          dp.start_date = "2022-03-14"
          mp.email = "hkobhkob@gmail.com"
          fp.files = "https://img.icons8.com/ios-filled/250/000000/mac-os.png"
          msp.multi_select = "Multi Select 2"
          up.people = tc.user_hkob
          rp.relation = tc.parent1_page_id
          np.number = 3.1415926535
          telp.phone_number = "zz-zzzz-zzzz"
          sp.select = "Select 3"
          tp << TextObject.new("new text")
          titlep << "MNO"
          urlp.url = "https://www.google.com/"
          page.update # update page and reload properties
          aggregate_failures do
            {
              cp => {
                "type" => "checkbox",
                "checkbox" => true,
              },
              dp => {
                "type" => "date",
                "date" => {
                  "start" => "2022-03-14",
                  "end" => nil,
                  "time_zone" => nil,
                },
              },
              mp => {
                "type" => "email",
                "email" => "hkobhkob@gmail.com",
              },
              fp => {
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
              msp => {
                "type" => "multi_select",
                "multi_select" => [
                  {
                    "name" => "Multi Select 2",
                  },
                ],
              },
              up => {
                "people" => [
                  {
                    "object" => "user",
                    "id" => "2200a911-6a96-44bb-bd38-6bfb1e01b9f6",
                  },
                ],
                "type" => "people",
              },
              rp => {
                "type" => "relation",
                "relation" => [
                  {
                    "id" => "860753bb-6d1f-48de-9621-1fa6e0e31f82",
                  },
                ],
              },
              np => {
                "type" => "number",
                "number" => 3.1415926535,
              },
              telp => {
                "type" => "phone_number",
                "phone_number" => "zz-zzzz-zzzz",
              },
              sp => {
                "type" => "select",
                "select" => {
                  "name" => "Select 3",
                },
              },
              tp => {
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
                    "plain_text" => "new text",
                    "text" => {
                      "content" => "new text",
                      "link" => nil,
                    },
                    "type" => "text",
                  },
                ],
              },
              titlep => {
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
                    "plain_text" => "MNO",
                    "text" => {
                      "content" => "MNO",
                      "link" => nil,
                    },
                    "type" => "text",
                  },
                ],
              },
              urlp => {
                "type" => "url",
                "url" => "https://www.google.com/",
              },
            }.each do |p, json|
              expect(p.property_values_json[p.name]).to eq(json)
            end
          end
        end
      end
    end
  end
end
