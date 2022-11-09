module Ganttx2
  class SectionInDateRange
    attr_accessor :name, :start_date, :end_date, :dates, :cur_date, :prev_itemx

    def initialize(date_range)
      @date_range = date_range
      @name = nil
      @start_date = nil
      @end_date = nil
      @dates = {}
      @prev_itemx = nil
      @time_span_unit = :d
      @time_span_unit_first = :D
    end
  end
end
