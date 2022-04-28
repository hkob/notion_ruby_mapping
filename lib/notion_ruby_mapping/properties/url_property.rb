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
    def url
      @json
    end

    ## Page property only methods

    def url=(url)
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
