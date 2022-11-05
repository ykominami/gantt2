# frozen_string_literal: true

module Ganttx2
  class Itemx
    attr_reader :name, :time, :time_span, :time_span_unit

    def initialize(name, time, time_span, time_span_unit)
      @name = name
      @time = time
      raise unless @time
      # puts "itemx.rb:11 initialize @time=#{@time} #{@time.class} name=#{name}"
      raise unless @time.class == Date
      @time_span = time_span
      raise unless @time_span
      raise unless @time_span.class == Integer
      @time_span_unit = time_span_unit
      raise unless @time_span_unit
      # puts "itemx.rb:18 initialize @time_span_unit.class=#{@time_span_unit.class} name=#{name}"
      raise unless @time_span_unit.class == Symbol
    end

    def time_span_with_unit
      %!#{@time_span}#{@time_span_unit}!
    end

    def get_end_date
      unit = 0
      case @time_span_unit
      when :d, :D
        unit = 1
      else
        #
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
        #
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
        #
      end
      raise unless @time
      raise unless @time_span
      @time + unit
    end
  end
end