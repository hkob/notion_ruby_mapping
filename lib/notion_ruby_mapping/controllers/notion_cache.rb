# frozen_string_literal: true

require "singleton"
require "faraday"
require "faraday/multipart"
require "mime/types"

module NotionRubyMapping
  # singleton class of caching Notion objects
  class NotionCache
    include Singleton

    ### initialize

    # @see https://www.notion.so/hkob/NotionCache-65e1599864d6425686d495a5a4b3a623#dca210788f114cf59464090782c073bf
    def initialize
      @object_hash = {}
      @client = Faraday.new "https://api.notion.com" do |conn|
        conn.request :json
        conn.response :json
        conn.headers["Notion-Version"] = NotionRubyMapping::NOTION_VERSION
      end
      @notion_token = nil
      @wait = 0.3333
      @debug = false
      @use_cache = true
    end
    attr_reader :object_hash
    attr_writer :client # for test only
    attr_accessor :notion_token, :wait, :debug, :use_cache

    def multipart_client
      @multipart_client ||= Faraday.new "https://api.notion.com" do |conn|
        conn.request :multipart, flat_encode: true
        conn.response :json
        conn.headers["Notion-Version"] = NotionRubyMapping::NOTION_VERSION
      end
    end

    # @param [String] block_id
    # @return [String (frozen)] block_path
    def append_block_children_block_path(block_id)
      "v1/blocks/#{block_id}/children"
    end

    # @param [String] page_id
    # @return [String (frozen)] page_path
    def append_block_children_page_path(page_id)
      "v1/blocks/#{page_id}/children"
    end

    # @param [String] id
    # @param [Hash] payload
    # @return [Hash]
    def append_block_children_request(id, payload)
      request :patch, append_block_children_block_path(id), payload
    end

    def append_comment_request(json)
      request :post, comments_path, json
    end

    # @param [String] id block_id (with or without "-")
    # @return [NotionRubyMapping::Base] Block object or nil
    def block(id)
      object_for_key(id) { block_request id }
    end

    # @param [String] page_id
    # @return [String (frozen)] page_path
    def block_children_page_path(page_id, query_string = "")
      "v1/blocks/#{page_id}/children#{query_string}"
    end

    # @param [String] id
    # @param [String] query_string
    # @return [Hash]
    def block_children_request(id, query_string)
      request :get, block_children_page_path(id, query_string)
    end

    # @param [String] block_id
    # @return [String (frozen)] page_path
    def block_path(block_id)
      "v1/blocks/#{block_id}"
    end

    # @param [String] block_id
    # @return [Hash] response
    def block_request(block_id)
      request :get, block_path(block_id)
    end

    # @return [Hash]
    def clear_object_hash
      @object_hash = {}
    end

    # @return [String (frozen)]
    def comments_path
      "v1/comments"
    end

    def complete_a_file_upload_path(file_id)
      "v1/file_uploads/#{file_id}/complete"
    end

    def complete_a_file_upload_request(file_id)
      request :post, complete_a_file_upload_path(file_id)
    end

    # @param [String] notion_token
    # @return [NotionRubyMapping::NotionCache] self (NotionCache.instance)
    def create_client(notion_token, wait: 0.3333, debug: false)
      @notion_token = notion_token
      @wait = wait
      @debug = debug
      self
    end

    # @param [Hash] payload
    # @return [Hash] response
    def create_database_request(payload)
      request :post, databases_path, payload
    end

    # @param [Hash] payload
    # @return [Hash] response
    def create_file_upload_request(payload = {})
      request :post, file_uploads_path, payload
    end

    # @param [Hash] payload
    # @return [Hash] response
    def create_page_request(payload)
      request :post, "v1/pages", payload
    end

    # @param [String] id database_id (with or without "-")
    # @return [NotionRubyMapping::Base] Database object or nil
    def database(id)
      object_for_key(id) { database_request id }
    end

    # @param [String] database_id
    # @return [String (frozen)] page_path
    def database_path(database_id)
      "v1/databases/#{database_id}"
    end

    # @param [String] id page_id / block_id (with or without "-")
    # @param [NotionRubyMapping::Query] query query object
    # @return [NotionRubyMapping::Base] List object
    # def database_query(id, query)
    #   Base.create_from_json database_query_request(id, query.query_json)
    # end

    # @param [String] database_id (with or without "-")
    # @param [NotionRubyMapping::Query] query query object
    def database_query_request(database_id, query)
      request :post, "v1/databases/#{database_id}/query#{query.database_query_string}", query.query_json
    end

    # @param [String] database_id
    # @return [Hash] response
    def database_request(database_id)
      request :get, database_path(database_id)
    end

    # @return [String (frozen)] page_path
    def databases_path
      "v1/databases"
    end

    # @param [String] id
    # @return [NotionRubyMapping::Base]
    def destroy_block(id)
      Base.create_from_json destroy_block_request(id)
    end

    # @param [String] id
    # @return [Hash]
    def destroy_block_request(id)
      request :delete, block_path(id)
    end

    # @param [String] fname
    # @param [String] id
    # @param [Hash] options
    # @return [Hash]
    def file_upload_request(fname, id, options = {})
      multipart_request(file_upload_path(id), fname, options)
    end

    # @param [String] id
    # @return [String]
    def file_upload_path(id)
      "v1/file_uploads/#{id}/send"
    end

    # @return [String]
    def file_uploads_path
      "v1/file_uploads"
    end

    # @param [String] id id string with "-"
    # @return [String] id without "-"
    # @see https://www.notion.so/hkob/NotionCache-65e1599864d6425686d495a5a4b3a623#a2d70a2e019c4c17898aaa1a36580f1d
    def hex_id(id)
      id&.gsub "-", ""
    end

    def inspect
      "NotionCache"
    end

    # @param [String] path
    # @param [String] fname
    # @param [Hash] options
    # @return [Hash] response hash
    def multipart_request(path, fname, options = {})
      raise "Please call `NotionRubyMapping.configure' before using other methods" unless @notion_token

      content_type = MIME::Types.type_for(fname).first.to_s

      sleep @wait
      body = options.map { |k, v| [k, Faraday::Multipart::ParamPart.new(v, "text/plain")] }.to_h
      file_part = Faraday::Multipart::FilePart.new(fname, content_type, File.basename(fname))
      response = multipart_client.send(:post) do |request|
        request.headers["Authorization"] = "Bearer #{@notion_token}"
        request.headers["content-Type"] = "multipart/form-data"
        request.path = path
        request.body = {file: file_part}.merge body
      end
      p response.body if @debug
      response.body
    end

    # @param [String] id id (with or without "-")
    # @return [NotionRubyMapping::Base]
    def object_for_key(id)
      key = hex_id(id)
      return @object_hash[key] if @use_cache && @object_hash.key?(key)

      json = yield(@client)
      ans = Base.create_from_json json
      @object_hash[key] = ans if @use_cache
      ans
    end

    # @param [String] id page_id (with or without "-")
    # @return [NotionRubyMapping::Base] Page object or nil
    def page(id)
      object_for_key(id) { page_request id }
    end

    # @param [String] page_id
    # @return [String (frozen)] page_path
    def page_path(page_id)
      "v1/pages/#{page_id}"
    end

    # @param [String] page_id
    # @param [String] property_id
    # @return [String (frozen)] page_property_path
    def page_property_path(page_id, property_id)
      [page_path(page_id), "properties/#{property_id}"].join "/"
    end

    # @param [String] page_id
    # @param [String] property_id
    # @return [Hash] response
    def page_property_request(page_id, property_id, query = {})
      p "page_id = #{page_id}, property_id = #{property_id}, query = #{query}" if @debug
      request :get, page_property_path(page_id, property_id), query
    end

    # @param [String] page_id
    # @return [Hash] response
    def page_request(page_id)
      request :get, page_path(page_id)
    end

    # @return [String (frozen)] page_path
    def pages_path
      "v1/pages"
    end

    # @param [String] database_id
    # @return [String (frozen)] page_path
    def query_database_path(database_id)
      "v1/databases/#{database_id}/query"
    end

    # @param [String] block_id
    def retrieve_comments_path(block_id)
      "v1/comments?block_id=#{block_id}"
    end

    # @param [String] block_id
    # @param [NotionRubyMapping::Query, NilClass] query
    def retrieve_comments_request(block_id, query)
      request :get, retrieve_comments_path(block_id), (query&.query_json || {})
    end

    # @param [Symbol] method
    # @param [String] path
    # @param [Hash] options
    # @return [Hash] response hash
    def request(method, path, options = {})
      raise "Please call `NotionRubyMapping.configure' before using other methods" unless @notion_token

      sleep @wait
      response = @client.send(method) do |request|
        request.headers["Authorization"] = "Bearer #{@notion_token}"
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

    def search(query)
      request(:post, search_path, query)
    end

    def search_path
      "v1/search"
    end

    # @param [String] token
    def token=(token)
      @notion_token = token
    end

    def update_block_request(block_id, payload)
      request :patch, block_path(block_id), payload
    end

    # @param [String] id page_id (with or without "-")
    # @param [Hash] payload
    # def update_database(id, payload)
    #   sleep @wait
    #   @client.update_database payload.merge({database_id: id})
    # end

    # @param [String] database_id
    # @return [Hash] response
    def update_database_request(database_id, payload)
      request :patch, database_path(database_id), payload
    end

    # @param [String] page_id
    # @param [Hash] payload
    # @return [Hash] response
    def update_page_request(page_id, payload)
      request :patch, page_path(page_id), payload
    end

    # @param [String] id user_id (with or without "-")
    # @return [NotionRubyMapping::UserObject] UserObject object or nil
    def user(id)
      UserObject.new json: user_request(id)
    end

    # @param [String] user_id
    # @return [String (frozen)] user_path
    def user_path(user_id)
      "v1/users/#{user_id}"
    end

    # @param [String] user_id
    # @return [Hash] response
    def user_request(user_id)
      request :get, user_path(user_id)
    end

    # @return [Array<NotionRubyMapping::UserObject>] UserObject array
    def users
      List.new json: users_request, type: "user_object", value: true
    end

    # @return [String (frozen)] user_path
    def users_path(option = "")
      "v1/users#{option}"
    end

    # @param [String] user_id
    # @param [NotionRubyMapping::Query] query query object
    # @return [Hash] response
    def users_request(query = Query.new)
      request :get, users_path, query.query_json
    end
  end
end
