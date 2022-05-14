# frozen_string_literal: true

require_relative "../../spec_helper"

module NotionRubyMapping
  RSpec.describe Block do
    tc = TestConnection.instance
    let!(:nc) { tc.nc }

    block_json_ans = {
      bookmark: {
        "object" => "block",
        "type" => "bookmark",
        "bookmark" => {
          "url" => "https://hkob.notion.site/",
          "caption" => [],
        },
      },
      breadcrumb: {
        "object" => "block",
        "type" => "breadcrumb",
        "breadcrumb" => {},
      },
      bulleted_list_item: {
        "object" => "block",
        "type" => "bulleted_list_item",
        "bulleted_list_item" => {
          "rich_text" => [
            {
              "type" => "text",
              "text" => {
                "content" => "Bulleted list",
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
              "href" => nil,
              "plain_text" => "Bulleted list",
            },
          ],
          "color" => "default",
        },
      },
      callout: {
        "object" => "block",
        "type" => "callout",
        "callout" => {
          "rich_text" => [
            {
              "type" => "text",
              "text" => {
                "content" => "Callout",
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
              "href" => nil,
              "plain_text" => "Callout",
            },
          ],
          "color" => "gray_background",
        },
      },
      child_database: {
        "object" => "block",
        "type" => "child_database",
        "child_database" => {
          "title" => "Child database",
        },
      },
      child_page: {
        "object" => "block",
        "type" => "child_page",
        "child_page" => {
          "title" => "Child page",
        },
      },
      code: {
        "object" => "block",
        "type" => "code",
        "code" => {
          "rich_text" => [
            {
              "type" => "text",
              "text" => {
                "content" => "% ls -l",
                "link" => nil,
              },
              "annotations" => {
                "bold" => false,
                "italic" => false,
                "strikethrough" => false,
                "underline" => false,
                "code" => false,
                "color" => "default",
              },
              "href" => nil,
              "plain_text" => "% ls -l",
            },
          ],
          "language" => "shell",
          "caption" => [],
        },
      },
      column: {
        "object" => "block",
        "type" => "column",
        "column" => {
        },
      },
      column_list: {
        "object" => "block",
        "type" => "column_list",
        "column_list" => {
        },
      },
      divider: {
        "object" => "block",
        "type" => "divider",
        "divider" => {},
      },
      embed_twitter: {
        "object" => "block",
        "type" => "embed",
        "embed" => {
          "url" => "https://twitter.com/hkob/status/1517825460025331712",
          "caption" => [],
        },
      },
      equation: {
        "object" => "block",
        "type" => "equation",
        "equation" => {
          "expression" => "x = \\frac{-b\\pm\\sqrt{b^2-4ac}}{2a}",
        },
      },
      file: {
        "object" => "block",
        "type" => "file",
        "file" => {
          "type" => "file",
          "file" => {
            "url" => "https://s3.us-west-2.amazonaws.com/secure.notion-static.com/c55cf49f-fcb4-497e-9645-d484f03bf1d5/sample.txt?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Content-Sha256=UNSIGNED-PAYLOAD&X-Amz-Credential=AKIAT73L2G45EIPT3X45%2F20220426%2Fus-west-2%2Fs3%2Faws4_request&X-Amz-Date=20220426T132600Z&X-Amz-Expires=3600&X-Amz-Signature=0a6b8b6a0d6ae1ca7ec024d357b2c3eb52ed6f0ce14bcead00da1961ad03a6de&X-Amz-SignedHeaders=host&x-id=GetObject",
            "expiry_time" => "2022-04-26T14:26:00.536Z",
          },
          "caption" => [],
        },
      },
      heading_1: {
        "object" => "block",
        "type" => "heading_1",
        "heading_1" => {
          "rich_text" => [
            {
              "type" => "text",
              "text" => {
                "content" => "Heading 1",
                "link" => nil,
              },
              "annotations" => {
                "bold" => false,
                "italic" => false,
                "strikethrough" => false,
                "underline" => false,
                "code" => false,
                "color" => "default",
              },
              "plain_text" => "Heading 1",
              "href" => nil,
            },
          ],
          "color" => "default",
        },
      },
      heading_2: {
        "object" => "block",
        "type" => "heading_2",
        "heading_2" => {
          "rich_text" => [
            {
              "type" => "text",
              "text" => {
                "content" => "Heading 2",
                "link" => nil,
              },
              "annotations" => {
                "bold" => false,
                "italic" => false,
                "strikethrough" => false,
                "underline" => false,
                "code" => false,
                "color" => "default",
              },
              "plain_text" => "Heading 2",
              "href" => nil,
            },
          ],
          "color" => "default",
        },
      },
      heading_3: {
        "object" => "block",
        "type" => "heading_3",
        "heading_3" => {
          "rich_text" => [
            {
              "type" => "text",
              "text" => {
                "content" => "Heading 3",
                "link" => nil,
              },
              "annotations" => {
                "bold" => false,
                "italic" => false,
                "strikethrough" => false,
                "underline" => false,
                "code" => false,
                "color" => "default",
              },
              "plain_text" => "Heading 3",
              "href" => nil,
            },
          ],
          "color" => "default",
        },
      },
      image_external: {
        "object" => "block",
        "type" => "image",
        "image" => {
          "caption" => [],
          "type" => "external",
          "external" => {
            "url" => "https://cdn.worldvectorlogo.com/logos/notion-logo-1.svg",
          },
        },
      },
      link_preview_dropbox: {
        "object" => "block",
        "type" => "link_preview",
        "link_preview" => {
          "url" => "https://www.dropbox.com/s/8d6kjlpdlfqiec5/complex.pdf?dl=0",
        },
      },
      link_to_page: {
        "object" => "block",
        "type" => "link_to_page",
        "link_to_page" => {
          "type" => "page_id",
          "page_id" => "c01166c6-13ae-45cb-b968-18b4ef2f5a77",
        },
      },
      paragraph: {
        "object" => "block",
        "type" => "paragraph",
        "paragraph" => {
          "rich_text" => [
            {
              "type" => "text",
              "text" => {
                "content" => "Text",
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
              "href" => nil,
              "plain_text" => "Text",
            },
          ],
          "color" => "default",
        },
      },
      numbered_list_item: {
        "object" => "block",
        "type" => "numbered_list_item",
        "numbered_list_item" => {
          "rich_text" => [
            {
              "type" => "text",
              "text" => {
                "content" => "Numbered list",
                "link" => nil,
              },
              "annotations" => {
                "bold" => false,
                "italic" => false,
                "strikethrough" => false,
                "underline" => false,
                "code" => false,
                "color" => "default",
              },
              "plain_text" => "Numbered list",
              "href" => nil,
            },
          ],
          "color" => "default",
        },
      },
      pdf: {
        "object" => "block",
        "type" => "pdf",
        "pdf" => {
          "caption" => [],
          "type" => "external",
          "external" => {
            "url" => "https://github.com/onocom/sample-files-for-demo-use/raw/151dd797d54d7e0ae0dc50e8e19d7965b387e202/sample-pdf.pdf",
          },
        },
      },
      quote: {
        "object" => "block",
        "type" => "quote",
        "quote" => {
          "rich_text" => [
            {
              "type" => "text",
              "text" => {
                "content" => "Quote",
                "link" => nil,
              },
              "annotations" => {
                "bold" => false,
                "italic" => false,
                "strikethrough" => false,
                "underline" => false,
                "code" => false,
                "color" => "default",
              },
              "plain_text" => "Quote",
              "href" => nil,
            },
          ],
          "color" => "default",
        },
      },
      synced_block_original: {
        "object" => "block",
        "type" => "synced_block",
        "synced_block" => {
          "synced_from" => nil,
        },
      },
      synced_block_copy: {
        "object" => "block",
        "type" => "synced_block",
        "synced_block" => {
          "synced_from" => {
            "type" => "block_id",
            "block_id" => "4815032e-6f24-43e4-bc8c-9bdc6299b090",
          },
        },
      },
      table: {
        "object" => "block",
        "type" => "table",
        "table" => {
          "table_width" => 2,
          "has_column_header" => true,
          "has_row_header" => true,
        },
      },
      table_of_contents: {
        "object" => "block",
        "type" => "table_of_contents",
        "table_of_contents" => {
          "color" => "gray",
        },
      },
      table_row: {
        "object" => "block",
        "type" => "table_row",
        "table_row" => {
          "cells" => [
            [
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
                "plain_text" => "Title",
                "text" => {
                  "content" => "Title",
                  "link" => nil},
                "type" => "text",
              },
            ],
            [
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
                "plain_text" => " Contents",
                "text" => {
                  "content" => " Contents",
                  "link" => nil,
                },
                "type" => "text",
              },
            ],
          ],
        },
      },
      template: {
        "object" => "block",
        "type" => "template",
        "template" => {
          "rich_text" => [
            {
              "type" => "text",
              "text" => {
                "content" => "Add a new to-do",
                "link" => nil,
              },
              "annotations" => {
                "bold" => false,
                "italic" => false,
                "strikethrough" => false,
                "underline" => false,
                "code" => false,
                "color" => "default",
              },
              "plain_text" => "Add a new to-do",
              "href" => nil,
            },
          ],
        },
      },
      to_do: {
        "object" => "block",
        "type" => "to_do",
        "to_do" => {
          "rich_text" => [],
          "checked" => false,
          "color" => "default",
        },
      },
      toggle: {
        "object" => "block",
        "type" => "toggle",
        "toggle" => {
          "rich_text" => [
            {
              "type" => "text",
              "text" => {
                "content" => "Toggle",
                "link" => nil,
              },
              "annotations" => {
                "bold" => false,
                "italic" => false,
                "strikethrough" => false,
                "underline" => false,
                "code" => false,
                "color" => "default",
              },
              "plain_text" => "Toggle",
              "href" => nil,
            },
          ],
          "color" => "default",
        },
      },
      toggle_heading_1: {
        "object" => "block",
        "type" => "heading_1",
        "heading_1" => {
          "rich_text" => [
            {
              "type" => "text",
              "text" => {
                "content" => "Toggle Heading 1",
                "link" => nil,
              },
              "annotations" => {
                "bold" => false,
                "italic" => false,
                "strikethrough" => false,
                "underline" => false,
                "code" => false,
                "color" => "default",
              },
              "plain_text" => "Toggle Heading 1",
              "href" => nil,
            },
          ],
          "color" => "default",
        },
      },
      toggle_heading_2: {
        "object" => "block",
        "type" => "heading_2",
        "heading_2" => {
          "rich_text" => [
            {
              "type" => "text",
              "text" => {
                "content" => "Toggle Heading 2",
                "link" => nil,
              },
              "annotations" => {
                "bold" => false,
                "italic" => false,
                "strikethrough" => false,
                "underline" => false,
                "code" => false,
                "color" => "default",
              },
              "plain_text" => "Toggle Heading 2",
              "href" => nil,
            },
          ],
          "color" => "default",
        },
      },
      toggle_heading_3: {
        "object" => "block",
        "type" => "heading_3",
        "heading_3" => {
          "rich_text" => [
            {
              "type" => "text",
              "text" => {
                "content" => "Toggle Heading 3",
                "link" => nil,
              },
              "annotations" => {
                "bold" => false,
                "italic" => false,
                "strikethrough" => false,
                "underline" => false,
                "code" => false,
                "color" => "default",
              },
              "plain_text" => "Toggle Heading 3",
              "href" => nil,
            },
          ],
          "color" => "default",
        },
      },
      video: {
        "object" => "block",
        "type" => "video",
        "video" => {
          "caption" => [],
          "type" => "external",
          "external" => {
            "url" => "https://youtu.be/gp2yhkVw0z4",
          },
        },
      },
    }

    TestConnection::BLOCK_ID_HASH.each do |key, id|
      describe "For #{key} block" do
        let(:target) { Block.find id }
        it "receive id" do
          expect(target.id).to eq nc.hex_id(id)
        end

        if (ans = block_json_ans[key])
          it_behaves_like :raw_json, :block_json, ans
        end

        can_have_children = %i[bulleted_list_item paragraph inline_contents numbered_list_item synced_block template
                               toggle heading_1 heading_2 heading_3 toggle_heading_1 toggle_heading_2
                               toggle_heading_3 quote table to_do synced_block_original callout].include? key
        it "can #{key} have children? = #{can_have_children}" do
          expect(target.can_have_children).to eq can_have_children
        end
      end
    end

    describe "create child block" do
      page_id = TestConnection::BLOCK_CREATE_TEST_PAGE_ID
      block_id = TestConnection::BLOCK_CREATE_TEST_BLOCK_ID
      let(:org_page) { Page.new id: page_id }
      let(:org_block) { Block.new(id: block_id).callout "ABC", emoji: "💡" }
      let(:sub_block) { Block.new.paragraph "with children" }
      {
        bookmark: {"page": "d58295d7-a7f6-439a-b93b-143e967b0b1d", "block": "ea528b3d-1831-4f07-b807-034b5b9f0f46"},
        breadcrumb: {"page": "e74432d1-f10e-497f-9827-88d21ab1bccd", "block": "80e7a685-230d-458f-8607-2cf5187c5132"},
        bulleted_list_item: {
          "page": "26b133b5-000b-4586-aea7-169398759a1d",
          "block": "9f5621f8-ab4a-4ec5-b544-06a94195dde8",
        },
        callout_emoji: {
          "page": "31188380-c08c-44de-9170-616c62f51046",
          "block": "bbbb00cf-f7bf-4620-ab52-df081c8663ad",
        },
        callout_url: {"page": "8f161078-6aef-4511-96df-4aab2987b9fb", "block": "91877438-0134-4aa4-b7ad-5037cdcc1b96"},
        code: {"page": "12c15711-2a3c-48a5-9056-d628cabcc71f", "block": "5eabb547-a266-4a8b-9a3d-88a3eb8d0d69"},
        column_list: {"page": "157e2b06-7a06-474c-94e9-9529c0dc1ea6", "block": "fbad10e3-131d-4984-8f4e-a9f4ce8779aa"},
        divider: {"page": "f7392c51-9a12-4890-9e3d-b8447f21750f", "block": "ade41d26-0916-4360-8e49-3649b52d0bd1"},
        embed: {"page": "65de2ce6-b95d-426a-8c5d-b4d673a0e236", "block": "4575a8ad-9945-45bd-8045-1607eaa56599"},
        equation: {"page": "eac699c3-bff0-4505-aaf2-6c050858c711", "block": "0141e54e-47eb-4e87-b662-40bcea3499ff"},
        file: {"page": "ae7e9e7f-2a02-44e7-94ad-366a1e8b6d96", "block": "ada860b0-9d60-41f5-b284-b2e892cf0d03"},
        heading_1: {"page": "474cfb85-f3a2-46fc-9b3f-d0f98e2b838f", "block": "b93a5209-c2ce-47fa-a9c9-a211abf4dd22"},
        heading_2: {"page": "562086fa-3ec3-4b3f-b552-9f40e792560c", "block": "d9853af3-e056-4d36-b097-35bef5c25b37"},
        heading_3: {"page": "fbca4d2b-8cb4-4104-97f1-f461a79e006b", "block": "ee1b1100-a975-4050-abe2-6b2407e4eb19"},
        image: {"page": "bd83ff96-c800-4f0b-b0c9-ddc783f0b2d4", "block": "75f48876-96e8-4d61-bcab-9fd5946002c9"},
        link_to_page_page: {
          "page": "4b8f1a98-5916-4807-9bfc-80c902472f29",
          "block": "f3e70de8-9337-4d99-bf07-65f2688ffecf",
        },
        link_to_page_database: {
          "page": "094da086-f2ac-4e30-9d82-facfc04bf67f",
          "block": "81956e6c-3d93-430c-b10d-dc2c77c9d4c8",
        },
        numbered_list_item: {
          "page": "97d2b76f-b42f-4d2f-9aa4-f05eadda2c98",
          "block": "c17d8067-f418-4bf7-a276-5cc361607217",
        },
        paragraph: {"page": "90055826-5b5d-4dce-b9fe-375e9df0b34c", "block": "87081ebd-848c-495b-aec7-2b5789397522"},
        pdf: {"page": "878fd86e-be37-482f-b637-d09fb63eaee8", "block": "1784ba54-9f7c-4e7b-becb-bf8119a6c993"},
        quote: {"page": "995afb4a-b0a3-4cee-aaca-fa170c96dc5f", "block": "6155d9f6-92ba-4e30-bc97-08d5c5aff7c3"},
        synced_block_original: {
          "page": "3ece4c8f-b02b-4da5-a1e1-8803d6c088e9",
          "block": "a2a14594-e2a2-4ea0-bcc6-067f0b0a3a97",
        },
        synced_block_copy: {
          "page": "51431432-c91e-4a45-a951-d12cf53bb0e8",
          "block": "a8a432be-8a3d-4fb8-b67a-fefb7ed98c66",
        },
        table: {
          "page": "0f1542b8-08c4-4dc1-99ff-79835d7c4878",
          "block": "bd148ec6-98bf-418a-9f31-e376f0ae51c1",
        },
        table_of_contents: {
          "page": "8f1d1f22-790b-49bc-99a1-a5a9093e23c0",
          "block": "9499a95c-e62e-4a31-a6ed-62f370951ffc",
        },
        template: {"page": "7bebb5b5-9d94-4722-9e9b-8ea92f8f4e35", "block": "451f47fd-1538-4207-b258-878fc0f18d18"},
        to_do: {"page": "8c31e497-e650-4468-a62b-7f0f8788a6b4", "block": "2e0af12a-1a6c-4b6d-814f-99ebf3358a2d"},
        toggle: {"page": "7c0ea951-0281-4379-b01a-5d51860b6a8b", "block": "64bfa7fe-c525-47b2-9e0f-fa3c3d461c89"},
        toggle_heading_1: {
          "page": "7f966596-a359-463c-8f48-099cbac7e55e",
          "block": "7a4c7f18-0100-4449-a07a-3e07fcfff01a",
        },
        toggle_heading_2: {
          "page": "c37321ac-4b2c-4761-884e-a7741ea649a8",
          "block": "f6eaaa5f-265f-4c95-828e-631046404a0a",
        },
        toggle_heading_3: {
          "page": "2fa069b2-b230-4239-803d-c39e73fa4bf6",
          "block": "4cd554bf-557d-4882-97eb-e322a15b85be",
        },
        video: {
          "page": "8b74ab99-338d-4fbe-8b5c-2d225a320141",
          "block": "eb1886e1-c2c0-4c6f-8945-113108faf576",
        },
      }.each do |key, hash|
        json_method = hash[:json_method] || :children_block_json
        describe "#{key} block" do
          let(:target) do
            case key
            when :bookmark
              Block.new.bookmark "https://www.google.com", caption: "Google"
            when :breadcrumb
              Block.new.breadcrumb
            when :bulleted_list_item
              Block.new.bulleted_list_item "Bullet list item", color: "green", sub_blocks: sub_block
            when :callout_emoji
              Block.new.callout "Emoji callout", emoji: "✅", color: "blue", sub_blocks: sub_block
            when :callout_url
              Block.new.callout "Url callout", file_url: "https://img.icons8.com/ios-filled/250/000000/mac-os.png",
                                sub_blocks: sub_block
            when :code
              Block.new.code "% ls -l", caption: "List files", language: "shell"
            when :column_list
              Block.new.column_list [
                                      Block.new.callout("Emoji callout", emoji: "✅"),
                                      Block.new.callout("Url callout",
                                                        file_url: "https://img.icons8.com/ios-filled/250/000000/mac-os.png"),
                                    ]
            when :divider
              Block.new.divider
            when :embed
              Block.new.embed "https://twitter.com/hkob/status/1507972453095833601",
                              caption: "NotionRubyMapping開発記録(21)"
            when :equation
              Block.new.equation "x = \\frac{-b\\pm\\sqrt{b^2-4ac}}{2a}"
            when :file
              Block.new.file "https://img.icons8.com/ios-filled/250/000000/mac-os.png", caption: "macOS icon"
            when :heading_1
              Block.new.heading_1 "Heading 1", color: "orange_background"
            when :heading_2
              Block.new.heading_2 "Heading 2", color: "blue_background"
            when :heading_3
              Block.new.heading_3 "Heading 3", color: "gray_background"
            when :image
              Block.new.image "https://cdn.worldvectorlogo.com/logos/notion-logo-1.svg", caption: "Notion logo"
            when :link_to_page_page
              Block.new.link_to_page page_id: TestConnection::TOP_PAGE_ID
            when :link_to_page_database
              Block.new.link_to_page database_id: TestConnection::CREATED_DATABASE_ID
            when :numbered_list_item
              Block.new.numbered_list_item "Numbered list item", color: "red", sub_blocks: sub_block
            when :paragraph
              Block.new.paragraph "A sample paragraph", color: "yellow_background", sub_blocks: sub_block
            when :pdf
              Block.new.pdf "https://github.com/onocom/sample-files-for-demo-use/raw/151dd797d54d7e0ae0dc50e8e19d7965b387e202/sample-pdf.pdf"
            when :quote
              Block.new.quote "A sample quote", color: "purple", sub_blocks: sub_block
            when :synced_block_original
              Block.new.synced_block sub_blocks: [
                Block.new.bulleted_list_item("Synced block"),
                Block.new.divider,
              ]
            when :synced_block_copy
              Block.new.synced_block block_id: "4815032e-6f24-43e4-bc8c-9bdc6299b090"
            when :table
              Block.new.table has_column_header: true, has_row_header: true, table_width: 2, table_rows: [
                %w[Services Account],
                [
                  "Twitter",
                  ["hkob\n", TextObject.new("profile", "href" => "https://twitter.com/hkob/")],
                ],
                [
                  "GitHub",
                  ["hkob\n", TextObject.new("repositories", "href" => "https://github.com/hkob/")],
                ],
              ]
            when :table_of_contents
              Block.new.table_of_contents color: "pink"
            when :template
              Block.new.template "A sample template", sub_blocks: sub_block
            when :to_do
              Block.new.to_do "A sample To-Do", color: "brown_background", sub_blocks: sub_block
            when :toggle
              Block.new.toggle "A sample toggle", color: "yellow_background", sub_blocks: sub_block
            when :toggle_heading_1
              Block.new.toggle_heading_1 "Toggle Heading 1", color: "orange_background", sub_blocks: [
                Block.new.bulleted_list_item("inside Toggle Heading 1"),
              ]
            when :toggle_heading_2
              Block.new.toggle_heading_2 "Toggle Heading 2", color: "blue_background", sub_blocks: [
                Block.new.bulleted_list_item("inside Toggle Heading 2"),
              ]
            when :toggle_heading_3
              Block.new.toggle_heading_3 "Toggle Heading 3", color: "gray_background", sub_blocks: [
                Block.new.bulleted_list_item("inside Toggle Heading 3"),
              ]
            when :video
              Block.new.video "https://download.samplelib.com/mp4/sample-5s.mp4"
            else
              raise StandardError, "Unsupported block #{key}"
            end
          end
          %i[page block].each do |pb|
            is_page = pb == :page
            context "for #{pb}" do
              context "dry_run" do
                let(:dry_run) { (is_page ? org_page : org_block).append_block_children target, dry_run: true }
                it_behaves_like :dry_run, :patch, :append_block_children_page_path,
                                id: (is_page ? page_id : block_id), json_method: json_method
                # When the corresponding json files are not exist, create a retrieve script for obtaining json files.
                unless hash[pb]
                  it "write shell script" do
                    File.open "spec/fixtures/append_block_children_#{pb}_#{key}.sh", "w" do |f|
                      f.print dry_run
                    end
                    expect(true).to be_falsey
                  end
                end
              end
              if hash[pb]
                context "create" do
                  let(:block) { (is_page ? org_page : org_block).append_block_children target }
                  it { expect(block.id).to eq nc.hex_id(hash[pb]) }
                end
              end
            end
          end
        end
      end

      %i[column file image_file link_preview_dropbox].each do |key|
        describe "#{key} block" do
          let(:target) { Block.find TestConnection::BLOCK_ID_HASH[key] }
          %i[page block].each do |pb|
            is_page = pb == :page
            context "for #{pb}" do
              subject { -> { (is_page ? org_page : org_block).append_block_children target } }
              it { expect { subject.call }.to raise_error StandardError }
            end
          end
        end
      end

      # describe "paragraph block" do
      #   before do
      #     target.paragraph "Text", color: "red"
      #   end
      #   it_behaves_like :raw_json, :block_json, {
      #     "type" => "paragraph",
      #     "paragraph" => [
      #       {
      #         "text" => {
      #           "content" => "Text",
      #           "link" => nil,
      #         },
      #         "type" => "text",
      #         "href" => nil,
      #         "plain_text" => "Text",
      #       },
      #     ],
      #     "color" => "red",
      #   }
      # end
    end
  end
end
