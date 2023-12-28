# frozen_string_literal: true

module Ganttx2
  class Section
    attr_accessor :name, :start_date, :end_date, :dates, :cur_date, :prev_itemx

    def initialize
      @name = nil
      @start_date = nil
      @end_date = nil
      @dates = {}
      @cur_date = nil
      @prev_itemx = nil
      @time_span_unit = :d
      @time_span_unit_first = :D
    end

    def parse_under_section(hash1)
      state_date_state = true

      start_date = hash1.keys.first
      if start_date.class != Date
        unless start_date.instance_of?(String)
          raise InvalidStartDateClassError, "StartDate cannot specified as Data or String"
        end

        state_date_state = false

      end

      if state_date_state
        @start_date = start_date
      else
        @start_date = @prev_end_date
        hash1 = { @start_date => hash1 }
      end
      hash1.each do |date, hash|
        @cur_date = date
        @dates[@cur_date] = []
        parse_item(hash)
      end
    end

    def init(name, hash1, prev_end_date)
      @name = name
      @prev_end_date = prev_end_date
      @start_date = nil
      @end_date = nil
      @dates = {}
      parse_under_section(hash1)
      self
    end

    def init_dummy(name)
      @name = name
    end

    def make_section(name, array, prev_end_date, time_span)
      st = Section.new
      st.name = name
      st.start_date = prev_end_date.next_day
      st.end_date = nil

      st.cur_date = st.start_date
      st.dates[st.cur_date] = []
      st.prev_itemx = nil
      time_span_unit = @time_span_unit_first
      array.each do |namex|
        itemx_date = if st.prev_itemx
                       st.prev_itemx.next_item_start_day
                     else
                       st.cur_date
                     end
        itemx = Itemx.new(namex, itemx_date, time_span, time_span_unit)
        time_span_unit = @time_span_unit
        st.dates[itemx_date] ||= []
        st.dates[itemx_date] << itemx

        st.prev_itemx = itemx
      end
      st.end_date = st.prev_itemx.end_date
      st
    end

    def parse_item(item)
      item.each do |name, time_span|
        # 日付が出現したら
        if name.instance_of?(Date)
          hashx = { name => time_span }
          parse_under_section(hashx)
        else
          day, _rest = time_span.split("D")
          if day.length == time_span.length
            day, _rest = time_span.split("d")
            if day.length != time_span.length
              if @prev_itemx
                itemx_date = @prev_itemx.next_item_start_day
                itemx = Itemx.new(name, itemx_date, day.to_i, @time_span_unit)
              else
                itemx = Itemx.new(name, @cur_date, day.to_i, @time_span_unit)
              end
              @dates[itemx_date] ||= []
              @dates[itemx_date] << itemx
              @prev_itemx = itemx
            end
          else
            itemx = Itemx.new(name, @cur_date, day.to_i, :d)
            @dates[@cur_date] << itemx
            @prev_itemx = itemx
          end
          @prev_itemx = itemx
        end
      end
      @end_date = @prev_itemx.end_date
    end

    def reorder(doslist)
      @dates.each do |time, item_array|
        check_error(item_array)

        doslist.add(time, @name, item_array)
      end
    end

    def check_error(item_array)
      raise InvalidClassError, "item_array must be Array class" unless item_array.instance_of?(Array)
      raise InvalidClassError, "item_array must not be Hash class" if item_array.instance_of?(Hash)

      item_array.each do |item|
        raise InvalidClassError, "item must not be Array class" if item.instance_of?(Array)
      end
    end
  end
end
