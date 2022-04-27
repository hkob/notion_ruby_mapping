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
    end

    # @param [Symbol] method
    # @param [Symbol, nil] prefix
    # @param [Symbol] path_method
    # @param [Hash<Array>] array
    def generate_stubs_sub(method, prefix, path_method, array)
      array.each do |key, (id, code, payload)|
        path = id ? @nc.send(path_method, *id) : @nc.send(path_method)
        stub method, "#{prefix}_#{key}", path, code, payload
      end
    end

    def retrieve_page
      generate_stubs_sub :get, __method__, :page_path, {
        top: [top_page_id, 200],
        wrong_format: ["AAA", 400],
        unpermitted_page: [unpermitted_page_id, 404],
        db_first: [db_first_page_id, 200],
        block_test_page: [block_test_page_id, 200],
      }
    end

    def retrieve_database
      generate_stubs_sub :get, __method__, :database_path, {
        database: [database_id, 200],
        wrong_format: ["AAA", 400],
        unpermitted_database: [unpermitted_database_id, 404],
        created: [created_database_id, 200],
        parent: [parent_database_id, 200],
      }
    end

    def retrieve_block
      generate_stubs_sub :get, __method__, :block_path, {
        h1block: [h1block, 200],
        wrong_format: ["AAA", 400],
        unpermitted_block: [unpermitted_block_id, 404],
      }
    end

    def query_database
      generate_stubs_sub :post, __method__, :query_database_path, {
        limit2: [database_id, 200, {"page_size" => 2}],
        next2: [database_id, 200, {"start_cursor" => "6601e719-a39a-460c-908e-8909467fcccf", "page_size" => 2}],
        last2: [database_id, 200, {"start_cursor" => "dcdc805c-85fa-4155-a55c-20fc28771af7", "page_size" => 2}],
      }
    end

    def update_page
      generate_stubs_sub :patch, __method__, :page_path, {
        set_icon_emoji: [top_page_id, 200, {
          "icon" => {
            "type" => "emoji",
            "emoji" => "😀",
          },
        }],
        set_link_icon: [top_page_id, 200, {
          "icon" => {
            "type" => "external",
            "external" => {
              "url" => "https://cdn.profile-image.st-hatena.com/users/hkob/profile.png",
            },
          },
        }],
        all: [db_update_page_id, 200, {
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
                  "name" => "https://img.icons8.com/ios-filled/250/000000/mac-os.png",
                  "type" => "external",
                  "external" => {
                    "url" => "https://img.icons8.com/ios-filled/250/000000/mac-os.png",
                  },
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
        created: [created_database_id, 200, {
          "properties": {
            "Select": {
              "select": {
                "options":[
                  {"id": "56a526e1-0cec-4b85-b9db-fc68d00e50c6", "name": "S1", "color": "yellow"},
                  {"id": "6ead7aee-d7f0-40ba-aa5e-59bccf6c50c8", "name": "S2", "color": "default"},
                  {"name": "S3","color": "red"}
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
                "options":[
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
                "link": nil
              },
              "plain_text": "New database title",
              "href": nil,
              "annotations": {
                "bold":false,
                "italic":false,
                "strikethrough":false,
                "underline":false,
                "code":false,
                "color": "default",
              },
            },
            {
              "type": "text",
              "text": {
                "content": "(Added)",
                "link": nil
              },
              "plain_text": "(Added)",
              "href": nil
            },
          ],
          "icon": {
            "type": "emoji",
            "emoji": "🎉",
          }
        }],
        add_property: [created_database_id, 200, {
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
        rename_properties: [created_database_id, 200, {
          "properties" => {
            "added number property" => {"name" => "renamed number property"},
            "added url property" => {"name" => "renamed url property"},
          },
        }],
        remove_properties: [created_database_id, 200, {
          "properties" => {
            "renamed number property" => nil,
            "renamed url property" => nil,
          },
        }]
      }
    end

    def retrieve_block_children
      generate_stubs_sub :get, __method__, :block_children_page_path, {
        block_test_page: [[block_test_page_id, "?page_size=100"], 200],
      }

      "https://api.notion.com/v1/blocks/67cf059ce74646a0b72d481c9ff5d386/children?page_size=100"
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

    def top_page_id
      @config["top_page"]
    end

    def unpermitted_page_id
      @config["unpermitted_page"]
    end

    def db_first_page_id
      @config["db_first_page"]
    end

    def db_update_page_id
      @config["db_update_page"]
    end

    def database_id
      @config["database"]
    end

    def unpermitted_database_id
      @config["unpermitted_database"]
    end

    def created_database_id
      @config["created_database"]
    end

    def h1block
      @config["h1block"]
    end

    def unpermitted_block_id
      @config["unpermitted_block"]
    end

    def parent1_page_id
      @config["parent1_page"]
    end

    def parent_database_id
      @config["parent_database"]
    end

    def user_hkob
      @config["user_hkob"]
    end

    def block_test_page_id
      @config["block_test_page"]
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
      shell << "  -H 'Content-Type: application/json'" unless path == :get
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
