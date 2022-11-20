# frozen_string_literal: true

module Ganttx2
  class Itemx
    attr_reader :name, :time, :time_span, :time_span_unit, :start_date, :end_date

    def initialize(name, time, time_span, time_span_unit)
      @name = name
      @time = time

      @time_span = time_span

      @time_span_unit = time_span_unit

      error_check

      @start_date = time
      @end_date = calcurate_end_date
    end

    def error_check
      raise unless @time
      raise unless @time.instance_of?(Date)

      raise unless @time_span
      raise unless @time_span.instance_of?(Integer)

      raise unless @time_span_unit
      raise unless @time_span_unit.instance_of?(Symbol)
    end

    def time_span_with_unit
      %(#{@time_span}#{@time_span_unit})
    end

    def divide(end_date)
      return nil if @end_date < end_date

      next_start_date = end_date.next_day
      next_time_span = @time_span - ((end_date - @start_date).to_i + 1)
      @end_date = end_date
      @time_span -= next_time_span
      Itemx.new(@name, next_start_date, next_time_span, @time_span_unit)
    end

    def calcurate_end_date
      unit = 0
      case @time_span_unit
      when :d, :D
        unit = 1
      end
      raise unless @time
      raise unless @time_span

      # TODO: 暫定実装。unitを考慮して項目の終了日を決定する
      @time + @time_span - (@time_span * unit)
    end

    def next_item_start_day
      unit = 0
      case @time_span_unit
      when :d, :D
        unit = 1
      end
      raise unless @time
      raise unless @time_span

      # TODO: 暫定実装。unitを考慮して次項目の開始日を決定する
      @time + (@time_span * unit)
    end

    def calurate_next_day
      unit = 0
      case @time_span_unit
      when :d, :D
        unit = 1
      end
      raise unless @time
      raise unless @time_span

      # TODO: 暫定実装。@time_spanを考慮して次の項目の開始日を決定する
      @time + (@time_span * unit)
    end
  end
end
