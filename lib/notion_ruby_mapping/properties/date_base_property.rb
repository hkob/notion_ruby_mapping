# frozen_string_literal: true

require "date"

module NotionRubyMapping
  # Date base property (date, created_time, last_edited_time, formula)
  class DateBaseProperty < Property
    include IsEmptyIsNotEmpty

    # @param [Date, Time, DateTime, String, nil] obj
    # @return [String, nil] iso8601 format string
    def self.value_str(obj, start_time: false, end_time: false)
      case obj
      when DateTime
        obj.iso8601
      when Date
        tz = Time.now.strftime "%:z"
        ds = obj.iso8601
        if start_time
          "#{ds}T00:00:00#{tz}"
        elsif end_time
          "#{ds}T23:59:59#{tz}"
        else
          ds
        end
      when Time
        obj.strftime("%Y-%m-%dT%H:%M:%S%:z")
      else
        obj
      end
    end

    # @param [Date] date
    def self.start_end_time(date)
      ds = date.iso8601
      tz = Time.now.strftime "%:z"
      %w[00:00:00 23:59:59].map { |t| [ds, "T", t, tz].join("") }
    end

    # @param [Date, Time, DateTime, String, nil] obj
    # @return [Date, nil] iso8601 format string
    def self.date_from_obj(obj)
      str = value_str obj
      Date.parse str if str
    end

    # @param [String] condition Rollup name
    # @param [String] another_type Rollup type
    # @return [NotionRubyMapping::Query] generated Query object
    # @see https://www.notion.so/hkob/CheckboxProperty-ac1edbdb8e264af5ad1432b522b429fd#5f07c4ebc4744986bfc99a43827349fc
    def filter_equals(date, condition: nil, another_type: nil)
      if date.class == Date
        start_date, end_date = self.class.start_end_time date
        if condition
          filter_after(start_date, condition: condition, another_type: another_type)
            .and(filter_before(end_date, condition: condition, another_type: another_type))
        else
          filter_after(start_date, another_type: another_type)
            .and(filter_before(end_date, another_type: another_type))
        end
      else
        make_filter_query "equals", value_str(date), condition: condition, another_type: another_type
      end
    end

    # @param [String] condition Rollup name
    # @param [String] another_type Rollup type
    # @return [NotionRubyMapping::Query] generated Query object
    def filter_does_not_equal(date, condition: nil, another_type: nil)
      if date.class == Date
        start_date, end_date = self.class.start_end_time date
        if condition
          filter_before(start_date, condition: condition, another_type: another_type)
            .or(filter_after(end_date, condition: condition, another_type: another_type))
        else
          filter_before(start_date, another_type: another_type)
            .or(filter_after(end_date, another_type: another_type))
        end
      else
        make_filter_query "does_not_equal", value_str(date), condition: condition, another_type: another_type
      end
    end

    # @param [String] condition Rollup name
    # @param [String] another_type Rollup type
    # @return [NotionRubyMapping::Query] generated Query object
    # @see https://www.notion.so/hkob/CreatedTimeProperty-bb979ff02dc04efa9733da1003efa871#841815bfaf684964bebf3fa6712ae26c
    def filter_before(date, condition: nil, another_type: nil)
      make_filter_query "before", value_str(date, start_time: true), condition: condition, another_type: another_type
    end

    # @param [String] condition Rollup name
    # @param [String] another_type Rollup type
    # @return [NotionRubyMapping::Query] generated Query object
    # @see https://www.notion.so/hkob/CreatedTimeProperty-bb979ff02dc04efa9733da1003efa871#c0ea140866ea46f9a746b24773dc821c
    def filter_after(date, condition: nil, another_type: nil)
      make_filter_query "after", value_str(date, end_time: true), condition: condition, another_type: another_type
    end

    # @param [String] condition Rollup name
    # @param [String] another_type Rollup type
    # @return [NotionRubyMapping::Query] generated Query object
    # @see https://www.notion.so/hkob/CreatedTimeProperty-bb979ff02dc04efa9733da1003efa871#6a20ade0ee964aad81aae4c08ea29d6b
    def filter_on_or_before(date, condition: nil, another_type: nil)
      make_filter_query "on_or_before", value_str(date, end_time: true), condition: condition, another_type: another_type
    end

    # @param [String] condition Rollup name
    # @param [String] another_type Rollup type
    # @return [NotionRubyMapping::Query] generated Query object
    # @see https://www.notion.so/hkob/CreatedTimeProperty-bb979ff02dc04efa9733da1003efa871#1469e3fb3068426a8ea8492d191d1563
    def filter_on_or_after(date, condition: nil, another_type: nil)
      make_filter_query "on_or_after", value_str(date, start_time: true), condition: condition, another_type: another_type
    end

    # @param [String] condition Rollup name
    # @param [String] another_type Rollup type
    # @return [NotionRubyMapping::Query] generated Query object
    # @see https://www.notion.so/hkob/CreatedTimeProperty-bb979ff02dc04efa9733da1003efa871#707e7e848dc9417998420b65024542db
    def filter_past_week(condition: nil, another_type: nil)
      make_filter_query "past_week", {}, condition: condition, another_type: another_type
    end

    # @param [String] condition Rollup name
    # @param [String] another_type Rollup type
    # @return [NotionRubyMapping::Query] generated Query object
    # @see https://www.notion.so/hkob/CreatedTimeProperty-bb979ff02dc04efa9733da1003efa871#7b2d05c549204c2eb68d95020d7b97c5
    def filter_past_month(condition: nil, another_type: nil)
      make_filter_query "past_month", {}, condition: condition, another_type: another_type
    end

    # @param [String] condition Rollup name
    # @param [String] another_type Rollup type
    # @return [NotionRubyMapping::Query] generated Query object
    # @see https://www.notion.so/hkob/CreatedTimeProperty-bb979ff02dc04efa9733da1003efa871#9c8bf0a2398a41c8a0714a62afca3aa8
    def filter_past_year(condition: nil, another_type: nil)
      make_filter_query "past_year", {}, condition: condition, another_type: another_type
    end

    # @param [String] condition Rollup name
    # @param [String] another_type Rollup type
    # @return [NotionRubyMapping::Query] generated Query object
    # @see
    def filter_this_week(condition: nil, another_type: nil)
      make_filter_query "this_week", {}, condition: condition, another_type: another_type
    end

    # @param [String] condition Rollup name
    # @param [String] another_type Rollup type
    # @return [NotionRubyMapping::Query] generated Query object
    # @see https://www.notion.so/hkob/CreatedTimeProperty-bb979ff02dc04efa9733da1003efa871#d9dc189ee8244ba8a6c863259eaa9984
    def filter_next_week(condition: nil, another_type: nil)
      make_filter_query "next_week", {}, condition: condition, another_type: another_type
    end

    # @param [String] condition Rollup name
    # @param [String] another_type Rollup type
    # @return [NotionRubyMapping::Query] generated Query object
    # @see https://www.notion.so/hkob/CreatedTimeProperty-bb979ff02dc04efa9733da1003efa871#0edb4dffbe6b403882255e870cc71066
    def filter_next_month(condition: nil, another_type: nil)
      make_filter_query "next_month", {}, condition: condition, another_type: another_type
    end

    # @param [String] condition Rollup name
    # @param [String] another_type Rollup type
    # @return [NotionRubyMapping::Query] generated Query object
    # @see https://www.notion.so/hkob/CreatedTimeProperty-bb979ff02dc04efa9733da1003efa871#b59c73dd4b1a488f95d3e8cd19853709
    def filter_next_year(condition: nil, another_type: nil)
      make_filter_query "next_year", {}, condition: condition, another_type: another_type
    end

    # @param [Date, Time, DateTime, String, nil] obj
    # @return [String, nil] iso8601 format string
    def value_str(obj, start_time: false, end_time: false)
      self.class.value_str(obj, start_time: start_time, end_time: end_time)
    end
  end
end
