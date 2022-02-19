# frozen_string_literal: true

module NotionRubyMapping
  # Select property
  class SelectProperty < Property
    include EqualsDoesNotEqual
    include IsEmptyIsNotEmpty
    TYPE = "select"

    # @param [String] name Property name
    # @param [String] select String value (optional)
    def initialize(name, select: nil)
      super(name)
      @select = select
    end
    attr_reader :name

    def create_json
      {"select" => {"name" => @select}}
    end

    def select=(select)
      @will_update = true
      @select = select
    end
  end
end
