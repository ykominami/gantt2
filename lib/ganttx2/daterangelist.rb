# frozen_string_literal: true

module Ganttx2
  class DateRangeList
    def initialize(start_date, limit, count)
      date_range = [DateRange.new(start_date, limit)]

      @dateranges = 1.upto(count - 1).each_with_object(date_range) { |x, memo|
        memo << DateRange.new(memo.last.end_date + 1, limit)
      }

      @data_in_date_range = {}
    end

    def reform
      @dateranges.each_with_object({}) do |date_range, memo|
        date_range.add_data_list(memo) unless memo.size.zero?
        memo = date_range.reform
      end
    end

    def make_up()
      @data_in_date_range.each do |date_range, _|
        date_range.make_up()
      end
    end

    def partition(ss)
      ss.keys.each do |date|
        date_range = get_date_range(date)
        raise unless date_range

        @data_in_date_range[date_range] ||= {}
        ss[date].each do |section_name, ary|
          date_range.add_data_list({ section_name => ary })
          @data_in_date_range[date_range][section_name] ||= []
          # @data_in_date_range[date_range][section] = section
          # @data_in_date_range[date_range][section].add_item_list(ary)
          @data_in_date_range[date_range][section_name] += ary
        end
      end

      ar = reform()
      ar = ar.flatten
      make_up()
    end

    def get_date_range(day)
      ret = nil
      @dateranges.find { |x|
        x.start_date <= day && day <= x.end_date
      }
    end

    def each(&block)
      if block
        if @data_in_date_range
          @dateranges.each do |date_range|
            block.call(date_range)
          end
        end
      end
    end
  end
end
