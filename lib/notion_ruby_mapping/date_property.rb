# frozen_string_literal: true

module NotionRubyMapping
  class DateProperty < DateBaseProperty
    TYPE = "date"

    # @param [String] name
    # @param [Hash] json
    # @param [Array] multi_select
    def initialize(name, json: nil, start_date: nil, end_date: nil, time_zone: nil)
      super(name, json: json)
      @end_date = end_date
      @start_date = start_date || end_date
      @time_zone = time_zone
    end

    # @return [Hash] created json
    def create_json
      if @end_date
        {"date" => {"start" => value_str(@start_date || @end_date), "end" => value_str(@end_date)}}
      elsif @start_date
        {"date" => {"start" => value_str(@start_date)}}
      else
        {"date" => @json || {}}
      end
    end

    # @param [Hash] multi_select
    # @return [Array, nil] settled array
    def start_date=(start_date)
      @will_update = true
      @start_date = start_date
      @end_date = nil if @start_date.class != @end_date.class || @start_date > @end_date
    end

    # @param [Hash] multi_select
    # @return [Array, nil] settled array
    def end_date=(end_date)
      @will_update = true
      @end_date = end_date
      @end_date = nil if @start_date.class != @end_date.class || @start_date > @end_date
    end
  end
end
