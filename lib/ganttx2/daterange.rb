# frozen_string_literal: true

module Ganttx2
  class DateRange
    attr_reader :start_date, :end_date, :data_list, :sections

    def initialize(start_date, limit)
      @start_date = start_date
      @end_date = start_date + limit
      @data_list = {}
    end

    def add_data_list(data_list)
      raise unless data_list.instance_of?(Hash)

      data_list.each do |key, value|
        raise unless key.instance_of?(String)
        raise unless value.instance_of?(Array)

        value.each do |item|
          raise if item.instance_of?(Array)
        end
      end
      @data_list.merge!(data_list)
      raise if @data_list.size.zero?
    end

    def reform()
      item_array_z = []
      @data_list.map { |hash0|
        hash0.each do |section, item_array|
          if item_array
            debugger unless item_array.respond_to?(:each)
            #
            item_array.each do |ix|
              ix.each do |iy|
                # puts "start_day=#{iy.start_date}"
                # puts "end_day=#{iy.end_date}"
                raise if iy.start_date < @start_date

                if iy.end_date > @end_date
                  item = iy.divide(@end_date)
                  item_array_z += [{ section => [[item]] }] if item
                end
              end
            end
          end
        end
      }
      item_array_z
    end

    def make_up()
      ret = check_data_list
      x = []
      if !ret[:head]
        x << Itemx.new("dummy", @start_date, 1, :d)
      end
      if !ret[:tail]
        x << Itemx.new("dummy", @end_date, 1, :d)
      end
      add_data_list({ "dummy" => x }) if x.size.positive?
    end

    def check_data_list()
      ret = { head: false, tail: false }
      check_array = Array.new((@end_date - @start_date).to_i)
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
