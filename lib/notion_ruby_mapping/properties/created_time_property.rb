# frozen_string_literal: true

module NotionRubyMapping
  # CreatedTimeProperty
  class CreatedTimeProperty < DateBaseProperty
    TYPE = "created_time"

    ### Public announced methods

    ## Common methods

    # @return [Date, Hash]
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