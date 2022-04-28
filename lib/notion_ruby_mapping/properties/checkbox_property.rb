# frozen_string_literal: true

module NotionRubyMapping
  # Checkbox property
  class CheckboxProperty < Property
    include EqualsDoesNotEqual
    TYPE = "checkbox"

    ### Public announced methods

    ## Common methods

    # @return [Boolean, Hash]
    def checkbox
      @json
    end

    ## Page property only methods

    # @param [Boolean] flag
    # @return [TrueClass, FalseClass] settled value
    def checkbox=(flag)
      @will_update = true
      @json = flag
    end

    ### Not public announced methods

    ## Common methods

    # @param [String] name Property name
    # @param [Boolean, Hash] json
    def initialize(name, will_update: false, base_type: :page, json: nil)
      super name, will_update: will_update, base_type: base_type
      @json = if database?
                json || {}
              else
                json || false
              end
    end

    ## Page property only methods

    # @return [Hash]
    def property_values_json
      assert_page_property __method__
      {@name => {"checkbox" => @json, "type" => "checkbox"}}
    end
  end
end
