# frozen_string_literal: true

require "date"

module NotionRubyMapping
  # Date base property (date, created_time, last_edited_time)
  class DateBaseProperty < Property
    include IsEmptyIsNotEmpty

    # @param [Date, Time, DateTime, String] obj
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

    def filter_equals(value)
      make_filter_query :equals, value_str(value)
    end

    def filter_does_not_equal(value)
      make_filter_query :does_not_equal, value_str(value)
    end

    def filter_before(value)
      make_filter_query :before, value_str(value)
    end

    def filter_after(value)
      make_filter_query :after, value_str(value)
    end

    def filter_on_or_before(value)
      make_filter_query :on_or_before, value_str(value)
    end

    def filter_on_or_after(value)
      make_filter_query :on_or_after, value_str(value)
    end

    def filter_past_week
      make_filter_query :past_week, {}
    end

    def filter_past_month
      make_filter_query :past_month, {}
    end

    def filter_past_year
      make_filter_query :past_year, {}
    end

    def filter_next_week
      make_filter_query :next_week, {}
    end

    def filter_next_month
      make_filter_query :next_month, {}
    end

    def filter_next_year
      make_filter_query :next_year, {}
    end
  end
end
