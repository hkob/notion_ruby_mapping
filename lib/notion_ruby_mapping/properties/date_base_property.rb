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
      when DateTime
        obj.iso8601
      else
        obj
      end
    end

    # @param [Date] date
    def self.start_end_time(date)
      ds = date.iso8601
      tz = Time.now.strftime "%:z"
      %w[00:00:00 23:59:59].map {|t| [ds, "T", t, tz].join("") }
    end

    # @param [Date, Time, DateTime, String, nil] obj
    # @return [Date, nil] iso8601 format string
    def self.date_from_obj(obj)
      str = value_str obj
      Date.parse str if str
    end

    # @param [String] rollup Rollup name
    # @param [String] rollup_type Rollup type
    # @return [NotionRubyMapping::Query] generated Query object
    # @see https://www.notion.so/hkob/CheckboxProperty-ac1edbdb8e264af5ad1432b522b429fd#5f07c4ebc4744986bfc99a43827349fc
    def filter_equals(date, rollup = nil, rollup_type = nil)
      if date.is_a? Date
        start_date, end_date = self.class.start_end_time date
        if rollup
          filter_after(start_date, rollup, rollup_type)
            .and(filter_before(end_date, rollup, rollup_type))
        else
          filter_after(start_date).and(filter_before end_date)
        end
      else
        make_filter_query "equals", value_str(date), rollup, rollup_type
      end
    end

    # @param [String] rollup Rollup name
    # @param [String] rollup_type Rollup type
    # @return [NotionRubyMapping::Query] generated Query object
    def filter_does_not_equal(date, rollup = nil, rollup_type = nil)
      if date.is_a? Date
        start_date, end_date = self.class.start_end_time date
        if rollup
          filter_before(start_date, rollup, rollup_type)
            .or(filter_after(end_date, rollup, rollup_type))
        else
          filter_before(start_date).or(filter_after(end_date))
        end
      else
        make_filter_query "does_not_equal", value_str(date), rollup, rollup_type
      end
    end

    # @param [String] rollup Rollup name
    # @param [String] rollup_type Rollup type
    # @return [NotionRubyMapping::Query] generated Query object
    # @see https://www.notion.so/hkob/CreatedTimeProperty-bb979ff02dc04efa9733da1003efa871#841815bfaf684964bebf3fa6712ae26c
    def filter_before(date, rollup = nil, rollup_type = nil)
      make_filter_query "before", value_str(date, start_time: true), rollup, rollup_type
    end

    # @param [String] rollup Rollup name
    # @param [String] rollup_type Rollup type
    # @return [NotionRubyMapping::Query] generated Query object
    # @see https://www.notion.so/hkob/CreatedTimeProperty-bb979ff02dc04efa9733da1003efa871#c0ea140866ea46f9a746b24773dc821c
    def filter_after(date, rollup = nil, rollup_type = nil)
      make_filter_query "after", value_str(date, end_time: true), rollup, rollup_type
    end

    # @param [String] rollup Rollup name
    # @param [String] rollup_type Rollup type
    # @return [NotionRubyMapping::Query] generated Query object
    # @see https://www.notion.so/hkob/CreatedTimeProperty-bb979ff02dc04efa9733da1003efa871#6a20ade0ee964aad81aae4c08ea29d6b
    def filter_on_or_before(date, rollup = nil, rollup_type = nil)
      make_filter_query "on_or_before", value_str(date, end_time: true), rollup, rollup_type
    end

    # @param [String] rollup Rollup name
    # @param [String] rollup_type Rollup type
    # @return [NotionRubyMapping::Query] generated Query object
    # @see https://www.notion.so/hkob/CreatedTimeProperty-bb979ff02dc04efa9733da1003efa871#1469e3fb3068426a8ea8492d191d1563
    def filter_on_or_after(date, rollup = nil, rollup_type = nil)
      make_filter_query "on_or_after", value_str(date, start_time: true), rollup, rollup_type
    end

    # @param [String] rollup Rollup name
    # @param [String] rollup_type Rollup type
    # @return [NotionRubyMapping::Query] generated Query object
    # @see https://www.notion.so/hkob/CreatedTimeProperty-bb979ff02dc04efa9733da1003efa871#707e7e848dc9417998420b65024542db
    def filter_past_week(rollup = nil, rollup_type = nil)
      make_filter_query "past_week", {}, rollup, rollup_type
    end

    # @param [String] rollup Rollup name
    # @param [String] rollup_type Rollup type
    # @return [NotionRubyMapping::Query] generated Query object
    # @see https://www.notion.so/hkob/CreatedTimeProperty-bb979ff02dc04efa9733da1003efa871#7b2d05c549204c2eb68d95020d7b97c5
    def filter_past_month(rollup = nil, rollup_type = nil)
      make_filter_query "past_month", {}, rollup, rollup_type
    end

    # @param [String] rollup Rollup name
    # @param [String] rollup_type Rollup type
    # @return [NotionRubyMapping::Query] generated Query object
    # @see https://www.notion.so/hkob/CreatedTimeProperty-bb979ff02dc04efa9733da1003efa871#9c8bf0a2398a41c8a0714a62afca3aa8
    def filter_past_year(rollup = nil, rollup_type = nil)
      make_filter_query "past_year", {}, rollup, rollup_type
    end

    # @param [String] rollup Rollup name
    # @param [String] rollup_type Rollup type
    # @return [NotionRubyMapping::Query] generated Query object
    # @see https://www.notion.so/hkob/CreatedTimeProperty-bb979ff02dc04efa9733da1003efa871#d9dc189ee8244ba8a6c863259eaa9984
    def filter_next_week(rollup = nil, rollup_type = nil)
      make_filter_query "next_week", {}, rollup, rollup_type
    end

    # @param [String] rollup Rollup name
    # @param [String] rollup_type Rollup type
    # @return [NotionRubyMapping::Query] generated Query object
    # @see https://www.notion.so/hkob/CreatedTimeProperty-bb979ff02dc04efa9733da1003efa871#0edb4dffbe6b403882255e870cc71066
    def filter_next_month(rollup = nil, rollup_type = nil)
      make_filter_query "next_month", {}, rollup, rollup_type
    end

    # @param [String] rollup Rollup name
    # @param [String] rollup_type Rollup type
    # @return [NotionRubyMapping::Query] generated Query object
    # @see https://www.notion.so/hkob/CreatedTimeProperty-bb979ff02dc04efa9733da1003efa871#b59c73dd4b1a488f95d3e8cd19853709
    def filter_next_year(rollup = nil, rollup_type = nil)
      make_filter_query "next_year", {}, rollup, rollup_type
    end

    # @param [Date, Time, DateTime, String, nil] obj
    # @return [String, nil] iso8601 format string
    def value_str(obj, start_time: false, end_time: false)
      self.class.value_str(obj, start_time: start_time, end_time: end_time)
    end
  end
end
