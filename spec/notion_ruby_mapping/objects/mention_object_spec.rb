# frozen_string_literal: true

module NotionRubyMapping
  RSpec.describe MentionObject do
    tc = TestConnection.instance
    url = "https://www.google.com/"

    subject { target.property_values_json }
    describe "property_values_json" do
      {
        "user" => [
          {
            "user_id" => "ABC",
            "plain_text" => "@Anonymous",
          },
          {
            "type" => "user",
            "user" => {
              "object" => "user",
              "id" => "ABC",
            },
          },
          "@Anonymous",
        ],
        "page" => [
          {
            "page_id" => "ABC",
            "plain_text" => "@Anonymous",
          },
          {
            "type" => "page",
            "page" => {
              "id" => "ABC",
            },
          },
          "@Anonymous",
        ],
        "database" => [
          {
            "database_id" => "ABC",
            "plain_text" => "@Anonymous",
          },
          {
            "type" => "database",
            "database" => {
              "id" => "ABC",
            },
          },
          "@Anonymous",
        ],
        "date(start only)" => [
          {
            "start" => "2022-02-21",
            "plain_text" => "2022-02-21 → ",
          },
          {
            "type" => "date",
            "date" => {
              "start" => "2022-02-21",
            },
          },
          "2022-02-21 → ",
        ],
        "date(start and end)" => [
          {
            "start" => "2022-02-21",
            "end" => "2022-02-22",
            "plain_text" => "2022-02-21 → 2022-02-22",
          },
          {
            "type" => "date",
            "date" => {
              "start" => "2022-02-21",
              "end" => "2022-02-22",
            },
          },
          "2022-02-21 → 2022-02-22",
        ],
        "date(start and time_zone)" => [
          {
            "start" => "2022-02-22T09:00",
            "time_zone" => "Asia/Tokyo",
            "plain_text" => "2022-02-22T09:00 → ",
          },
          {
            "type" => "date",
            "date" => {
              "start" => "2022-02-22T09:00",
              "time_zone" => "Asia/Tokyo",
            },
          },
          "2022-02-22T09:00 → ",
        ],
        "template_mention_date today" => [
          {
            "template_mention" => "today",
          },
          {
            "type" => "template_mention",
            "template_mention" => {
              "type" => "template_mention_date",
              "template_mention_date" => "today",
            },
          },
          "@Today",
        ],
        "template_mention_date now" => [
          {
            "template_mention" => "now",
          },
          {
            "type" => "template_mention",
            "template_mention" => {
              "type" => "template_mention_date",
              "template_mention_date" => "now",
            },
          },
          "@Now",
        ],
        "template_mention_user" => [
          {
            "template_mention" => "user",
          },
          {
            "type" => "template_mention",
            "template_mention" => {
              "type" => "template_mention_user",
              "template_mention_user" => "me",
            },
          },
          "@Me",
        ],
        "link_preview" => [
          {
            "link_preview" => url,
          },
          {
            "type" => "link_preview",
            "link_preview" => {
              "url" => url,
            },
          },
          url,
        ],
      }.each do |key, (arg, mention, plain_text)|
        link = key == "link_preview" ? url : nil
        context "mention to #{key}" do
          let(:target) { MentionObject.new arg }
          it_behaves_like :property_values_json, {
            "type" => "mention",
            "mention" => mention,
            "plain_text" => plain_text,
            "href" => link,
          }

          context "annotations" do
            %w[bold italic strikethrough underline code].each do |an|
              context "annotations #{an}" do
                let(:target) { MentionObject.new arg.merge({an => true}) }
                it_behaves_like :property_values_json, {
                  "type" => "mention",
                  "mention" => mention,
                  "annotations" => {an => true},
                  "plain_text" => plain_text,
                  "href" => link,
                }
              end
            end
          end

          context "href" do
            let(:target) { MentionObject.new arg.merge({"href" => url}) }
            it_behaves_like :property_values_json, {
              "type" => "mention",
              "mention" => mention,
              "plain_text" => plain_text,
              "href" => url,
            }
          end
        end
      end
    end

    describe "create_from_json" do
      {
        "user" => [
          "mention_user_object",
          {
            "type" => "mention",
            "mention" => {
              "type" => "user",
              "user" => {
                "object" => "user",
                "id" => "2200a911-6a96-44bb-bd38-6bfb1e01b9f6",
              },
            },
            "annotations" => {
              "bold" => false,
              "italic" => false,
              "strikethrough" => false,
              "underline" => false,
              "code" => false,
              "color" => "default",
            },
            "plain_text" => "@Hiroyuki KOBAYASHI",
            "href" => nil,
          },
        ],
        "page" => [
          "mention_page_object",
          {
            "type" => "mention",
            "mention" => {
              "type" => "page",
              "page" => {
                "id" => "2200a911-6a96-44bb-bd38-6bfb1e01b9f6",
              },
            },
            "annotations" => {
              "bold" => false,
              "italic" => false,
              "strikethrough" => false,
              "underline" => false,
              "code" => false,
              "color" => "default",
            },
            "plain_text" => "@Anonymous",
            "href" => nil,
          },
        ],
        "database" => [
          "mention_database_object",
          {
            "type" => "mention",
            "mention" => {
              "type" => "database",
              "database" => {
                "id" => "2200a911-6a96-44bb-bd38-6bfb1e01b9f6",
              },
            },
            "annotations" => {
              "bold" => false,
              "italic" => false,
              "strikethrough" => false,
              "underline" => false,
              "code" => false,
              "color" => "default",
            },
            "plain_text" => "@Anonymous",
            "href" => nil,
          },
        ],
        "date" => [
          "mention_date_object",
          {
            "type" => "mention",
            "mention" => {
              "type" => "date",
              "date" => {
                "start" => "2022-02-21",
                "end" => nil,
                "time_zone" => nil,
              },
            },
            "annotations" => {
              "bold" => false,
              "italic" => false,
              "strikethrough" => false,
              "underline" => false,
              "code" => false,
              "color" => "default",
            },
            "plain_text" => "2022-02-21 → ",
            "href" => nil,
          },
        ],
        "template_mention_date_today" => [
          "template_mention_date_today_object",
          {
            "type" => "mention",
            "mention" => {
              "type" => "template_mention",
              "template_mention" => {
                "type" => "template_mention_date",
                "template_mention_date" => "today",
              },
            },
            "annotations" => {
              "bold" => false,
              "italic" => false,
              "strikethrough" => false,
              "underline" => false,
              "code" => false,
              "color" => "default",
            },
            "plain_text" => "@Today",
            "href" => nil,
          },
        ],
        "template_mention_date_now" => [
          "template_mention_date_now_object",
          {
            "type" => "mention",
            "mention" => {
              "type" => "template_mention",
              "template_mention" => {
                "type" => "template_mention_date",
                "template_mention_date" => "now",
              },
            },
            "annotations" => {
              "bold" => false,
              "italic" => false,
              "strikethrough" => false,
              "underline" => false,
              "code" => false,
              "color" => "default",
            },
            "plain_text" => "@Now",
            "href" => nil,
          },
        ],
        "template_mention_user" => [
          "template_mention_user_object",
          {
            "type" => "mention",
            "mention" => {
              "type" => "template_mention",
              "template_mention" => {
                "type" => "template_mention_user",
                "template_mention_user" => "me",
              },
            },
            "annotations" => {
              "bold" => false,
              "italic" => false,
              "strikethrough" => false,
              "underline" => false,
              "code" => false,
              "color" => "default",
            },
            "plain_text" => "@Me",
            "href" => nil,
          },
        ],
        "mention_link_preview" => [
          "mention_link_preview_object",
          {
            "type" => "mention",
            "mention" => {
              "type" => "link_preview",
              "link_preview" => {
                "url" => "https://github.com/hkob/notion_ruby_mapping",
              },
            },
            "annotations" => {
              "bold" => false,
              "italic" => false,
              "strikethrough" => false,
              "underline" => false,
              "code" => false,
              "color" => "default",
            },
            "plain_text" => "https://github.com/hkob/notion_ruby_mapping",
            "href" => "https://github.com/hkob/notion_ruby_mapping",
          },
        ],
        "mention_link_mention" => [
          "mention_link_mention_object",
          {
            "type" => "mention",
            "mention" => {
              "type" => "link_mention",
              "link_mention" => {
                "href" => "https://hkob.hatenablog.com/",
                "title" => "hkob’s blog",
                "icon_url" => "https://hkob.hatenablog.com/icon/link",
                "link_provider" => "hkob’s blog",
                "thumbnail_url" => "https://cdn.blog.st-hatena.com/images/theme/og-image-1500.png"
              }
            },
            "annotations" => {
              "bold" => false,
              "italic" => false,
              "strikethrough" => false,
              "underline" => false,
              "code" => false,
              "color" => "default"
            },
            "plain_text" => "https://hkob.hatenablog.com/",
            "href" => "https://hkob.hatenablog.com/"
          },
        ],
      }.each do |key, (fname, answer)|
        context key do
          print key
          let(:target) { RichTextObject.create_from_json tc.read_json(fname) }
          it_behaves_like :property_values_json, answer
        end
      end
    end
  end
end
