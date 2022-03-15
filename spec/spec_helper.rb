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
    @tc.clear_object_hash
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
    end

    # @param [Symbol] method
    # @param [Symbol, nil] prefix
    # @param [Symbol] path_method
    # @param [Hash<Array>] array
    def generate_stubs_sub(method, prefix, path_method, array)
      array.each do |key, (id, code, payload)|
        path = id ? @nc.send(path_method, id) : @nc.send(path_method)
        stub method, "#{prefix}_#{key}", path, code, payload
      end
    end

    def retrieve_page
      generate_stubs_sub :get, __method__, :page_path, {
        top: [top_page_id, 200],
        wrong_format: ["AAA", 400],
        unpermitted_page: [unpermitted_page_id, 404],
        db_first: [db_first_page_id, 200],
      }
    end

    def retrieve_database
      generate_stubs_sub :get, __method__, :database_path, {
        database: [database_id, 200],
        wrong_format: ["AAA", 400],
        unpermitted_database: [unpermitted_database_id, 404],
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
          "parent" => {
            "database_id" => "1d6b1040a9fb48d99a3d041429816e9f"
          },
          "properties" => {
            "Name" => {
              "type" => "title",
              "title" => [
                {
                  "type" => "text",
                  "text" => {
                    "content" => "New Page Title",
                    "link" => nil
                  },
                  "plain_text" => "New Page Title",
                  "href" => nil
                }
              ]
            }
          }
        }]
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
  shared_examples_for :property_values_json do |json|
    it do
      expect(target.property_values_json).to eq json
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
end
