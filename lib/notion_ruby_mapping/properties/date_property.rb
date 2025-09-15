# frozen_string_literal: true

module NotionRubyMapping
  # DateProperty
  class DateProperty < DateBaseProperty
    TYPE = "date"

    ### Public announced methods

    ## Common methods

    # @return [Hash]
    # @see https://www.notion.so/hkob/DateProperty-c6e815c060cb430889dbb33b697f00c6#e64792d3d35c439e8123f108987becc3
    def date
      @json
    end

    ## Page property only methods

    # @return [Date, Time, DateTime, String]
    # @see https://www.notion.so/hkob/DateProperty-c6e815c060cb430889dbb33b697f00c6#15f2088e012549cbae93de14ce14d352
    def end_date
      assert_page_property __method__
      @json["end"]
    end

    def end_date_obj
      assert_page_property __method__
      jet = @json["end"]
      case jet
      when String
        jet.include?("T") ? Time.parse(jet) : Date.parse(jet)
      else
        jet
      end
    end

    # @param [Date, Time, DateTime, String] edt
    # @see https://www.notion.so/hkob/DateProperty-c6e815c060cb430889dbb33b697f00c6#944c02096101429084527c22155683bf
    def end_date=(edt)
      assert_page_property __method__
      @will_update = true
      # sdt = start_date
      # edt = nil if sdt.class != edt.class || sdt > edt
      @json["end"] = edt
    end

    # @return [Date, Time, DateTime, String]
    # @see https://www.notion.so/hkob/DateProperty-c6e815c060cb430889dbb33b697f00c6#d37097c7a3f7481e9b33a7aaae783888
    def start_date
      assert_page_property __method__
      @json["start"]
    end

    def start_date_obj
      assert_page_property __method__
      jst = @json["start"]
      case jst
      when String
        jst.include?("T") ? Time.parse(jst) : Date.parse(jst)
      else
        jst
      end
    end

    # @param [Date, Time, DateTime, String] sdt
    # @see https://www.notion.so/hkob/DateProperty-c6e815c060cb430889dbb33b697f00c6#4f5931f1588a43f7857af8ab2d73df74
    def start_date=(sdt)
      assert_page_property __method__
      @will_update = true
      # edt = end_date
      # @json["end"] = nil if sdt.class != edt.class || sdt > edt
      @json["start"] = sdt
    end

    # @return [String]
    # @see https://www.notion.so/hkob/DateProperty-c6e815c060cb430889dbb33b697f00c6#f892cde82d9a44a0850d69878e31b216
    def time_zone
      assert_page_property __method__
      @json[:time_zone]
    end

    # @param [String] tzone
    # @see https://www.notion.so/hkob/DateProperty-c6e815c060cb430889dbb33b697f00c6#2529a5ac7982466f9f19299fc51e02a8
    def time_zone=(tzone)
      assert_page_property __method__
      @will_update = true
      @json[:time_zone] = tzone
    end

    ### Not public announced methods

    ## Common methods

    # @param [String] name
    # @param [Hash] json
    # @param [Date, Time, DateTime, String, nil] start_date
    # @param [Date, Time, DateTime, String, nil] end_date
    # @param [String, nil] time_zone
    def initialize(name, will_update: false, base_type: "page", json: nil, start_date: nil, end_date: nil,
                   time_zone: nil, property_id: nil, property_cache: nil)
      super name, will_update: will_update, base_type: base_type, property_id: property_id,
                  property_cache: property_cache
      @json = json || {}
      return if database_or_data_source?

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
          "type" => TYPE,
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
