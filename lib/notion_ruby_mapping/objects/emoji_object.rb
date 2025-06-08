# frozen_string_literal: true

module NotionRubyMapping
  # TextObject
  class EmojiObject
    # @param [String] emoji
    # @return [TextObject]
    def initialize(emoji: nil, json: {})
      @emoji = emoji || json && json[:emoji]
      @will_update = false
    end
    attr_reader :will_update, :emoji

    # @param [EmojiObject, String] uo
    # @return [EmojiObject] self or created EmojiObject
    # @see https://www.notion.so/hkob/EmojiObject-4a0d41a10a81490f82471059c5b39b1b#959b7d74c1a54e488b39a96ac8f634e5
    def self.emoji_object(emoji_or_eo)
      if emoji_or_eo.is_a? EmojiObject
        emoji_or_eo
      else
        EmojiObject.new emoji: emoji_or_eo
      end
    end

    # @param [String] emoji
    # @see https://www.notion.so/hkob/EmojiObject-4a0d41a10a81490f82471059c5b39b1b#b0520d80de084c1c99e8595db9d36542
    def emoji=(emoji)
      @emoji = emoji
      @will_update = true
    end

    # @return [Hash]
    def property_values_json
      {
        type: "emoji",
        emoji: @emoji,
      }
    end
  end
end
