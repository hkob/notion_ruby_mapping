# frozen_string_literal: true

require "notion_ruby_mapping"
require "json"
require "webmock"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
  config.before do
    @tc = NotionRubyMapping::TestConnection.instance
  end
end

# This module is only testing, so RSpec can execute on Ruby 3.1
module NotionRubyMapping
  class TestConnection
    include Singleton
    # page_id
    TOP_PAGE_ID = "c01166c613ae45cbb96818b4ef2f5a77"
    UNPERMITTED_PAGE_ID = "4a6eb31244204fecb488da11f3caf871"
    DB_FIRST_PAGE_ID = "dcdc805c85fa4155a55c20fc28771af7"
    DB_SECOND_PAGE_ID = "6601e719a39a460c908e8909467fcccf"
    DB_UPDATE_PAEG_ID = "206ffaa277744a99baf593e28730240c"
    PARENT1_PAGE_ID = "860753bb6d1f48de96211fa6e0e31f82"
    BLOCK_TEST_PAGE_ID = "67cf059ce74646a0b72d481c9ff5d386"
    BLOCK_CREATE_TEST_PAGE_ID = "3867910a437340be931cf7f2c06443c6"
    # database_id
    DATABASE_ID = "c37a2c66e3aa4a0da44773de3b80c253"
    UNPERMITTED_DATABASE_ID = "668d797c76fa49349b05ad288df2d136"
    PARENT_DATABASE_ID = "1d6b1040a9fb48d99a3d041429816e9f"
    CREATED_DATABASE_ID = "c7697137d49f49c2bbcdd6a665c4f921"
    # block_id
    H1_BLOCK_ID = "0250fb6d600142eca4c74efb8794fc6b"
    UNPERMITTED_BLOCK_ID = "0c940186ab704351bb342d16f0635d49"
    PARAGRAPH_BLOCK_ID = "79ddb5ed15c74a409cf6a018d23ceb19"
    BLOCK_ID_HASH = {
      bookmark: "aa1c25bcb1724a36898d3ce5e1f572b7",
      breadcrumb: "6d2ed6f38f744e838766747b6d7995f6",
      bulleted_list_item: "8a0d35c5145e41fd89ace46deb85d24f",
      callout: "715a6550c737444fac994be7822c88d3",
      child_database: "ea525a784669470db4258c4d7cb95667",
      child_page: "0f3e507322d848eb926be808df84c169",
      code: "c9a46c89109b486a81056ca82f4f6515",
      column: "29a966bb81eb43e5aae1b44992525775",
      column_list: "93195eab21f74419bf440e4c07092573",
      divider: "e34f7164453548fd9c491d320f77bda2",
      embed_twitter: "e4c0811c71544fed9e8c02d885c898ef",
      equation: "6a1f76eb337e4169a77bcb8b1d79a88e",
      file: "0da49a8b963e42e6a9ee0deb765d5b40",
      heading_1: "0a58761ef3b4429fb86e0ad9ff815fe1",
      heading_2: "d34096c962ba46339294db488ca7b8cc",
      heading_3: "fef62d738d834791b2da681816f56389",
      image_external: "ae7be0357ad1418abb8ef0f2d039220c",
      image_file: "293ace3742f545a6b8ff1352f4b3e7c6",
      inline_contents: "2515e2f2a53f40c3a2ea1b5d47afee09",
      link_preview_dropbox: "7b391df01dc5430eaae01bc0392cdcb5",
      link_to_page: "b921ff3cb13c43c2b53ad9d1ba19b8c1",
      numbered_list_item: "1860edbc410d408b87f61e37e07352a2",
      paragraph: "79ddb5ed15c74a409cf6a018d23ceb19",
      pdf: "878fd86ebe37482fb637d09fb63eaee8",
      quote: "8eba490bcc8343849cb09a739a4be91c",
      synced_block_copy: "ea7b5183eea24d30b019010921e93b2c",
      synced_block_original: "4815032e6f2443e4bc8c9bdc6299b090",
      table: "ba612e8bc85845699822ccca7ab4c709",
      table_of_contents: "0de608aac31b4c5ca84aae48d8ea05b8",
      table_row: "57fc378c9db14fef8d7472c1b2084df1",
      template: "12fe0347f8c44da0ace99c8992b5827f",
      to_do: "676129de8eac42c99449c15893775cae",
      toggle: "005923dab39f4af6bbd11be98150d2b2",
      toggle_heading_1: "82daa282435d4f9f8f3bb8c0328a963f",
      toggle_heading_2: "e5f163568adc49c59f17228589d071ac",
      toggle_heading_3: "115fb937ab6d4a2e9079921b03e50756",
      video: "bed3abe020094aa990564844f981b07a",
    }.freeze
    BLOCK_CREATE_TEST_BLOCK_ID = "82314687163e41baaf300a8a2bec57c2"
    DESTROY_BLOCK_ID = "7306e4c4bc5b48d78948e59ec0059afd"
    UPDATE_BLOCK_ID_HASH = {
      bookmark: "899e342cec84415f9ff86225704cbb75",
      bulleted_list_item: "ab51d1c7094649b5b9007ef0109b33c4",
      callout: "05386a91dfa24296b6b2ac4676006bdb",
      code: "5568c1c36fe84f12b83edfe2dda83028",
      embed: "7ba68fa8f57f456cbd7c73fa37f7f3ea",
      equation: "db334fcf9f6d4f179edbe534229b1f87",
      file: "bed94c76d41849599143d345ef48a11e",
      heading_1: "0ae3399d5599419e84af80433e1290b4",
      heading_2: "a7873498c1cc4032bc4e975b80ec1a1b",
      heading_3: "2bf3a507d066433fad10ed77b342664c",
      toggle_heading_1: "a9b7ff827c5b41dba01374b1af8fb516",
      toggle_heading_2: "00ce5fe04b5b485ba157914ae048b780",
      toggle_heading_3: "e16aa38d136e4fcaa54c3a18f6140350",
      image: "9e78e7714adf4055b78b3a1528b956d6",
      numbered_list_item: "da9929d35cd849d7990e2ee361239810",
      paragraph: "7de3e4c08c5f4082992268d154f9aefc",
      pdf: "ca7317b3b5d44a75880611264155dd48",
      quote: "56e80c562281487281f4bf34d8db02bc",
      synced_block: "1798b85f12ec4e28b13e47c591bc0ec5",
      table_of_contents: "b3c6fe0a5885498aa5cb4c4b3080f4cf",
      template: "704d8961e0fd42c9b5b08a086c84f100",
      to_do: "683ef29efbb84d78a411c541d68ccb06",
      toggle: "5b7373a8ac82456684a02e761aabf6fc",
      video: "8c49d0d66f9b45fb9bea6253997c87ba",
    }.freeze
    # user_id
    USER_HKOB_ID = "2200a9116a9644bbbd386bfb1e01b9f6"

    def initialize
      @config = YAML.load_file "env.yml"
      @nc = NotionCache.instance.create_client @config["notion_token"], debug: false, wait: 0
      generate_stubs
    end
    attr_reader :nc

    def clear_object_hash
      nc.clear_object_hash
    end

    # @param [Symbol] method
    # @param [String] json_file response body
    # @param [String] path
    # @param [Fixnum] code
    # @param [Hash] payload request body
    def stub(method, json_file, path, code, payload = nil)
      request = {
        headers: {
          "Accept" => "*/*",
          "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
          "Authorization" => "Bearer #{notion_token}",
          "Notion-Version" => NotionRubyMapping::NOTION_VERSION,
          "User-Agent" => "Faraday v1.10.0",
        },
      }
      request[:body] = JSON.generate(payload) if payload
      response = {
        body: JSON.generate(read_json(json_file)),
        status: code,
        headers: {
          "Content-Type" => "application/json",
        },
      }
      WebMock.stub_request(method, "https://api.notion.com/#{path}").with(request).to_return(response)
    end

    def generate_stubs
      WebMock.enable!
      retrieve_page
      retrieve_database
      retrieve_block
      query_database
      update_page
      create_page
      create_database
      update_database
      retrieve_block_children
      append_block_children_page
      append_block_children_block
      destroy_block
      update_block
    end

    # @param [Symbol] method
    # @param [Symbol, nil] prefix
    # @param [Symbol] path_method
    # @param [Hash<Array>] hash
    def generate_stubs_sub(method, prefix, path_method, hash)
      hash.each do |key, (id, code, payload)|
        raise StandardError, "code is missing" unless code.is_a? Integer

        path = id ? @nc.send(path_method, *id) : @nc.send(path_method)
        stub method, "#{prefix}_#{key}", path, code, payload
      end
    end

    def retrieve_page
      generate_stubs_sub :get, __method__, :page_path, {
        top: [TOP_PAGE_ID, 200],
        wrong_format: ["AAA", 400],
        unpermitted_page: [UNPERMITTED_PAGE_ID, 404],
        db_first: [DB_FIRST_PAGE_ID, 200],
        block_test_page: [BLOCK_TEST_PAGE_ID, 200],
      }
    end

    def retrieve_database
      generate_stubs_sub :get, __method__, :database_path, {
        database: [DATABASE_ID, 200],
        wrong_format: ["AAA", 400],
        unpermitted_database: [UNPERMITTED_DATABASE_ID, 404],
        created: [CREATED_DATABASE_ID, 200],
        parent: [PARENT_DATABASE_ID, 200],
      }
    end

    def retrieve_block
      generate_stubs_sub :get, __method__, :block_path, {
        h1block: [H1_BLOCK_ID, 200],
        wrong_format: ["AAA", 400],
        unpermitted_block: [UNPERMITTED_BLOCK_ID, 404],
      }
      hash = BLOCK_ID_HASH.transform_values { |id| [id, 200] }
      generate_stubs_sub :get, __method__, :block_path, hash
    end

    def query_database
      generate_stubs_sub :post, __method__, :query_database_path, {
        limit2: [DATABASE_ID, 200, {"page_size" => 2}],
        next2: [DATABASE_ID, 200, {"start_cursor" => "6601e719-a39a-460c-908e-8909467fcccf", "page_size" => 2}],
        last2: [DATABASE_ID, 200, {"start_cursor" => "dcdc805c-85fa-4155-a55c-20fc28771af7", "page_size" => 2}],
      }
    end

    def update_page
      generate_stubs_sub :patch, __method__, :page_path, {
        set_icon_emoji: [TOP_PAGE_ID, 200, {
          "icon" => {
            "type" => "emoji",
            "emoji" => "😀",
          },
        }],
        set_link_icon: [TOP_PAGE_ID, 200, {
          "icon" => {
            "type" => "external",
            "external" => {
              "url" => "https://cdn.profile-image.st-hatena.com/users/hkob/profile.png",
            },
          },
        }],
        all: [DB_UPDATE_PAEG_ID, 200, {
          "properties" => {
            "CheckboxTitle" => {
              "checkbox" => true,
              "type" => "checkbox",
            },
            "DateTitle" => {
              "type" => "date",
              "date" => {
                "start" => "2022-03-14",
                "end" => nil,
                "time_zone" => nil,
              },
            },
            "MailTitle" => {
              "email" => "hkobhkob@gmail.com",
              "type" => "email",
            },
            "File&MediaTitle" => {
              "files" => [
                {
                  "type" => "external",
                  "external" => {
                    "url" => "https://img.icons8.com/ios-filled/250/000000/mac-os.png",
                  },
                  "name" => "https://img.icons8.com/ios-filled/250/000000/mac-os.png",
                },
              ],
              "type" => "files",
            },
            "MultiSelectTitle" => {
              "type" => "multi_select",
              "multi_select" => [
                {
                  "name" => "Multi Select 2",
                },
              ],
            },
            "UserTitle" => {
              "type" => "people",
              "people" => [
                {
                  "object" => "user",
                  "id" => "2200a9116a9644bbbd386bfb1e01b9f6",
                },
              ],
            },
            "RelationTitle" => {
              "type" => "relation",
              "relation" => [
                {
                  "id" => "860753bb6d1f48de96211fa6e0e31f82",
                },
              ],
            },
            "NumberTitle" => {
              "number" => 3.1415926535,
              "type" => "number",
            },
            "TelTitle" => {
              "phone_number" => "zz-zzzz-zzzz",
              "type" => "phone_number",
            },
            "SelectTitle" => {
              "type" => "select",
              "select" => {
                "name" => "Select 3",
              },
            },
            "TextTitle" => {
              "type" => "rich_text",
              "rich_text" => [
                {
                  "type" => "text",
                  "text" => {
                    "content" => "new text",
                    "link" => nil,
                  },
                  "plain_text" => "new text",
                  "href" => nil,
                },
              ],
            },
            "Title" => {
              "type" => "title",
              "title" => [
                {
                  "type" => "text",
                  "text" => {
                    "content" => "MNO",
                    "link" => nil,
                  },
                  "plain_text" => "MNO",
                  "href" => nil,
                },
              ],
            },
            "UrlTitle" => {
              "url" => "https://www.google.com/",
              "type" => "url",
            },
          },
        }],
      }
    end

    def create_page
      generate_stubs_sub :post, __method__, :pages_path, {
        parent_database: [nil, 200, {
          "properties" => {
            "Name" => {
              "type" => "title",
              "title" => [
                {
                  "type" => "text",
                  "text" => {
                    "content" => "New Page Title",
                    "link" => nil,
                  },
                  "plain_text" => "New Page Title",
                  "href" => nil,
                },
              ],
            },
          },
          "parent" => {
            "database_id" => "1d6b1040a9fb48d99a3d041429816e9f",
          },
        }],
      }
    end

    def create_database
      generate_stubs_sub :post, __method__, :databases_path, {
        from_page: [nil, 200, {
          "properties": {
            "Checkbox": {"checkbox": {}},
            "CreatedBy": {"created_by": {}},
            "CreatedTime": {"created_time": {}},
            "Date": {"date": {}},
            "Email": {"email": {}},
            "Files": {"files": {}},
            "Formula": {"formula": {"expression": "now()"}},
            "LastEditedBy": {"last_edited_by": {}},
            "LastEditedTime": {"last_edited_time": {}},
            "MultiSelect": {
              "multi_select": {
                "options": [
                  {"name": "MS1", "color": "orange"},
                  {"name": "MS2", "color": "green"},
                ],
              },
            },
            "Number": {"number": {"format": "yen"}},
            "People": {"people": {}},
            "PhoneNumber": {"phone_number": {}},
            "Relation": {"relation": {"database_id": "c37a2c66e3aa4a0da44773de3b80c253"}},
            "Rollup": {
              "rollup": {
                "function": "sum",
                "relation_property_name": "Relation",
                "rollup_property_name": "NumberTitle",
              },
            },
            "RichText": {"rich_text": {}},
            "Select": {
              "select": {
                "options": [
                  {"name": "S1", "color": "yellow"},
                  {"name": "S2", "color": "default"},
                ],
              },
            },
            "Title": {"title": {}},
            "Url": {"url": {}},
          },
          "title": [
            {
              "type": "text",
              "text": {"content": "New database title", "link": nil},
              "plain_text": "New database title",
              "href": nil,
            },
          ],
          "parent": {
            "type": "page_id",
            "page_id": "c01166c613ae45cbb96818b4ef2f5a77",
          },
          "icon": {
            "type": "emoji",
            "emoji": "🎉",
          },
        }],
      }
    end

    def update_database
      generate_stubs_sub :patch, __method__, :database_path, {
        created: [CREATED_DATABASE_ID, 200, {
          "properties": {
            "Select": {
              "select": {
                "options": [
                  {"id": "56a526e1-0cec-4b85-b9db-fc68d00e50c6", "name": "S1", "color": "yellow"},
                  {"id": "6ead7aee-d7f0-40ba-aa5e-59bccf6c50c8", "name": "S2", "color": "default"},
                  {"name": "S3", "color": "red"},
                ],
              },
            },
            "Rollup": {
              "rollup": {
                "function": "average",
                "relation_property_name": "Relation",
                "rollup_property_name": "NumberTitle",
              },
            },
            "Relation": {
              "relation": {
                "database_id": "c37a2c66e3aa4a0da44773de3b80c253",
                "synced_property_name": "Renamed table",
                "synced_property_id": "mfBo",
              },
            },
            "Number": {"number": {"format": "percent"}},
            "MultiSelect": {
              "multi_select": {
                "options": [
                  {"id": "98aaa1c0-4634-47e2-bfae-d739a8c5e564", "name": "MS1", "color": "orange"},
                  {"id": "71756a93-cfd8-4675-b508-facb1c31af2c", "name": "MS2", "color": "green"},
                  {"name": "MS3", "color": "blue"},
                ],
              },
            },
            "Formula": {"formula": {"expression": "pi"}},
          },
          "title": [
            {
              "type": "text",
              "text": {
                "content": "New database title",
                "link": nil,
              },
              "plain_text": "New database title",
              "href": nil,
              "annotations": {
                "bold": false,
                "italic": false,
                "strikethrough": false,
                "underline": false,
                "code": false,
                "color": "default",
              },
            },
            {
              "type": "text",
              "text": {
                "content": "(Added)",
                "link": nil,
              },
              "plain_text": "(Added)",
              "href": nil,
            },
          ],
          "icon": {
            "type": "emoji",
            "emoji": "🎉",
          },
        }],
        add_property: [CREATED_DATABASE_ID, 200, {
          "properties" => {
            "added number property" => {
              "number" => {
                "format" => "euro",
              },
            },
            "added url property" => {
              "url" => {},
            },
          },
        }],
        rename_properties: [CREATED_DATABASE_ID, 200, {
          "properties" => {
            "added number property" => {"name" => "renamed number property"},
            "added url property" => {"name" => "renamed url property"},
          },
        }],
        remove_properties: [CREATED_DATABASE_ID, 200, {
          "properties" => {
            "renamed number property" => nil,
            "renamed url property" => nil,
          },
        }],
      }
    end

    def retrieve_block_children
      generate_stubs_sub :get, __method__, :block_children_page_path, {
        block_test_page: [[BLOCK_TEST_PAGE_ID, "?page_size=100"], 200],
      }
    end

    def append_block_children_hash(id)
      {
        bookmark: [
          id, 200,
          {
            "children" => [
              {
                "type" => "bookmark",
                "object" => "block",
                "bookmark" => {
                  "caption" => [
                    {
                      "type" => "text",
                      "text" => {
                        "content" => "Google",
                        "link" => nil,
                      },
                      "plain_text" => "Google",
                      "href" => nil,
                    },
                  ],
                  "url" => "https://www.google.com",
                },
              },
            ],
          }
        ],
        breadcrumb: [
          id, 200,
          {
            "children" => [
              {
                "type" => "breadcrumb",
                "object" => "block",
                "breadcrumb" => {},
              },
            ],
          }
        ],
        bulleted_list_item: [
          id, 200,
          {
            "children" => [
              {
                "type" => "bulleted_list_item",
                "object" => "block",
                "bulleted_list_item" => {
                  "rich_text" => [
                    {
                      "type" => "text",
                      "text" => {
                        "content" => "Bullet list item",
                        "link" => nil,
                      },
                      "plain_text" => "Bullet list item",
                      "href" => nil,
                    },
                  ],
                  "color" => "green",
                  "children" => [
                    {
                      "type" => "paragraph",
                      "object" => "block",
                      "paragraph" => {
                        "rich_text" => [
                          {
                            "type" => "text",
                            "text" => {
                              "content" => "with children",
                              "link" => nil,
                            },
                            "plain_text" => "with children",
                            "href" => nil,
                          },
                        ],
                        "color" => "default",
                      },
                    },
                  ],
                },
              },
            ],
          }
        ],
        callout_emoji: [
          id, 200,
          {
            "children" => [
              {
                "type" => "callout",
                "object" => "block",
                "callout" => {
                  "rich_text" => [
                    {
                      "type" => "text",
                      "text" => {
                        "content" => "Emoji callout",
                        "link" => nil,
                      },
                      "plain_text" => "Emoji callout",
                      "href" => nil,
                    },
                  ],
                  "color" => "blue",
                  "icon" => {
                    "type" => "emoji",
                    "emoji" => "✅",
                  },
                  "children" => [
                    {
                      "type" => "paragraph",
                      "object" => "block",
                      "paragraph" => {
                        "rich_text" => [
                          {
                            "type" => "text",
                            "text" => {
                              "content" => "with children",
                              "link" => nil,
                            },
                            "plain_text" => "with children",
                            "href" => nil,
                          },
                        ],
                        "color" => "default",
                      },
                    },
                  ],
                },
              },
            ],
          }
        ],
        callout_url: [
          id, 200,
          {
            "children" => [
              {
                "type" => "callout",
                "object" => "block",
                "callout" => {
                  "rich_text" => [
                    {
                      "type" => "text",
                      "text" => {
                        "content" => "Url callout",
                        "link" => nil,
                      },
                      "plain_text" => "Url callout",
                      "href" => nil,
                    },
                  ],
                  "color" => "default",
                  "icon" => {
                    "type" => "external",
                    "external" => {
                      "url" => "https://img.icons8.com/ios-filled/250/000000/mac-os.png",
                    },
                  },
                  "children" => [
                    {
                      "type" => "paragraph",
                      "object" => "block",
                      "paragraph" => {
                        "rich_text" => [
                          {
                            "type" => "text",
                            "text" => {
                              "content" => "with children",
                              "link" => nil,
                            },
                            "plain_text" => "with children",
                            "href" => nil,
                          },
                        ],
                        "color" => "default",
                      },
                    },
                  ],
                },
              },
            ],
          }
        ],
        code: [
          id, 200,
          {
            "children" => [
              {
                "type" => "code",
                "object" => "block",
                "code" => {
                  "rich_text" => [
                    {
                      "type" => "text",
                      "text" => {
                        "content" => "% ls -l",
                        "link" => nil,
                      },
                      "plain_text" => "% ls -l",
                      "href" => nil,
                    },
                  ],
                  "caption" => [
                    {
                      "type" => "text",
                      "text" => {
                        "content" => "List files",
                        "link" => nil,
                      },
                      "plain_text" => "List files",
                      "href" => nil,
                    },
                  ],
                  "language" => "shell",
                },
              },
            ],
          }
        ],
        column_list: [
          id, 200,
          {
            "children" => [
              {
                "type" => "column_list",
                "object" => "block",
                "column_list" => {
                  "children" => [
                    {
                      "type" => "column",
                      "object" => "block",
                      "column" => {
                        "children" => [
                          {
                            "type" => "callout",
                            "object" => "block",
                            "callout" => {
                              "rich_text" => [
                                {
                                  "type" => "text",
                                  "text" => {
                                    "content" => "Emoji callout",
                                    "link" => nil,
                                  },
                                  "plain_text" => "Emoji callout",
                                  "href" => nil,
                                },
                              ],
                              "color" => "default",
                              "icon" => {
                                "type" => "emoji",
                                "emoji" => "✅",
                              },
                            },
                          },
                        ],
                      },
                    },
                    {
                      "type" => "column",
                      "object" => "block",
                      "column" => {
                        "children" => [
                          {
                            "type" => "callout",
                            "object" => "block",
                            "callout" => {
                              "rich_text" => [
                                {
                                  "type" => "text",
                                  "text" => {
                                    "content" => "Url callout",
                                    "link" => nil,
                                  },
                                  "plain_text" => "Url callout",
                                  "href" => nil,
                                },
                              ],
                              "color" => "default",
                              "icon" => {
                                "type" => "external",
                                "external" => {
                                  "url" => "https://img.icons8.com/ios-filled/250/000000/mac-os.png",
                                },
                              },
                            },
                          },
                        ],
                      },
                    },
                  ],
                },
              },
            ],
          }
        ],
        divider: [
          id, 200,
          {
            "children" => [
              {
                "type" => "divider",
                "object" => "block",
                "divider" => {},
              },
            ],
          }
        ],
        embed: [
          id, 200,
          {
            "children" => [
              {
                "type" => "embed",
                "object" => "block",
                "embed" => {
                  "caption" => [
                    {
                      "type" => "text",
                      "text" => {
                        "content" => "NotionRubyMapping開発記録(21)",
                        "link" => nil,
                      },
                      "plain_text" => "NotionRubyMapping開発記録(21)",
                      "href" => nil,
                    },
                  ],
                  "url" => "https://twitter.com/hkob/status/1507972453095833601",
                },
              },
            ],
          }
        ],
        equation: [
          id, 200,
          {
            "children" => [
              {
                "type" => "equation",
                "object" => "block",
                "equation" => {
                  "expression" => "x = \\frac{-b\\pm\\sqrt{b^2-4ac}}{2a}",
                },
              },
            ],
          }
        ],
        file: [
          id, 200,
          {
            "children" => [
              {
                "type" => "file",
                "object" => "block",
                "file" => {
                  "type" => "external",
                  "external" => {
                    "url" => "https://img.icons8.com/ios-filled/250/000000/mac-os.png",
                  },
                  "caption" => [
                    {
                      "type" => "text",
                      "text" => {
                        "content" => "macOS icon",
                        "link" => nil,
                      },
                      "plain_text" => "macOS icon",
                      "href" => nil,
                    },
                  ],
                },
              },
            ],
          }
        ],
        heading_1: [
          id, 200,
          {
            "children" => [
              {
                "type" => "heading_1",
                "object" => "block",
                "heading_1" => {
                  "rich_text" => [
                    {
                      "type" => "text",
                      "text" => {
                        "content" => "Heading 1",
                        "link" => nil,
                      },
                      "plain_text" => "Heading 1",
                      "href" => nil,
                    },
                  ],
                  "color" => "orange_background",
                },
              },
            ],
          }
        ],
        heading_2: [
          id, 200,
          {
            "children" => [
              {
                "type" => "heading_2",
                "object" => "block",
                "heading_2" => {
                  "rich_text" => [
                    {
                      "type" => "text",
                      "text" => {
                        "content" => "Heading 2",
                        "link" => nil,
                      },
                      "plain_text" => "Heading 2",
                      "href" => nil,
                    },
                  ],
                  "color" => "blue_background",
                },
              },
            ],
          }
        ],
        heading_3: [
          id, 200,
          {
            "children" => [
              {
                "type" => "heading_3",
                "object" => "block",
                "heading_3" => {
                  "rich_text" => [
                    {
                      "type" => "text",
                      "text" => {
                        "content" => "Heading 3",
                        "link" => nil,
                      },
                      "plain_text" => "Heading 3",
                      "href" => nil,
                    },
                  ],
                  "color" => "gray_background",
                },
              },
            ],
          }
        ],
        image: [
          id, 200,
          {
            "children" => [
              {
                "type" => "image",
                "object" => "block",
                "image" => {
                  "type" => "external",
                  "external" => {
                    "url" => "https://cdn.worldvectorlogo.com/logos/notion-logo-1.svg",
                  },
                  "caption" => [
                    {
                      "type" => "text",
                      "text" => {
                        "content" => "Notion logo",
                        "link" => nil,
                      },
                      "plain_text" => "Notion logo",
                      "href" => nil,
                    },
                  ],
                },
              },
            ],
          }
        ],
        link_to_page_page: [
          id, 200,
          {
            "children" => [
              {
                "type" => "link_to_page",
                "object" => "block",
                "link_to_page" => {
                  "type" => "page_id",
                  "page_id" => "c01166c613ae45cbb96818b4ef2f5a77",
                },
              },
            ],
          }
        ],
        link_to_page_database: [
          id, 200,
          {
            "children" => [
              {
                "type" => "link_to_page",
                "object" => "block",
                "link_to_page" => {
                  "type" => "database_id",
                  "database_id" => "c7697137d49f49c2bbcdd6a665c4f921",
                },
              },
            ],
          }
        ],
        numbered_list_item: [
          id, 200,
          {
            "children" => [
              {
                "type" => "numbered_list_item",
                "object" => "block",
                "numbered_list_item" => {
                  "rich_text" => [
                    {
                      "type" => "text",
                      "text" => {
                        "content" => "Numbered list item",
                        "link" => nil,
                      },
                      "plain_text" => "Numbered list item",
                      "href" => nil,
                    },
                  ],
                  "color" => "red",
                  "children" => [
                    {
                      "type" => "paragraph",
                      "object" => "block",
                      "paragraph" => {
                        "rich_text" => [
                          {
                            "type" => "text",
                            "text" => {
                              "content" => "with children",
                              "link" => nil,
                            },
                            "plain_text" => "with children",
                            "href" => nil,
                          },
                        ],
                        "color" => "default",
                      },
                    },
                  ],
                },
              },
            ],
          }
        ],
        paragraph: [
          id, 200,
          {
            "children" => [
              {
                "type" => "paragraph",
                "object" => "block",
                "paragraph" => {
                  "rich_text" => [
                    {
                      "type" => "text",
                      "text" => {
                        "content" => "A sample paragraph",
                        "link" => nil,
                      },
                      "plain_text" => "A sample paragraph",
                      "href" => nil,
                    },
                  ],
                  "color" => "yellow_background",
                  "children" => [
                    {
                      "type" => "paragraph",
                      "object" => "block",
                      "paragraph" => {
                        "rich_text" => [
                          {
                            "type" => "text",
                            "text" => {
                              "content" => "with children",
                              "link" => nil,
                            },
                            "plain_text" => "with children",
                            "href" => nil,
                          },
                        ],
                        "color" => "default",
                      },
                    },
                  ],
                },
              },
            ],
          }
        ],
        pdf: [
          id, 200,
          {
            "children" => [
              {
                "type" => "pdf",
                "object" => "block",
                "pdf" => {
                  "type" => "external",
                  "external" => {
                    "url" => "https://github.com/onocom/sample-files-for-demo-use/raw/151dd797d54d7e0ae0dc50e8e19d7965b387e202/sample-pdf.pdf",
                  },
                  "caption" => [],
                },
              },
            ],
          }
        ],
        quote: [
          id, 200,
          {
            "children" => [
              {
                "type" => "quote",
                "object" => "block",
                "quote" => {
                  "rich_text" => [
                    {
                      "type" => "text",
                      "text" => {
                        "content" => "A sample quote",
                        "link" => nil,
                      },
                      "plain_text" => "A sample quote",
                      "href" => nil,
                    },
                  ],
                  "color" => "purple",
                  "children" => [
                    {
                      "type" => "paragraph",
                      "object" => "block",
                      "paragraph" => {
                        "rich_text" => [
                          {
                            "type" => "text",
                            "text" => {
                              "content" => "with children",
                              "link" => nil,
                            },
                            "plain_text" => "with children",
                            "href" => nil,
                          },
                        ],
                        "color" => "default",
                      },
                    },
                  ],
                },
              },
            ],
          }
        ],
        synced_block_original: [
          id, 200,
          {
            "children" => [
              {
                "type" => "synced_block",
                "object" => "block",
                "synced_block" => {
                  "synced_from" => nil,
                  "children" => [
                    {
                      "type" => "bulleted_list_item",
                      "object" => "block",
                      "bulleted_list_item" => {
                        "rich_text" => [
                          {
                            "type" => "text",
                            "text" => {
                              "content" => "Synced block",
                              "link" => nil,
                            },
                            "plain_text" => "Synced block",
                            "href" => nil,
                          },
                        ],
                        "color" => "default",
                      },
                    },
                    {
                      "type" => "divider",
                      "object" => "block",
                      "divider" => {},
                    },
                  ],
                },
              },
            ],
          }
        ],
        synced_block_copy: [
          id, 200,
          {
            "children" => [
              {
                "type" => "synced_block",
                "object" => "block",
                "synced_block" => {
                  "synced_from" => {
                    "type" => "block_id",
                    "block_id" => "4815032e6f2443e4bc8c9bdc6299b090",
                  },
                },
              },
            ],
          }
        ],
        table_of_contents: [
          id, 200,
          {
            "children" => [
              {
                "type" => "table_of_contents",
                "object" => "block",
                "table_of_contents" => {
                  "color" => "pink",
                },
              },
            ],
          }
        ],
        template: [
          id, 200,
          {
            "children" => [
              {
                "type" => "template",
                "object" => "block",
                "template" => {
                  "rich_text" => [
                    {
                      "type" => "text",
                      "text" => {
                        "content" => "A sample template",
                        "link" => nil,
                      },
                      "plain_text" => "A sample template",
                      "href" => nil,
                    },
                  ],
                  "children" => [
                    {
                      "type" => "paragraph",
                      "object" => "block",
                      "paragraph" => {
                        "rich_text" => [
                          {
                            "type" => "text",
                            "text" => {
                              "content" => "with children",
                              "link" => nil,
                            },
                            "plain_text" => "with children",
                            "href" => nil,
                          },
                        ],
                        "color" => "default",
                      },
                    },
                  ],
                },
              },
            ],
          }
        ],
        to_do: [
          id, 200,
          {
            "children" => [
              {
                "type" => "to_do",
                "object" => "block",
                "to_do" => {
                  "rich_text" => [
                    {
                      "type" => "text",
                      "text" => {
                        "content" => "A sample To-Do",
                        "link" => nil,
                      },
                      "plain_text" => "A sample To-Do",
                      "href" => nil,
                    },
                  ],
                  "color" => "brown_background",
                  "children" => [
                    {
                      "type" => "paragraph",
                      "object" => "block",
                      "paragraph" => {
                        "rich_text" => [
                          {
                            "type" => "text",
                            "text" => {
                              "content" => "with children",
                              "link" => nil,
                            },
                            "plain_text" => "with children",
                            "href" => nil,
                          },
                        ],
                        "color" => "default",
                      },
                    },
                  ],
                  "checked" => false,
                },
              },
            ],
          }
        ],
        toggle: [
          id, 200,
          {
            "children" => [
              {
                "type" => "toggle",
                "object" => "block",
                "toggle" => {
                  "rich_text" => [
                    {
                      "type" => "text",
                      "text" => {
                        "content" => "A sample toggle",
                        "link" => nil,
                      },
                      "plain_text" => "A sample toggle",
                      "href" => nil,
                    },
                  ],
                  "color" => "yellow_background",
                  "children" => [
                    {
                      "type" => "paragraph",
                      "object" => "block",
                      "paragraph" => {
                        "rich_text" => [
                          {
                            "type" => "text",
                            "text" => {
                              "content" => "with children",
                              "link" => nil,
                            },
                            "plain_text" => "with children",
                            "href" => nil,
                          },
                        ],
                        "color" => "default",
                      },
                    },
                  ],
                },
              },
            ],
          }
        ],
        toggle_heading_1: [
          id, 200,
          {
            "children" => [
              {
                "type" => "heading_1",
                "object" => "block",
                "heading_1" => {
                  "rich_text" => [
                    {
                      "type" => "text",
                      "text" => {
                        "content" => "Toggle Heading 1",
                        "link" => nil,
                      },
                      "plain_text" => "Toggle Heading 1",
                      "href" => nil,
                    },
                  ],
                  "color" => "orange_background",
                  "children" => [
                    {
                      "type" => "bulleted_list_item",
                      "object" => "block",
                      "bulleted_list_item" => {
                        "rich_text" => [
                          {
                            "type" => "text",
                            "text" => {
                              "content" => "inside Toggle Heading 1",
                              "link" => nil,
                            },
                            "plain_text" => "inside Toggle Heading 1",
                            "href" => nil,
                          },
                        ],
                        "color" => "default",
                      },
                    },
                  ],
                },
              },
            ],
          }
        ],
        toggle_heading_2: [
          id, 200,
          {
            "children" => [
              {
                "type" => "heading_2",
                "object" => "block",
                "heading_2" => {
                  "rich_text" => [
                    {
                      "type" => "text",
                      "text" => {
                        "content" => "Toggle Heading 2",
                        "link" => nil,
                      },
                      "plain_text" => "Toggle Heading 2",
                      "href" => nil,
                    },
                  ],
                  "color" => "blue_background",
                  "children" => [
                    {
                      "type" => "bulleted_list_item",
                      "object" => "block",
                      "bulleted_list_item" => {
                        "rich_text" => [
                          {
                            "type" => "text",
                            "text" => {
                              "content" => "inside Toggle Heading 2",
                              "link" => nil,
                            },
                            "plain_text" => "inside Toggle Heading 2",
                            "href" => nil,
                          },
                        ],
                        "color" => "default",
                      },
                    },
                  ],
                },
              },
            ],
          }
        ],
        toggle_heading_3: [
          id, 200,
          {
            "children" => [
              {
                "type" => "heading_3",
                "object" => "block",
                "heading_3" => {
                  "rich_text" => [
                    {
                      "type" => "text",
                      "text" => {
                        "content" => "Toggle Heading 3",
                        "link" => nil,
                      },
                      "plain_text" => "Toggle Heading 3",
                      "href" => nil,
                    },
                  ],
                  "color" => "gray_background",
                  "children" => [
                    {
                      "type" => "bulleted_list_item",
                      "object" => "block",
                      "bulleted_list_item" => {
                        "rich_text" => [
                          {
                            "type" => "text",
                            "text" => {
                              "content" => "inside Toggle Heading 3",
                              "link" => nil,
                            },
                            "plain_text" => "inside Toggle Heading 3",
                            "href" => nil,
                          },
                        ],
                        "color" => "default",
                      },
                    },
                  ],
                },
              },
            ],
          }
        ],
        video: [
          id, 200,
          {
            "children" => [
              {
                "type" => "video",
                "object" => "block",
                "video" => {
                  "type" => "external",
                  "external" => {
                    "url" => "https://download.samplelib.com/mp4/sample-5s.mp4",
                  },
                  "caption" => [],
                },
              },
            ],
          }
        ],
        table: [
          id, 200,
          {
            "children" => [
              {
                "type" => "table",
                "object" => "block",
                "table" => {
                  "has_column_header" => true,
                  "has_row_header" => true,
                  "table_width" => 2,
                  "children" => [
                    {
                      "type" => "table_row",
                      "object" => "block",
                      "table_row" => {
                        "cells" => [
                          [
                            {
                              "type" => "text",
                              "text" => {
                                "content" => "Services",
                                "link" => nil,
                              },
                              "plain_text" => "Services",
                              "href" => nil,
                            },
                          ],
                          [
                            {
                              "type" => "text",
                              "text" => {
                                "content" => "Account",
                                "link" => nil,
                              },
                              "plain_text" => "Account",
                              "href" => nil,
                            },
                          ],
                        ],
                      },
                    },
                    {
                      "type" => "table_row",
                      "object" => "block",
                      "table_row" => {
                        "cells" => [
                          [
                            {
                              "type" => "text",
                              "text" => {
                                "content" => "Twitter",
                                "link" => nil,
                              },
                              "plain_text" => "Twitter",
                              "href" => nil,
                            },
                          ],
                          [
                            {
                              "type" => "text",
                              "text" => {
                                "content" => "hkob\n",
                                "link" => nil,
                              },
                              "plain_text" => "hkob\n",
                              "href" => nil,
                            },
                            {
                              "type" => "text",
                              "text" => {
                                "content" => "profile",
                                "link" => {
                                  "url" => "https://twitter.com/hkob/",
                                },
                              },
                              "plain_text" => "profile",
                              "href" => "https://twitter.com/hkob/",
                            },
                          ],
                        ],
                      },
                    },
                    {
                      "type" => "table_row",
                      "object" => "block",
                      "table_row" => {
                        "cells" => [
                          [
                            {
                              "type" => "text",
                              "text" => {
                                "content" => "GitHub",
                                "link" => nil,
                              },
                              "plain_text" => "GitHub",
                              "href" => nil,
                            },
                          ],
                          [
                            {
                              "type" => "text",
                              "text" => {
                                "content" => "hkob\n",
                                "link" => nil,
                              },
                              "plain_text" => "hkob\n",
                              "href" => nil,
                            },
                            {
                              "type" => "text",
                              "text" => {
                                "content" => "repositories",
                                "link" => {
                                  "url" => "https://github.com/hkob/",
                                },
                              },
                              "plain_text" => "repositories",
                              "href" => "https://github.com/hkob/",
                            },
                          ],
                        ],
                      },
                    },
                  ],
                },
              },
            ],
          }
        ],
      }
    end

    def append_block_children_page
      generate_stubs_sub :patch, __method__, :append_block_children_page_path,
                         append_block_children_hash(BLOCK_CREATE_TEST_PAGE_ID)
    end

    def append_block_children_block
      generate_stubs_sub :patch, __method__, :append_block_children_block_path,
                         append_block_children_hash(BLOCK_CREATE_TEST_BLOCK_ID)
    end

    def destroy_block
      generate_stubs_sub :delete, __method__, :block_path, {
        by_id: [DESTROY_BLOCK_ID, 200],
      }
    end

    def update_block
      generate_stubs_sub :patch, __method__, :block_path, {
        bookmark_url: [
          UPDATE_BLOCK_ID_HASH[:bookmark], 200,
          {
            "bookmark" => {
              "url" => "https://www.apple.com/",
            },
          }
        ],
        bookmark_caption: [
          UPDATE_BLOCK_ID_HASH[:bookmark], 200,
          {
            "bookmark" => {
              "caption" => [
                {
                  "type" => "text",
                  "text" => {
                    "content" => "Apple",
                    "link" => nil,
                  },
                  "plain_text" => "Apple",
                  "href" => nil,
                },
              ],
            },
          }
        ],
        bulleted_list_item_rta: [
          UPDATE_BLOCK_ID_HASH[:bulleted_list_item], 200,
          {
            "bulleted_list_item" => {
              "rich_text" => [
                {
                  "type" => "text",
                  "text" => {
                    "content" => "new text",
                    "link" => nil,
                  },
                  "plain_text" => "new text",
                  "href" => nil,
                },
              ],
            },
          }
        ],
        bulleted_list_item_color: [
          UPDATE_BLOCK_ID_HASH[:bulleted_list_item], 200,
          {
            "bulleted_list_item" => {
              "color" => "orange_background",
              "rich_text" => [
                {
                  "type" => "text",
                  "text" => {
                    "content" => "old text",
                    "link" => nil,
                  },
                  "plain_text" => "old text",
                  "href" => nil,
                },
              ],
            },
          }
        ],
        callout_color: [
          UPDATE_BLOCK_ID_HASH[:callout], 200,
          {
            "callout" => {
              "color" => "orange_background",
            },
          }
        ],
        callout_rta: [
          UPDATE_BLOCK_ID_HASH[:callout], 200,
          {
            "callout" => {
              "rich_text" => [
                {
                  "type" => "text",
                  "text" => {
                    "content" => "new text",
                    "link" => nil,
                  },
                  "plain_text" => "new text",
                  "href" => nil,
                },
              ],
            },
          }
        ],
        callout_file_url: [
          UPDATE_BLOCK_ID_HASH[:callout], 200,
          {
            "callout" => {
              "icon" => {
                "type" => "external",
                "external" => {
                  "url" => "https://img.icons8.com/ios-filled/250/000000/mac-os.png",
                },
              },
            },
          }
        ],
        callout_emoji: [
          UPDATE_BLOCK_ID_HASH[:callout], 200,
          {
            "callout" => {
              "icon" => {
                "type" => "emoji",
                "emoji" => "💡",
              },
            },
          }
        ],
        code_language: [
          UPDATE_BLOCK_ID_HASH[:code], 200,
          {
            "code" => {
              "language" => "ruby",
            },
          }
        ],
        code_caption: [
          UPDATE_BLOCK_ID_HASH[:code], 200,
          {
            "code" => {
              "caption" => [
                {
                  "type" => "text",
                  "text" => {
                    "content" => "set an array",
                    "link" => nil,
                  },
                  "plain_text" => "set an array",
                  "href" => nil,
                },
              ],
            },
          }
        ],
        code_rta: [
          UPDATE_BLOCK_ID_HASH[:code], 200,
          {
            "code" => {
              "rich_text" => [
                {
                  "type" => "text",
                  "text" => {
                    "content" => "array = %w[ABC DEF]",
                    "link" => nil,
                  },
                  "plain_text" => "array = %w[ABC DEF]",
                  "href" => nil,
                },
              ],
            },
          }
        ],
        embed_caption: [
          UPDATE_BLOCK_ID_HASH[:embed], 200,
          {
            "embed" => {
              "caption" => [
                {
                  "type" => "text",
                  "text" => {
                    "content" => "NotionRubyMapping v0.4.0",
                    "link" => nil,
                  },
                  "plain_text" => "NotionRubyMapping v0.4.0",
                  "href" => nil,
                },
              ],
            },
          }
        ],
        embed_url: [
          UPDATE_BLOCK_ID_HASH[:embed], 200,
          {
            "embed" => {
              "url" => "https://twitter.com/hkob/status/1525470656447811586",
            },
          }
        ],
        equation_expression: [
          UPDATE_BLOCK_ID_HASH[:equation], 200,
          {
            "equation" => {
              "expression" => "X(z) = \\sum_{n=-\\infty}^{\\infty}x[n]z^{-n}",
            },
          }
        ],
        file_url: [
          UPDATE_BLOCK_ID_HASH[:file], 200,
          {
            "file" => {
              "external" => {
                "url" => "https://cdn.worldvectorlogo.com/logos/notion-logo-1.svg",
              },
            },
          }
        ],
        file_caption: [
          UPDATE_BLOCK_ID_HASH[:file], 200,
          {
            "file" => {
              "caption" => [
                {
                  "type" => "text",
                  "text" => {
                    "content" => "Notion logo",
                    "link" => nil,
                  },
                  "plain_text" => "Notion logo",
                  "href" => nil,
                },
              ],
            },
          }
        ],
        heading1_color: [
          UPDATE_BLOCK_ID_HASH[:heading_1], 200,
          {
            "heading_1" => {
              "color" => "green_background",
              "rich_text" => [
                {
                  "type" => "text",
                  "text" => {
                    "content" => "Heading 1",
                    "link" => nil,
                  },
                  "plain_text" => "Heading 1",
                  "href" => nil,
                },
              ],
            },
          }
        ],
        heading1_rta: [
          UPDATE_BLOCK_ID_HASH[:heading_1], 200,
          {
            "heading_1" => {
              "rich_text" => [
                {
                  "type" => "text",
                  "text" => {
                    "content" => "New Heading 1",
                    "link" => nil,
                  },
                  "plain_text" => "New Heading 1",
                  "href" => nil,
                },
              ],
            },
          }
        ],
        heading2_color: [
          UPDATE_BLOCK_ID_HASH[:heading_2], 200,
          {
            "heading_2" => {
              "color" => "green_background",
              "rich_text" => [
                {
                  "type" => "text",
                  "text" => {
                    "content" => "Heading 2",
                    "link" => nil,
                  },
                  "plain_text" => "Heading 2",
                  "href" => nil,
                },
              ],
            },
          }
        ],
        heading2_rta: [
          UPDATE_BLOCK_ID_HASH[:heading_2], 200,
          {
            "heading_2" => {
              "rich_text" => [
                {
                  "type" => "text",
                  "text" => {
                    "content" => "New Heading 2",
                    "link" => nil,
                  },
                  "plain_text" => "New Heading 2",
                  "href" => nil,
                },
              ],
            },
          }
        ],
        heading3_color: [
          UPDATE_BLOCK_ID_HASH[:heading_3], 200,
          {
            "heading_3" => {
              "color" => "green_background",
              "rich_text" => [
                {
                  "type" => "text",
                  "text" => {
                    "content" => "Heading 3",
                    "link" => nil,
                  },
                  "plain_text" => "Heading 3",
                  "href" => nil,
                },
              ],
            },
          }
        ],
        heading3_rta: [
          UPDATE_BLOCK_ID_HASH[:heading_3], 200,
          {
            "heading_3" => {
              "rich_text" => [
                {
                  "type" => "text",
                  "text" => {
                    "content" => "New Heading 3",
                    "link" => nil,
                  },
                  "plain_text" => "New Heading 3",
                  "href" => nil,
                },
              ],
            },
          }
        ],
        image_url: [
          UPDATE_BLOCK_ID_HASH[:image], 200,
          {
            "image" => {
              "external" => {
                "url" => "https://cdn.worldvectorlogo.com/logos/notion-logo-1.svg",
              },
            },
          }
        ],
        image_caption: [
          UPDATE_BLOCK_ID_HASH[:image], 200,
          {
            "image" => {
              "caption" => [
                {
                  "type" => "text",
                  "text" => {
                    "content" => "macOS logo",
                    "link" => nil,
                  },
                  "plain_text" => "macOS logo",
                  "href" => nil,
                },
              ],
            },
          }
        ],
        numbered_list_item_color: [
          UPDATE_BLOCK_ID_HASH[:numbered_list_item], 200,
          {
            "numbered_list_item" => {
              "color" => "orange_background",
              "rich_text" => [
                {
                  "type" => "text",
                  "text" => {
                    "content" => "old text",
                    "link" => nil,
                  },
                  "plain_text" => "old text",
                  "href" => nil,
                },
              ],
            },
          }
        ],
        numbered_list_item_rta: [
          UPDATE_BLOCK_ID_HASH[:numbered_list_item], 200,
          {
            "numbered_list_item" => {
              "rich_text" => [
                {
                  "type" => "text",
                  "text" => {
                    "content" => "new text",
                    "link" => nil,
                  },
                  "plain_text" => "new text",
                  "href" => nil,
                },
              ],
            },
          }
        ],
        paragraph_color: [
          UPDATE_BLOCK_ID_HASH[:paragraph], 200,
          {
            "paragraph" => {
              "color" => "orange_background",
              "rich_text" => [
                {
                  "type" => "text",
                  "text" => {
                    "content" => "old paragraph text",
                    "link" => nil,
                  },
                  "plain_text" => "old paragraph text",
                  "href" => nil,
                },
              ],
            },
          }
        ],
        paragraph_rta: [
          UPDATE_BLOCK_ID_HASH[:paragraph], 200,
          {
            "paragraph" => {
              "rich_text" => [
                {
                  "type" => "text",
                  "text" => {
                    "content" => "new paragraph text",
                    "link" => nil,
                  },
                  "plain_text" => "new paragraph text",
                  "href" => nil,
                },
              ],
            },
          }
        ],
        pdf_caption: [
          UPDATE_BLOCK_ID_HASH[:pdf], 200,
          {
            "pdf" => {
              "caption" => [
                {
                  "type" => "text",
                  "text" => {
                    "content" => "new caption",
                    "link" => nil,
                  },
                  "plain_text" => "new caption",
                  "href" => nil,
                },
              ],
            },
          }
        ],
        pdf_url: [
          UPDATE_BLOCK_ID_HASH[:pdf], 200,
          {
            "pdf" => {
              "external" => {
                "url" => "https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf",
              },
            },
          }
        ],
        quote_color: [
          UPDATE_BLOCK_ID_HASH[:quote], 200,
          {
            "quote" => {
              "color" => "orange_background",
              "rich_text" => [
                {
                  "type" => "text",
                  "text" => {
                    "content" => "old text",
                    "link" => nil,
                  },
                  "plain_text" => "old text",
                  "href" => nil,
                },
              ],
            },
          }
        ],
        quote_rta: [
          UPDATE_BLOCK_ID_HASH[:quote], 200,
          {
            "quote" => {
              "rich_text" => [
                {
                  "type" => "text",
                  "text" => {
                    "content" => "new text",
                    "link" => nil,
                  },
                  "plain_text" => "new text",
                  "href" => nil,
                },
              ],
            },
          }
        ],
        table_of_contents_color: [
          UPDATE_BLOCK_ID_HASH[:table_of_contents], 200,
          {
            "table_of_contents" => {
              "color" => "orange_background",
            },
          }
        ],
        template_rta: [
          UPDATE_BLOCK_ID_HASH[:template], 200,
          {
            "template" => {
              "rich_text" => [
                {
                  "type" => "text",
                  "text" => {
                    "content" => "New template",
                    "link" => nil,
                  },
                  "plain_text" => "New template",
                  "href" => nil,
                },
              ],
            },
          }
        ],
        to_do_checked: [
          UPDATE_BLOCK_ID_HASH[:to_do], 200,
          {
            "to_do" => {
              "checked" => true,
            },
          }
        ],
        to_do_color: [
          UPDATE_BLOCK_ID_HASH[:to_do], 200,
          {
            "to_do" => {
              "color" => "orange_background",
              "rich_text" => [
                {
                  "type" => "text",
                  "text" => {
                    "content" => "old To Do",
                    "link" => nil,
                  },
                  "plain_text" => "old To Do",
                  "href" => nil,
                },
              ],
            },
          }
        ],
        to_do_rta: [
          UPDATE_BLOCK_ID_HASH[:to_do], 200,
          {
            "to_do" => {
              "rich_text" => [
                {
                  "type" => "text",
                  "text" => {
                    "content" => "new To Do",
                    "link" => nil,
                  },
                  "plain_text" => "new To Do",
                  "href" => nil,
                },
              ],
            },
          }
        ],
        toggle_color: [
          UPDATE_BLOCK_ID_HASH[:toggle], 200,
          {
            "toggle" => {
              "color" => "orange_background",
              "rich_text" => [
                {
                  "type" => "text",
                  "text" => {
                    "content" => "Old Toggle",
                    "link" => nil,
                  },
                  "plain_text" => "Old Toggle",
                  "href" => nil,
                },
              ],
            },
          }
        ],
        toggle_rta: [
          UPDATE_BLOCK_ID_HASH[:toggle], 200,
          {
            "toggle" => {
              "rich_text" => [
                {
                  "type" => "text",
                  "text" => {
                    "content" => "New Toggle",
                    "link" => nil,
                  },
                  "plain_text" => "New Toggle",
                  "href" => nil,
                },
              ],
            },
          }
        ],
        toggle_heading1_color: [
          UPDATE_BLOCK_ID_HASH[:toggle_heading_1], 200,
          {
            "heading_1" => {
              "color" => "green_background",
              "rich_text" => [
                {
                  "type" => "text",
                  "text" => {
                    "content" => "Toggle Heading 1",
                    "link" => nil,
                  },
                  "plain_text" => "Toggle Heading 1",
                  "href" => nil,
                },
              ],
            },
          }
        ],
        toggle_heading1_rta: [
          UPDATE_BLOCK_ID_HASH[:toggle_heading_1], 200,
          {
            "heading_1" => {
              "rich_text" => [
                {
                  "type" => "text",
                  "text" => {
                    "content" => "New Heading 1",
                    "link" => nil,
                  },
                  "plain_text" => "New Heading 1",
                  "href" => nil,
                },
              ],
            },
          }
        ],
        toggle_heading2_color: [
          UPDATE_BLOCK_ID_HASH[:toggle_heading_2], 200,
          {
            "heading_2" => {
              "color" => "green_background",
              "rich_text" => [
                {
                  "type" => "text",
                  "text" => {
                    "content" => "Toggle Heading 2",
                    "link" => nil,
                  },
                  "plain_text" => "Toggle Heading 2",
                  "href" => nil,
                },
              ],
            },
          }
        ],
        toggle_heading2_rta: [
          UPDATE_BLOCK_ID_HASH[:toggle_heading_2], 200,
          {
            "heading_2" => {
              "rich_text" => [
                {
                  "type" => "text",
                  "text" => {
                    "content" => "New Heading 2",
                    "link" => nil,
                  },
                  "plain_text" => "New Heading 2",
                  "href" => nil,
                },
              ],
            },
          }
        ],
        toggle_heading3_color: [
          UPDATE_BLOCK_ID_HASH[:toggle_heading_3], 200,
          {
            "heading_3" => {
              "color" => "green_background",
              "rich_text" => [
                {
                  "type" => "text",
                  "text" => {
                    "content" => "Toggle Heading 3",
                    "link" => nil,
                  },
                  "plain_text" => "Toggle Heading 3",
                  "href" => nil,
                },
              ],
            },
          }
        ],
        toggle_heading3_rta: [
          UPDATE_BLOCK_ID_HASH[:toggle_heading_3], 200,
          {
            "heading_3" => {
              "rich_text" => [
                {
                  "type" => "text",
                  "text" => {
                    "content" => "New Heading 3",
                    "link" => nil,
                  },
                  "plain_text" => "New Heading 3",
                  "href" => nil,
                },
              ],
            },
          }
        ],
        video_caption: [
          UPDATE_BLOCK_ID_HASH[:video], 200,
          {
            "video" => {
              "caption" => [
                {
                  "type" => "text",
                  "text" => {
                    "content" => "New caption",
                    "link" => nil,
                  },
                  "plain_text" => "New caption",
                  "href" => nil,
                },
              ],
            },
          }
        ],
        video_url: [
          UPDATE_BLOCK_ID_HASH[:video], 200,
          {
            "video" => {
              "external" => {
                "url" => "https://www.learningcontainer.com/wp-content/uploads/2020/05/sample-mp4-file.mp4",
              },
            },
          }
        ],
      }
    end

    # @param [Symbol, String] json_file (without path and extension)
    # @return [Hash] Hash object created from json
    def read_json(json_file)
      File.open("spec/fixtures/#{json_file}.json") { |f| JSON.parse f.read }
    end

    ### read ids from env.yml
    def notion_token
      @config["notion_token"]
    end

    ### TextObject examples
    def to_text
      @to_text ||= TextObject.new "plain_text"
    end

    def to_href
      @to_href ||= TextObject.new "href_text", "href" => "https://www.google.com/"
    end
  end
end

module RSpec
  include NotionRubyMapping

  shared_examples_for :dry_run do |method, path_method, id: nil, use_id: false, json: nil, json_method: nil, use_query: false|
    it do
      json ||= if json_method
                 target.send(json_method)
               elsif use_query && method != :get
                 query.query_json
               end
      path = if use_id
               @tc.nc.send(path_method, target.id)
             elsif id
               @tc.nc.send(path_method, id)
             else
               @tc.nc.send(path_method)
             end
      path += query.query_string if use_query && method == :get
      shell = [
        "#!/bin/sh\ncurl #{method == :get ? "" : "-X #{method.to_s.upcase}"} 'https://api.notion.com/#{path}'",
        "  -H 'Notion-Version: 2022-02-22'",
        "  -H 'Authorization: Bearer '\"$NOTION_API_KEY\"''",
      ]
      shell << "  -H 'Content-Type: application/json'" if %i[post patch].include?(method)
      shell << "  --data '#{JSON.generate json}'" if json
      expect(dry_run).to eq shell.join(" \\\n")
    end
  end

  shared_examples_for :raw_json do |key, json|
    it do
      expect(target.send(key)).to eq json
    end
  end

  shared_examples_for :property_values_json do |json|
    it do
      expect(target.property_values_json).to eq json
    end
  end

  shared_examples_for :update_property_schema_json do |json|
    it do
      expect(target.update_property_schema_json).to eq json
    end
  end

  shared_examples_for :property_schema_json do |json|
    it do
      expect(target.property_schema_json).to eq json
    end
  end

  shared_examples_for :assert_different_property do |method, args = nil|
    it method do
      proc = -> { args.nil? ? target.send(method) : target.send(method, *args) }
      expect { proc.call }.to raise_error(StandardError)
    end
  end

  shared_examples_for :has_name_as do |name|
    it "has name as #{name}" do
      expect(target.name).to eq name
    end
  end

  shared_examples_for :will_update do
    it "will update" do
      expect(target.will_update).to be_truthy
    end
  end

  shared_examples_for :will_not_update do
    it "will not update" do
      expect(target.will_update).to be_falsey
    end
  end

  shared_examples_for :filter_test do |c, keys, value: nil, value_str: nil, rollup: nil, rollup_type: nil|
    let(:property) { c.new "property_name" }
    value_str ||= value
    describe "a #{c.name} property" do
      it "has name" do
        expect(property.name).to eq "property_name"
      end

      context "create filter" do
        subject { query.filter }
        keys.each do |key|
          context key do
            let(:query) { property.send(*["filter_#{key}", value, rollup, rollup_type].compact) }
            if rollup
              it {
                is_expected.to eq({"property" => "property_name",
                                   rollup => {rollup_type => {key => value_str || true}}})
              }
            else
              it { is_expected.to eq({"property" => "property_name", c::TYPE => {key => value_str || true}}) }
            end
          end
        end
      end
    end
  end

  shared_examples_for :date_equal_filter_test do |c, keys, date, rollup: nil, rollup_type: nil|
    let(:property) { c.new "property_name" }
    start_str, end_str = DateProperty.start_end_time date
    describe "a #{c.name} property" do
      it "has name" do
        expect(property.name).to eq "property_name"
      end

      context "create filter" do
        subject { query.filter }
        keys.each do |key|
          context key do
            let(:query) { property.send(*["filter_#{key}", date].compact) }
            it {
              answer = if key == "equals"
                         if rollup
                           property.filter_after(start_str, rollup: rollup, rollup_type: rollup_type)
                                   .and(filter_before(end_str, rollup: rollup, rollup_type: rollup_type))
                         else
                           property.filter_after(start_str).and(property.filter_before(end_str))
                         end
                       else
                         if rollup
                           property.filter_before(start_str, rollup: rollup, rollup_type: rollup_type)
                                   .or(property.filter_after(end_str, rollup: rollup, rollup_type: rollup_type))
                         else
                           property.filter_before(start_str).or(property.filter_after(end_str))
                         end
                       end
              is_expected.to eq answer.filter
            }
          end
        end
      end
    end
  end

  shared_examples_for :timestamp_filter_test do |c, keys, value: nil, value_str: nil|
    let(:property) { c.new "__timestamp__" }
    value_str ||= value
    describe "a #{c.name} property" do
      it "has name" do
        expect(property.name).to eq "__timestamp__"
      end

      context "create filter" do
        subject { query.filter }
        keys.each do |key|
          context key do
            let(:query) { property.send(*["filter_#{key}", value].compact) }
            it { is_expected.to eq({"timestamp" => c::TYPE, c::TYPE => {key => value_str || true}}) }
          end
        end
      end
    end
  end

  shared_examples_for :date_equal_timestamp_filter_test do |c, keys, date|
    let(:property) { c.new "__timestamp__" }
    start_str, end_str = DateProperty.start_end_time date
    describe "a #{c.name} property" do
      it "has name" do
        expect(property.name).to eq "__timestamp__"
      end

      context "create filter" do
        subject { query.filter }
        keys.each do |key|
          context key do
            let(:query) { property.send(*["filter_#{key}", date].compact) }
            it {
              if key == "equals"
                is_expected.to eq property.filter_after(start_str).and(property.filter_before(end_str)).filter
              else
                is_expected.to eq property.filter_before(start_str).or(property.filter_after(end_str)).filter
              end
            }
          end
        end
      end
    end
  end

  shared_examples_for :retrieve_block do |klass, id, have_children, json|
    describe "#{klass} block" do
      let(:target) { klass.find id }

      it "receive id" do
        expect(target.id).to eq id
      end

      it_behaves_like :raw_json, :block_json, json

      it "can #{klass} have children?" do
        expect(target.can_have_children).to eq have_children
      end
    end
  end

  shared_examples_for :create_child_block do |klass, block_page_id, block_block_id|
    describe "create child block" do
      page_id = NotionRubyMapping::TestConnection::BLOCK_CREATE_TEST_PAGE_ID
      block_id = NotionRubyMapping::TestConnection::BLOCK_CREATE_TEST_BLOCK_ID
      let(:org_page) { Page.new id: page_id }
      let(:org_block) { CalloutBlock.new "ABC", id: block_id, emoji: "💡" }
      %i[page block].each do |pb|
        is_page = pb == :page
        ans_block_id = is_page ? block_page_id : block_block_id
        context "for #{pb}" do
          context "dry_run" do
            let(:dry_run) { (is_page ? org_page : org_block).append_block_children target, dry_run: true }
            it_behaves_like :dry_run, :patch, :append_block_children_page_path,
                            id: (is_page ? page_id : block_id), json_method: :children_block_json
            # When the corresponding json files are not exist, create a retrieve script for obtaining json files.
            unless ans_block_id
              it "write shell script" do
                File.open "spec/fixtures/append_block_children_#{pb}_#{klass}.sh", "w" do |f|
                  f.print dry_run
                end
                expect(true).to be_falsey
              end
            end
          end
          if ans_block_id
            context "create" do
              let(:block) { (is_page ? org_page : org_block).append_block_children target }
              it { expect(block.id).to eq ans_block_id }
            end
          end
        end
      end
    end
  end

  shared_examples_for :update_block_url do |type, url|
    before { target.url = url }
    it { expect(target.update_block_json).to eq({type => {"url" => url}}) }
    context "dry_run" do
      let(:dry_run) { target.save dry_run: true }
      it_behaves_like :dry_run, :patch, :block_path, use_id: true, json_method: :update_block_json
    end

    context "save" do
      it { expect(target.save.url).to eq url }
    end
  end

  shared_examples_for :update_block_caption do |type, new_caption|
    before { target.caption.rich_text_objects = new_caption }
    let(:json) do
      {
        type => {
          "caption" => [
            {
              "type" => "text",
              "text" => {
                "content" => new_caption,
                "link" => nil,
              },
              "plain_text" => new_caption,
              "href" => nil,
            },
          ],
        },
      }
    end
    it { expect(target.update_block_json).to eq json }

    context "dry_run" do
      let(:dry_run) { target.save dry_run: true }
      it_behaves_like :dry_run, :patch, :block_path, use_id: true, json_method: :update_block_json
    end

    context "save" do
      it { expect(target.save.caption.full_text).to eq new_caption }
    end
  end

  shared_examples_for :update_block_rich_text_array do |type, new_text|
    before { target.rich_text_array.rich_text_objects = new_text }
    let(:json) do
      {
        type => {
          "rich_text" => [
            {
              "type" => "text",
              "text" => {
                "content" => new_text,
                "link" => nil,
              },
              "plain_text" => new_text,
              "href" => nil,
            },
          ],
        },
      }
    end
    it { expect(target.update_block_json).to eq json }

    context "dry_run" do
      let(:dry_run) { target.save dry_run: true }
      it_behaves_like :dry_run, :patch, :block_path, use_id: true, json_method: :update_block_json
    end

    context "save" do
      it { expect(target.save.rich_text_array.full_text).to eq new_text }
    end
  end

  shared_examples_for :update_block_color do |type, new_color, with_rta = false|
    before { target.color = new_color }
    let(:json) do
      if with_rta
        {type => {"color" => new_color}.merge(target.rich_text_array.update_property_schema_json(true))}
      else
        {type => {"color" => new_color}}
      end
    end
    it { expect(target.update_block_json).to eq json }
    context "dry_run" do
      let(:dry_run) { target.save dry_run: true }
      it_behaves_like :dry_run, :patch, :block_path, use_id: true, json_method: :update_block_json
    end

    context "save" do
      it { expect(target.save.color).to eq new_color }
    end
  end

  shared_examples_for :update_block_file do |type, new_url, json = nil|
    before { target.url = new_url }
    json ||= {
      type => {
        "external" => {
          "url" => new_url,
        },
      },
    }
    it { expect(target.update_block_json).to eq json }
    context "dry_run" do
      let(:dry_run) { target.save dry_run: true }
      it_behaves_like :dry_run, :patch, :block_path, use_id: true, json_method: :update_block_json
    end

    context "save" do
      it { expect(target.save.url).to eq new_url }
    end
  end
end
