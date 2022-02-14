# frozen_string_literal: true

require "singleton"
require "notion"

module NotionRubyMapping
  # singleton class of caching Notion objects
  class NotionCache
    include Singleton

    def initialize
      @object_hash = {}
      @client = nil
      @wait = 0
    end
    attr_reader :object_hash, :client
    attr_accessor :use_cache

    # @param [String] notion_token
    # @return [NotionRubyMapping::NotionCache] self (NotionCache.instance)
    def create_client(notion_token, wait = 0.3333)
      @client ||= Notion::Client.new token: notion_token
      @wait = wait
      self
    end

    # @param [String] id id string with "-"
    # @return [String] id without "-"
    def hex_id(id)
      id&.gsub "-", ""
    end

    # @param [String] id id (with or without "-")
    # @return [NotionRubyMapping::Block, NotionRubyMapping::List, NotionRubyMapping::Database, NotionRubyMapping::Page, nil]
    def object_for_key(id)
      key = hex_id(id)
      return @object_hash[key] if @object_hash.key? key

      begin
        json = yield(@client)
        p json
        @object_hash[key] = Base.create_from_json json
      rescue StandardError
        nil
      end
    end

    # @param [String] id page_id (with or without "-")
    # @return [NotionRubyMapping::Page, nil] Page object or nil
    def page(id)
      object_for_key(id) do
        sleep @wait
        @client.page page_id: id
      end
    end

    # @param [String] id database_id (with or without "-")
    # @return [NotionRubyMapping::Database, nil] Database object or nil
    def database(id)
      object_for_key(id) do
        sleep @wait
        @client.database database_id: id
      end
    end

    # @param [String] id block_id (with or without "-")
    # @return [NotionRubyMapping::Block, nil] Block object or nil
    def block(id)
      object_for_key(id) do
        sleep @wait
        @client.block block_id: id
      end
    end

    # @param [String] id page_id / block_id (with or without "-")
    # @return [NotionRubyMapping::List] List object
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
    # @return [NotionRubyMapping::List] List object
    def database_query(id, query)
      array = []
      parameters = {database_id: id, sleep_interval: @wait, max_retries: 20}
      parameters[:filter] = query.filter unless query.filter.empty?
      parameters[:sort] = query.sort unless query.sort.empty?
      @client.database_query(**parameters) do |page|
        array.concat page.results
      end
      Base.create_from_json({"object" => "list", "results" => array})
    end

    # @param [String] id page_id (with or without "-")
    # @param [Hash] payload
    def update_page(id, payload)
      sleep @wait
      @client.update_page payload.merge({page_id: id})
    end

    # @param [String] id page_id (with or without "-")
    # @param [Hash] payload
    def update_database(id, payload)
      sleep @wait
      @client.update_database payload.merge({database_id: id})
    end
  end
end
