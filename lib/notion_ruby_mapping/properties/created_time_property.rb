# frozen_string_literal: true

module NotionRubyMapping
  # CreatedTimeProperty
  class CreatedTimeProperty < DateBaseProperty
    TYPE = "created_time"

    ### Public announced methods

    ## Common methods

    # @return [Date, Hash]
    # @see https://www.notion.so/hkob/CreatedTimeProperty-bb979ff02dc04efa9733da1003efa871#f1e80400878346c3a9ba8e32b824ed2b
    def created_time
      @json
    end

    ### Not public announced methods

    ## Common methods

    # @param [String] name Property name
    # @param [String] json created_time value (optional)
    def initialize(name, will_update: false, base_type: :page, json: nil)
      super name, will_update: will_update, base_type: base_type
      @json = json
      @json ||= {} if database?
    end
  end
end
