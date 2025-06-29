# frozen_string_literal: true

module NotionRubyMapping
  # Select property
  class FilesProperty < Property
    include IsEmptyIsNotEmpty
    TYPE = "files"

    attr_reader :files

    ### Public announced methods

    ## Page property only methods

    def files=(files = [])
      assert_page_property __method__
      @will_update = true
      @files = Array(files).map { |url| FileObject.file_object url }
      @file_names = Array(files)
    end

    def file_names=(file_names = [])
      array_file_names = Array(file_names)
      unless @files.length == array_file_names.length
        raise StandardError,
              "files and file_names must be the same sizes."
      end

      @will_update = true
      @file_names = array_file_names
    end

    ### Not public announced methods

    ## Common methods

    # @param [String, Symbol] name Property name
    # @param [String] files files value (optional)
    def initialize(name, will_update: false, base_type: "page", json: nil, files: [], property_id: nil,
                   property_cache: nil)
      super name, will_update: will_update, base_type: base_type, property_id: property_id,
                  property_cache: property_cache
      if database?
        @files = json || {}
      elsif json
        @files = json.map { |sub_json| FileObject.new json: sub_json }
        @file_names = json.map { |sub_json| sub_json["name"] }
      elsif !files.empty?
        @files = Array(files).map { |url| FileObject.file_object url }
        @file_names = Array(files)
      else
        @files = []
      end
    end

    # @return [Hash]
    def property_values_json
      assert_page_property __method__
      if @files.map(&:type).include? "file"
        {}
      else
        files = @files.map(&:property_values_json)
        @file_names&.each_with_index do |name, i|
          files[i]["name"] = name.is_a?(FileUploadObject) ? name.fname : name
        end
        {@name => {"files" => files, "type" => "files"}}
      end
    end

    def update_from_json(json)
      return if database?

      @files = json["files"].map { |sub_json| FileObject.new json: sub_json }
      @file_names = json["files"].map { |sub_json| sub_json["name"] }
      @will_update = false
      self
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
