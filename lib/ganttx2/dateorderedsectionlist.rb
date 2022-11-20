# frozen_string_literal: true

module Ganttx2
  class DateOrderedSectionList
    attr_accessor :date_order_list

    def initialize(date_order_list)
      @date_order_list = date_order_list
      @hash = {}
    end

    def add(date, section_name, item_array)
      @hash[date] ||= {}
      @hash[date][section_name] ||= []
      @hash[date][section_name] += item_array
      # debugger
      check_error(date, section_name)
    end

    def check_error(date, section_name)
      @hash[date][section_name].each do |item|
        raise if item.instance_of?(Array)
      end
      raise if @hash[date][section_name].instance_of?(Hash)
      raise unless @hash[date][section_name].instance_of?(Array)
    end

    def partition
      @hash.each_key do |date|
        date_range = @date_order_list.get_date_range(date)
        raise unless date_range

        @hash[date].each do |data_hash|
          date_range.add_data_hash(data_hash)
        end
      end
      # debugger

      @date_order_list.reform
      # debugger
      @date_order_list.make_up
    end
  end
end
