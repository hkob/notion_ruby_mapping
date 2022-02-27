# frozen_string_literal: true

module NotionRubyMapping
  # Select property
  class FilesProperty < Property
    include IsEmptyIsNotEmpty
    TYPE = "files"

    # @param [String] name Property name
    # @param [String] files files value (optional)
    def initialize(name, will_update: false, json: nil, files: [])
      super name, will_update: will_update
      @files = json || Array(files).map { |url| url_to_hash url } || []
    end
    attr_reader :files

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

    # @param [Hash] json
    def update_from_json(json)
      @will_update = false
      @files = json["files"]
    end

    # @return [Hash]
    def property_values_json
      if @files.map { |f| f["type"] }.include? "file"
        {}
      else
        {@name => {"files" => @files, "type" => "files"}}
      end
    end

    def files=(files = [])
      @will_update = true
      @files = Array(files).map { |url| url_to_hash url } || []
    end
  end
end
