# frozen_string_literal: true

module Ganttx2
  class DateRangeList
    def initialize(start_date, limit, count)
      date_range = [DateRange.new(start_date, limit)]

      @list = 1.upto(count - 1).each_with_object(date_range) { |x, memo|
        memo << DateRange.new(memo.last.end_date + 1, limit)
      }
      @data_in_date_range = {}
      0.upto(count-1).each do |x| @data_in_date_range[x] = [] end
    end

    def partition(ss)
      ss.keys.each do |day|
        index = get_index(day)
        # pp day
        raise unless index
        @data_in_date_range[index] ||= []
        @data_in_date_range[index] << ss[day]
      end
      @data_in_date_range.each do |index, data_list|
        # pp "index=#{index}"
        # pp "index=#{index} data_list=#{data_list}"
        @list[index].add_data_list(data_list) if index
      end
    end

    def get_index(day)
      @list.find_index { |x|
        x.start_date <= day && day <= x.end_date
      }
    end

    def each(&block)
        if block
            if @list
            @list.each do |x|
              block.call(x)
            end
        end
      else
          if @list
              @list.each
          end
      end
    end
  end
end
