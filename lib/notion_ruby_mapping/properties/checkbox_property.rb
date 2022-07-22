# frozen_string_literal: true

module NotionRubyMapping
  # Checkbox property
  class CheckboxProperty < Property
    include EqualsDoesNotEqual
    TYPE = "checkbox"

    ### Public announced methods

    ## Common methods

    # @return [Boolean, Hash]
    # @see https://www.notion.so/hkob/CheckboxProperty-ac1edbdb8e264af5ad1432b522b429fd#20da1bf0cbcc4d4eb22d9125386522c2
    def checkbox
      @json
    end

    ## Page property only methods

    # @param [Boolean] flag
    # @return [TrueClass, FalseClass] settled value
    # @see https://www.notion.so/hkob/CheckboxProperty-ac1edbdb8e264af5ad1432b522b429fd#f167c85c1d2d40dfb8b3b6ce582e0f15
    def checkbox=(flag)
      assert_page_property __method__
      @will_update = true
      @json = flag
    end

    ### Not public announced methods

    ## Common methods

    # @param [String] name Property name
    # @param [Boolean, Hash] json
    def initialize(name, will_update: false, base_type: :page, property_cache: nil, json: nil)
      super name, will_update: will_update, base_type: base_type, property_cache: property_cache
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
