# frozen_string_literal: true

module NotionRubyMapping
  # Notion page object
  class Page < Base
    def self.find(id)
      NotionCache.instance.page id
    end

    # @return [NotionRubyMapping::Base]46G
    def update
      update_json @nc.update_page_request(@id, property_values_json)
    end

    # @return [NotionRubyMapping::Base]
    def create
      @new_record = false
      update_json @nc.create_page_request(property_values_json)
    end

    protected

    # @return [Hash]
    def reload_json
      @nc.page_request @id
    end
  end
end
