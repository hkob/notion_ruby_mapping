# frozen_string_literal: true

module NotionRubyMapping
  # Notion List object
  class List < Base
    include Enumerable

    def each
      return enum_for(:each) unless block_given?

      json["results"].each do |block_json|
        yield Base.create_from_json(block_json)
      end
    end
  end
end
