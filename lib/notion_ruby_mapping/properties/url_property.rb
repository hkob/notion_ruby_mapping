# frozen_string_literal: true

module NotionRubyMapping
  # UrlProperty
  class UrlProperty < Property
    include EqualsDoesNotEqual
    include ContainsDoesNotContain
    include StartsWithEndsWith
    include IsEmptyIsNotEmpty
    TYPE = "url"

    ### Public announced methods

    ## Common methods

    # @return [String, Hash, nil] url (Page), {} (Database)
    # @see https://www.notion.so/hkob/UrlProperty-8a0094fdf6494151983cb4694f6626cc#8342eef7df3c43eaad10c48d4757b4ae
    def url
      @json
    end

    ## Page property only methods


    # @param [String] url
    # @see https://www.notion.so/hkob/UrlProperty-8a0094fdf6494151983cb4694f6626cc#cfa5463a121b4002b250b38d7d0a0d34
    def url=(url)
      assert_page_property __method__
      @will_update = true
      @json = url
    end

    ### Not public announced methods

    ## Common methods

    # @param [String] name Property name
    # @param [String] url url value (optional)
    def initialize(name, will_update: false, base_type: :page, json: nil)
      super name, will_update: will_update, base_type: base_type
      @json = json || (database? ? {} : nil)
    end

    ## Page property only methods

    # @return [Hash]
    def property_values_json
      assert_page_property __method__
      {@name => {"url" => @json, "type" => "url"}}
    end
  end
end
