# frozen_string_literal: true

module Ganttx2
  class DateRangeList
    def initialize(start_date, limit, count)
      date_range = [DateRange.new(start_date, limit)]
      @dateranges = []
      @dateranges = 1.upto(count - 1).each_with_object(date_range) do |_x, memo|
        memo << DateRange.new(memo.last.end_date + 1, limit)
      end

      # @data_in_date_range = {}
    end

    def reform
      @dateranges.each_with_object({}) do |date_range, memo|
        date_range.add_data_hash(memo) unless memo.size.zero?
      end
    end

    def make_up
      @dateranges.each do |date_range, _|
        date_range.make_up
      end
    end

    def get_date_range(day)
      @dateranges.find do |x|
        if day
          x.start_date <= day && day <= x.end_date
        else
          true
        end
      end
    end

    def each(&block)
      return unless block

      return unless @dateranges

      @dateranges.each do |date_range|
        block.call(date_range)
      end
    end
  end
end
