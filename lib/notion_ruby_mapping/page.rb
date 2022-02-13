# frozen_string_literal: true

module NotionRubyMapping
  # Notion page object
  class Page < Base
    def self.find(key)
      NotionCache.instance.page key
    end

    def set_icon(emoji: nil, url: nil)
      payload = emoji ? {type: :emoji, emoji: emoji} : {type: :external, external: {url: url}}
      update_json @nc.update_page(id, {icon: payload})
      self
    end
  end
end
