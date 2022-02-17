# frozen_string_literal: true

module NotionRubyMapping
  # Select property
  class FilesProperty < Property
    include IsEmptyIsNotEmpty
    TYPE = "files"
  end
end
