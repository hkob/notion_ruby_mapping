# frozen_string_literal: true

module NotionRubyMapping
  # DateProperty
  class DateProperty < DateBaseProperty
    TYPE = "date"

    # @param [String] name
    # @param [Hash] json
    # @param [Date, Time, DateTime, String, nil] start_date
    # @param [Date, Time, DateTime, String, nil] end_date
    # @param [String, nil] time_zone
    def initialize(name, will_update: false, json: nil, start_date: nil, end_date: nil, time_zone: nil)
      super name, will_update: will_update
      @start_date = start_date || json && json["start"]
      @end_date = end_date || json && json["end"]
      @time_zone = time_zone || json && json["time_zone"]
    end

    # @return [Hash] created json
    def property_values_json
      {
        @name => {
          "type" => "date",
          "date" => {
            "start" => value_str(@start_date),
            "end" => value_str(@end_date),
            "time_zone" => @time_zone,
          },
        },
      }
    end

    # @param [Date, Time, DateTime, String] start_date
    # @return [Date, Time, DateTime, String]
    def start_date=(start_date)
      @will_update = true
      @start_date = start_date
      @end_date = nil if @start_date.class != @end_date.class || @start_date > @end_date
      @start_date
    end

    # @param [Date, Time, DateTime, String] end_date
    # @return [Date, Time, DateTime, String]
    def end_date=(end_date)
      @will_update = true
      @end_date = end_date
      @end_date = nil if @start_date.class != @end_date.class || @start_date > @end_date
      @end_date
    end

    # @param [String] time_zone
    # @return [Array, nil] settled array
    def time_zone=(time_zone)
      @will_update = true
      @time_zone = time_zone
    end

    # @param [Hash] json
    def update_from_json(json)
      @will_update = false
      jd = json["date"]
      @start_date = jd["start"]
      @end_date = jd["end"]
      @time_zone = jd["time_zone"]
    end
  end
end
