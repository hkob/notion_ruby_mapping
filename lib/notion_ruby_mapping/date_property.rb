# frozen_string_literal: true

module NotionRubyMapping
  # DateProperty
  class DateProperty < DateBaseProperty
    TYPE = "date"

    ### Public announced methods

    ## Common methods

    # @return [Hash]
    def date
      @json
    end

    ## Page property only methods

    # @return [Date, Time, DateTime, String]
    def end_date
      @json["end"]
    end

    # @param [Date, Time, DateTime, String] edt
    def end_date=(edt)
      @will_update = true
      sdt = start_date
      edt = nil if sdt.class != edt.class || sdt > edt
      @json["end"] = edt
    end

    # @return [Date, Time, DateTime, String]
    def start_date
      @json["start"]
    end

    # @param [Date, Time, DateTime, String] sdt
    def start_date=(sdt)
      @will_update = true
      edt = end_date
      @json["end"] = nil if sdt.class != edt.class || sdt > edt
      @json["start"] = sdt
    end

    # @return [String]
    def time_zone
      @json["time_zone"]
    end

    # @param [String] tzone
    def time_zone=(tzone)
      @will_update = true
      @json["time_zone"] = tzone
    end

    ### Not public announced methods

    ## Common methods

    # @param [String] name
    # @param [Hash] json
    # @param [Date, Time, DateTime, String, nil] start_date
    # @param [Date, Time, DateTime, String, nil] end_date
    # @param [String, nil] time_zone
    def initialize(name, will_update: false, base_type: :page, json: nil, start_date: nil, end_date: nil, time_zone: nil)
      super name, will_update: will_update, base_type: base_type
      @json = json || {}
      return if database?

      @json = json || {}
      @json["start"] = start_date if start_date
      @json["end"] = end_date if end_date
      @json["time_zone"] = time_zone if time_zone
    end

    ## Page property only methods

    # @return [Hash] created json
    def property_values_json
      assert_page_property __method__
      {
        @name => {
          "type" => "date",
          "date" => {
            "start" => value_str(@json["start"]),
            "end" => value_str(@json["end"]),
            "time_zone" => @json["time_zone"],
          },
        },
      }
    end
  end
end
