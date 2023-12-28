# frozen_string_literal: true

require "json"
require "open-uri"

module Ganttx2
  class Spreadsheet
    def initialize(url, file_path)
      @url = url
      @file_path = file_path
      @selected = []
      @content = nil
    end

    def get
      charset = nil
      @content = URI.parse(@url).open do |f|
        charset = f.charset
        f.read
      end

      File.write(@file_path, @content)
    end

    def retrieve_from_file
      File.open(@file_path) do |file|
        @content = file.read
      end
    end

    def make_data(header, data)
      header.zip(data).to_h
    end

    def select_data(select_cond)
      return @selected unless @content

      json = JSON.parse(@content)
      header = json.shift
      ss = json.each_with_object({}) do |data, memo|
        hash = make_data(header, data)
        memo[hash["id"]] = hash
      end
      @selected = case select_cond
                  when :PRIORITYO
                    select_priority0(ss)
                  when :PRIORITYO_AND_SUB_PRIORITY0
                    select_priority0_and_sub_priority0(ss)
                  when :PRIORITYO_AND_SUB_PRIORITY1
                    select_priority0_and_sub_priority1(ss)
                  when :PRIORITY_NIL
                    select_priority_nil(ss)
                  else
                    ss
                  end

      @selected
    end

    def select_priority0(sss)
      sss.select do |_id, hash|
        hash["priority"] == "o"
      end
    end

    def select_priority0_and_sub_priority0(sss)
      sss.select do |_id, hash|
        hash["priority"] == "o" && (hash["sub_priority"]).zero?
      end
    end

    def select_priority0_and_sub_priority1(sss)
      sss.select do |_id, hash|
        hash["priority"] == "o" && hash["sub_priority"] == 1
      end
    end

    def select_priority_nil(sss)
      sss.select do |_id, hash|
        hash["priority"] == "" || hash["priority"].nil?
      end
    end
  end
end
