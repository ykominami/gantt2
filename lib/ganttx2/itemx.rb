# frozen_string_literal: true

module Ganttx2
  class Itemx
    attr_reader :name, :time, :time_span, :time_span_unit, :start_date, :end_date

    def initialize(name, time, time_span, time_span_unit)
      @name = name
      @time = time
      raise unless @time
      raise unless @time.class == Date

      @time_span = time_span
      raise unless @time_span
      raise unless @time_span.class == Integer

      @time_span_unit = time_span_unit
      raise unless @time_span_unit
      raise unless @time_span_unit.class == Symbol

      @start_date = time
      @end_date = get_end_date
    end

    def time_span_with_unit
      %!#{@time_span}#{@time_span_unit}!
    end

    def divide(end_date)
      return nil if @end_date < end_date

      next_start_date = end_date.next_day
      next_time_span = @time_span - ((end_date - @start_date).to_i + 1)
      @end_date = end_date
      @time_span -= next_time_span
      Itemx.new(@name, next_start_date, next_time_span, @time_span_unit)
    end

    def get_start_date
      @time
    end

    def get_end_date
      unit = 0
      case @time_span_unit
      when :d, :D
        unit = 1
      else
      end
      raise unless @time
      raise unless @time_span

      @time + @time_span - unit
    end

    def get_next_item_start_day
      unit = 0
      case @time_span_unit
      when :d, :D
        unit = 1
      else
      end
      raise unless @time
      raise unless @time_span

      @time + @time_span
    end

    def get_next_day
      unit = 0
      case @time_span_unit
      when :d, :D
        unit = 1
      else
      end
      raise unless @time
      raise unless @time_span

      @time + unit
    end
  end
end
