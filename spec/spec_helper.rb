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
      bookmark: "aa1c25bc-b172-4a36-898d-3ce5e1f572b7",
      breadcrumb: "6d2ed6f3-8f74-4e83-8766-747b6d7995f6",
      bulleted_list_item: "8a0d35c5-145e-41fd-89ac-e46deb85d24f",
      callout: "715a6550-c737-444f-ac99-4be7822c88d3",
      child_database: "ea525a78-4669-470d-b425-8c4d7cb95667",
      child_page: "0f3e5073-22d8-48eb-926b-e808df84c169",
      code: "c9a46c89-109b-486a-8105-6ca82f4f6515",
      column: "29a966bb-81eb-43e5-aae1-b44992525775",
      column_list: "93195eab-21f7-4419-bf44-0e4c07092573",
      divider: "e34f7164-4535-48fd-9c49-1d320f77bda2",
      embed_twitter: "e4c0811c-7154-4fed-9e8c-02d885c898ef",
      equation: "6a1f76eb-337e-4169-a77b-cb8b1d79a88e",
      file: "0da49a8b-963e-42e6-a9ee-0deb765d5b40",
      heading_1: "0a58761e-f3b4-429f-b86e-0ad9ff815fe1",
      heading_2: "d34096c9-62ba-4633-9294-db488ca7b8cc",
      heading_3: "fef62d73-8d83-4791-b2da-681816f56389",
      image_external: "ae7be035-7ad1-418a-bb8e-f0f2d039220c",
      image_file: "293ace37-42f5-45a6-b8ff-1352f4b3e7c6",
      inline_contents: "2515e2f2-a53f-40c3-a2ea-1b5d47afee09",
      link_preview_dropbox: "7b391df0-1dc5-430e-aae0-1bc0392cdcb5",
      link_to_page: "b921ff3c-b13c-43c2-b53a-d9d1ba19b8c1",
      numbered_list_item: "1860edbc-410d-408b-87f6-1e37e07352a2",
      paragraph: "79ddb5ed-15c7-4a40-9cf6-a018d23ceb19",
      pdf: "878fd86e-be37-482f-b637-d09fb63eaee8",
      quote: "8eba490b-cc83-4384-9cb0-9a739a4be91c",
      synced_block_copy: "ea7b5183-eea2-4d30-b019-010921e93b2c",
      synced_block_original: "4815032e-6f24-43e4-bc8c-9bdc6299b090",
      table: "ba612e8b-c858-4569-9822-ccca7ab4c709",
      table_of_contents: "0de608aa-c31b-4c5c-a84a-ae48d8ea05b8",
      table_row: "57fc378c-9db1-4fef-8d74-72c1b2084df1",
      template: "12fe0347-f8c4-4da0-ace9-9c8992b5827f",
      to_do: "676129de-8eac-42c9-9449-c15893775cae",
      toggle: "005923da-b39f-4af6-bbd1-1be98150d2b2",
      toggle_heading_1: "82daa282-435d-4f9f-8f3b-b8c0328a963f",
      toggle_heading_2: "e5f16356-8adc-49c5-9f17-228589d071ac",
      toggle_heading_3: "115fb937-ab6d-4a2e-9079-921b03e50756",
      video: "bed3abe0-2009-4aa9-9056-4844f981b07a",
    }.freeze
    BLOCK_CREATE_TEST_BLOCK_ID = "82314687163e41baaf300a8a2bec57c2"
    DESTROY_BLOCK_ID = "7306e4c4bc5b48d78948e59ec0059afd"
    # user_id
    USER_HKOB_ID = "2200a911-6a96-44bb-bd38-6bfb1e01b9f6"

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
    end

    # @param [Symbol] method
    # @param [Symbol, nil] prefix
    # @param [Symbol] path_method
    # @param [Hash<Array>] array
    def generate_stubs_sub(method, prefix, path_method, hash)
      hash.each do |key, (id, code, payload)|
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
      hash = BLOCK_ID_HASH.map { |k, id| [k, [id, 200]] }.to_h
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
                  "id" => "2200a911-6a96-44bb-bd38-6bfb1e01b9f6",
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
                  {"name": "S3","color": "red"},
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
                },
              },
            ],
          },
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
                    "block_id" => "4815032e-6f24-43e4-bc8c-9bdc6299b090",
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
                  "checked" => false,
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
                            }
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
                            }
                          ]
                        ]
                      }
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
                            }
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
                                  "url" => "https://twitter.com/hkob/"
                                }
                              },
                              "plain_text" => "profile",
                              "href" => "https://twitter.com/hkob/"
                            }
                          ]
                        ]
                      }
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
                            }
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
                                  "url" => "https://github.com/hkob/"
                                }
                              },
                              "plain_text" => "repositories",
                              "href" => "https://github.com/hkob/"
                            }
                          ]
                        ]
                      }
                    }
                  ]
                }
              }
            ]
          }
        ]
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

    # @param [Symbol, String] json_file (without path and extension)
    # @return [Hash] Hash object created from json
    def read_json(json_file)
      File.open("spec/fixtures/#{json_file}.json") { |f| JSON.load f }
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
  shared_examples_for :dry_run do |method, path_method, id: nil, use_id: false, json: nil, json_method: nil, use_query: false|
    it do
      json ||= if json_method
                 target.send(json_method)
               elsif use_query && method != :get
                 query.query_json
               else
                 nil
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
end
