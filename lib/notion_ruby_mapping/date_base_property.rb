# frozen_string_literal: true

require "date"

module NotionRubyMapping
  # Date base property (date, created_time, last_edited_time, formula)
  class DateBaseProperty < Property
    include IsEmptyIsNotEmpty

    def filter_equals(date, rollup = nil, rollup_type = nil)
      make_filter_query "equals", value_str(date), rollup, rollup_type
    end

    def filter_does_not_equal(date, rollup = nil, rollup_type = nil)
      make_filter_query "does_not_equal", value_str(date), rollup, rollup_type
    end

    def filter_before(date, rollup = nil, rollup_type = nil)
      make_filter_query "before", value_str(date), rollup, rollup_type
    end

    def filter_after(date, rollup = nil, rollup_type = nil)
      make_filter_query "after", value_str(date), rollup, rollup_type
    end

    def filter_on_or_before(date, rollup = nil, rollup_type = nil)
      make_filter_query "on_or_before", value_str(date), rollup, rollup_type
    end

    def filter_on_or_after(date, rollup = nil, rollup_type = nil)
      make_filter_query "on_or_after", value_str(date), rollup, rollup_type
    end

    def filter_past_week(rollup = nil, rollup_type = nil)
      make_filter_query "past_week", {}, rollup, rollup_type
    end

    def filter_past_month(rollup = nil, rollup_type = nil)
      make_filter_query "past_month", {}, rollup, rollup_type
    end

    def filter_past_year(rollup = nil, rollup_type = nil)
      make_filter_query "past_year", {}, rollup, rollup_type
    end

    def filter_next_week(rollup = nil, rollup_type = nil)
      make_filter_query "next_week", {}, rollup, rollup_type
    end

    def filter_next_month(rollup = nil, rollup_type = nil)
      make_filter_query "next_month", {}, rollup, rollup_type
    end

    def filter_next_year(rollup = nil, rollup_type = nil)
      make_filter_query "next_year", {}, rollup, rollup_type
    end

    protected

    # @param [Date, Time, DateTime, String, nil] obj
    # @return [String] iso8601 format string
    def value_str(obj)
      case obj
      when Date
        obj.iso8601
      when Time
        obj.strftime("%Y-%m-%dT%H:%M:%S%:z")
      when DateTime
        obj.iso8601
      else
        obj
      end
    end
  end
end
