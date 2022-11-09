module Ganttx2
  class SectionItem
    attr_accessor :name, :start_date, :end_date, :dates, :cur_date, :prev_itemx

    def initialize()
      @name = nil
      @start_date = nil
      @end_date = nil
      @dates = {}
      @cur_date = nil
      @prev_itemx = nil
      @time_span_unit = :d
      @time_span_unit_first = :D
    end

    def parse_under_section(hash_1)
      state_date_state = true

      start_date = hash_1.keys.first
      if start_date.class != Date
        if start_date.class == String
          state_date_state = false
        else
          raise
        end
      end

      if state_date_state
        @start_date = start_date
      else
        @start_date = @prev_end_date
        hash_1 = { @start_date => hash_1 }
      end
      hash_1.each do |date, hash|
        @cur_date = date
        @dates[@cur_date] = []
        parse_item(hash)
      end
    end

    def init(name, hash_1, prev_end_date)
      @name = name
      @prev_end_date = prev_end_date
      @start_date = nil
      @end_date = nil
      @dates = {}
      parse_under_section(hash_1)
      self
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
        if st.prev_itemx
          itemx_date = st.prev_itemx.get_next_item_start_day
        else
          itemx_date = st.cur_date
        end
        itemx = Itemx.new(namex, itemx_date, time_span, time_span_unit)
        time_span_unit = @time_span_unit
        st.dates[itemx_date] ||= []
        st.dates[itemx_date] << itemx
        st.prev_itemx = itemx
      end
      st.end_date = st.prev_itemx.get_end_date
      st
    end

    def parse_item(item)
      item.each do |name, time_span|
        # 日付が出現したら
        if name.class == Date
          hashx = { name => time_span }
          parse_under_section(hashx)
        else
          day, _rest = time_span.split("D")
          if day.length == time_span.length
            day, _rest = time_span.split("d")
            if day.length != time_span.length
              itemx_date = @prev_itemx.get_next_item_start_day
              itemx = Itemx.new(name, itemx_date, day.to_i, @time_span_unit)
              @dates[itemx_date] ||= []
              @dates[itemx_date] << itemx
              @prev_itemx = itemx
            else
            end
          else
            itemx = Itemx.new(name, @cur_date, day.to_i, :d)
            @dates[@cur_date] << itemx
            @prev_itemx = itemx
          end
          @prev_itemx = itemx
        end
      end
      @end_date = @prev_itemx.get_end_date
    end
  end
end
