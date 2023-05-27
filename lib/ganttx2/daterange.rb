# frozen_string_literal: true

module Ganttx2
  class DateRange
    attr_reader :start_date, :end_date, :data_hash, :sections

    def initialize(start_date, limit)
      @start_date = start_date
      @end_date = start_date + limit
      @data_hash = {}
    end

    def add_data_hash(data_hash)
      # p "data_hash=#{data_hash}"
      # p "data_hash.class=#{data_hash.class}"
      key = data_hash[0]
      value = data_hash[1]
      check_error(key, value)

      @data_hash = Utils.hash_merge(@data_hash, { key => value })
      check_error_data_hash(@data_hash)
    end

    def check_error(key, value)
      # p key.class
      # p value.class
      raise InvalidClassError.new("Key must be String class") unless key.instance_of?(String)
      raise InvalidClassError.new("Value must be Array class") unless value.instance_of?(Array)

      value.each do |item|
        raise InvalidClassError.new("item must not be Array class") if item.instance_of?(Array)
      end
    end

    def check_error_data_hash(data_hash)
      raise InvalidClassError.new("it must not be Hash class") unless data_hash.instance_of?(Hash)
      # debugger
      raise InvalidClassError.new("it must not be zero") if data_hash.size.zero?
    end

    def reform
      item_array_z = []
      # debugger
      @data_hash.each do |section, item_array|
        # debugger
        next unless item_array

        # debugger unless item_array.respond_to?(:each)
        item_array.each do |ix|
          raise InvalidStartDateError.new("ix(#{ix}) must be after #{@start_date}") if ix.start_date < @start_date

          if ix.end_date > @end_date
            item = ix.divide(@end_date)
            item_array_z += [{ section => [[item]] }] if item
          end
        end
      end
      item_array_z
    end

    def make_up
      # debugger
      ret = check_data_hash
      x = []
      x << Itemx.new("dummy", @start_date, 1, :d) unless ret[:head]
      x << Itemx.new("dummy", @end_date, 1, :d) unless ret[:tail]
      add_data_hash(["dummy", x]) if x.size.positive?
    end

    def check_data_hash
      ret = { head: false, tail: false }
      check_array = Array.new((@end_date - @start_date).to_i)
      raise InvalidClassError.new("it must not be Hash class") unless @data_hash.instance_of?(Hash)

      return unless @data_hash

      @data_hash.each do |section, item_array|
        next unless section
        next unless item_array

        item_array.each do |item|
          next unless item

          num = (item.start_date - @start_date).to_i
          1.upto(item.time_span).each do |ind|
            index = num + (ind - 1)
            check_array[index] = true
          end
        end
      end
      ret[:head] = (check_array[0] == true)
      ret[:tail] = (check_array.last == true)
      ret
    end
  end
end
