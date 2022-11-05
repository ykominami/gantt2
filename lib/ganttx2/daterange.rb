# frozen_string_literal: true

module Ganttx2
  class DateRange
    attr_reader :start_date, :end_date, :data_list

    def initialize(start_date, limit)
      @start_date = start_date
      @end_date = start_date + limit
      @data = nil
    end

    def add_data_list(data_list)
      @data_list = data_list
      # pp @data_list
      # pp @data_list.class
      ret = check_data_list
      x = []
      if !ret[:head]
        x << Itemx.new("dummy", @start_date, 1, :d)
      end
      if !ret[:tail]
        x << Itemx.new("dummy", @end_date, 1, :d)
      end

      @data_list << { "dummy" => [x] } if x.size.positive?
    end

    def check_data_list()
      ret = { head: false, tail: false }
      check_array = Array.new( (@end_date - @start_date).to_i)
      if @data_list
        @data_list.each do |data|
          next unless data
          data.each do |section, array|
            next unless array
            array.each do |array2|
              next unless array2.each do |item|
                next unless item
                num = (item.time - @start_date).to_i
                1.upto(item.time_span).each do |ind|
                  index = num + (ind - 1)
                  check_array[index] = true
                end
              end
            end
          end
        end
        ret[:head] = (check_array[0] == true)
        ret[:tail] = (check_array.last == true)
        ret
      end
    end
  end
end
