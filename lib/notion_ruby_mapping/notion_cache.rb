# frozen_string_literal: true

require "singleton"
require "faraday"
require "faraday_middleware"

module NotionRubyMapping
  # singleton class of caching Notion objects
  class NotionCache
    include Singleton

    ### initialize

    def initialize
      @object_hash = {}
      @client = Faraday::Connection.new "https://api.notion.com" do |builder|
        builder.use FaradayMiddleware::EncodeJson
        builder.use FaradayMiddleware::ParseJson
        builder.adapter Faraday.default_adapter
      end
      @notion_token = nil
      @wait = 0
      @debug = false
    end
    attr_reader :object_hash
    attr_writer :client # for test only

    # @param [String] notion_token
    # @return [NotionRubyMapping::NotionCache] self (NotionCache.instance)
    def create_client(notion_token, wait: 0.3333, debug: false)
      @notion_token = notion_token
      @wait = wait
      @debug = debug
      self
    end

    ### create path methods

    # @param [String] database_id
    # @return [String (frozen)] page_path
    def database_path(database_id)
      "v1/databases/#{database_id}"
    end

    # @param [String] database_id
    # @return [String (frozen)] page_path
    def databases_path
      "v1/databases"
    end

    # @param [String] page_id
    # @return [String (frozen)] page_path
    def page_path(page_id)
      "v1/pages/#{page_id}"
    end

    # @return [String (frozen)] page_path
    def pages_path
      "v1/pages"
    end

    # @param [String] block_id
    # @return [String (frozen)] page_path
    def block_path(block_id)
      "v1/blocks/#{block_id}"
    end

    # @param [String] database_id
    # @return [String (frozen)] page_path
    def query_database_path(database_id)
      "v1/databases/#{database_id}/query"
    end

    ### Notion API call

    # @param [Symbol] method
    # @param [String] path
    # @param [Hash] options
    # @return [Hash] response hash
    def request(method, path, options = {})
      raise "Please call `NotionCache.create_client' before using other methods" unless @notion_token

      sleep @wait
      response = @client.send(method) do |request|
        request.headers["Authorization"] = "Bearer #{@notion_token}"
        request.headers["Notion-Version"] = NotionRubyMapping::NOTION_VERSION
        case method
        when :get, :delete
          request.url path, options
        when :post, :put, :patch
          request.headers["Content-Type"] = "application/json"
          request.path = path
          request.body = options.to_json unless options.empty?
        else
          raise StandardError, "Unknown method: #{method}"
        end
        request.options.merge!(options.delete(:request)) if options.key? :request
      end
      p response.body if @debug
      response.body
    end

    # @param [String] page_id
    # @return [Hash] response
    def page_request(page_id)
      request :get, page_path(page_id)
    end

    # @param [String] database_id
    # @return [Hash] response
    def database_request(database_id)
      request :get, database_path(database_id)
    end

    def database_query_request(database_id, payload)
      request :post, "v1/databases/#{database_id}/query", payload
    end

    # @param [String] block_id
    # @return [Hash] response
    def block_request(block_id)
      request :get, block_path(block_id)
    end

    # @param [String] database_id
    # @return [Hash] response
    def update_database_request(database_id, payload)
      request :patch, "v1/databases/#{database_id}", payload
    end

    # @param [String] page_id
    # @param [Hash] payload
    # @return [Hash] response
    def update_page_request(page_id, payload)
      request :patch, "v1/pages/#{page_id}", payload
    end

    # @param [Hash] payload
    # @return [Hash] response
    def create_page_request(payload)
      request :post, "v1/pages", payload
    end

    def create_database_request(payload)
      request :post, databases_path, payload
    end

    # @param [String] id id string with "-"
    # @return [String] id without "-"
    def hex_id(id)
      id&.gsub "-", ""
    end

    # @param [String] id id (with or without "-")
    # @return [NotionRubyMapping::Base]
    def object_for_key(id)
      key = hex_id(id)
      return @object_hash[key] if @object_hash.key? key

      json = yield(@client)
      @object_hash[key] = Base.create_from_json json
    end

    # @param [String] id page_id (with or without "-")
    # @return [NotionRubyMapping::Base] Page object or nil
    def page(id)
      object_for_key(id) { page_request id }
    end

    # @param [String] id database_id (with or without "-")
    # @return [NotionRubyMapping::Base] Database object or nil
    def database(id)
      object_for_key(id) { database_request id }
    end

    # @param [String] id block_id (with or without "-")
    # @return [NotionRubyMapping::Base] Block object or nil
    def block(id)
      object_for_key(id) { block_request id }
    end

    # @param [String] id page_id / block_id (with or without "-")
    # @return [NotionRubyMapping::Base] List object
    def block_children(id)
      array = []
      sleep @wait
      @client.block_children(block_id: id, sleep_interval: @wait, max_retries: 20) do |page|
        array.concat page.results
      end
      Base.create_from_json({"object" => "list", "results" => array})
    end

    # @param [String] id page_id / block_id (with or without "-")
    # @param [NotionRubyMapping::Query] query query object
    # @return [NotionRubyMapping::Base] List object
    def database_query(id, query)
      Base.create_from_json database_query_request(id, query.query_json)
    end

    # @param [String] id page_id (with or without "-")
    # @param [Hash] payload
    def update_database(id, payload)
      sleep @wait
      @client.update_database payload.merge({database_id: id})
    end

    # @return [Hash]
    def clear_object_hash
      @object_hash = {}
    end
  end
end
