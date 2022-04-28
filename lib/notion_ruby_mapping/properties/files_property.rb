# frozen_string_literal: true

module NotionRubyMapping
  # Select property
  class FilesProperty < Property
    include IsEmptyIsNotEmpty
    TYPE = "files"

    ### Public announced methods

    ## Common methods

    # @return [Hash]
    def files
      @json
    end

    ## Page property only methods

    def files=(files = [])
      @will_update = true
      @json = Array(files).map { |url| url_to_hash url }
    end

    ### Not public announced methods

    ## Common methods

    # @param [String] name Property name
    # @param [String] files files value (optional)
    def initialize(name, will_update: false, base_type: :page, json: nil, files: [])
      super name, will_update: will_update, base_type: base_type
      if database?
        @json = json || {}
      else
        @json = json || []
        @json = Array(files).map { |url| url_to_hash url } unless files.empty?
      end
    end

    # @return [Hash]
    def property_values_json
      assert_page_property __method__
      if @json.map { |f| f["type"] }.include? "file"
        {}
      else
        {@name => {"files" => @json, "type" => "files"}}
      end
    end

    protected

    # @param [String] url
    # @return [Hash]
    def url_to_hash(url)
      {
        "name" => url,
        "type" => "external",
        "external" => {
          "url" => url,
        },
      }
    end
  end
end
