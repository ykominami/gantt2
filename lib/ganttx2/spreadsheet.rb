require 'json'
require 'open-uri'

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
      @content = URI.open(@url) do |f|
        charset = f.charset
        f.read
      end

      File.write(@file_path, @content)
    end

    def get_from_file
      File.open(@file_path) { |file|
        @content = file.read()
      }
    end

    def make_data(header, data)
      header.zip(data).to_h
    end

    def select_data(select_cond)
      return @selected unless @content

      json = JSON.parse(@content)
      header = json.shift
      ss = json.each_with_object({}) { |data, memo|
        hash = make_data(header, data)
        memo[hash["id"]] = hash
      }
      case select_cond
      when :PRIORITY_O
        @selected = select_priority_o(ss)
      when :PRIORITY_O_AND_SUB_PRIORITY_0
        @selected = select_priority_o_and_sub_priority_0(ss)
      when :PRIORITY_O_AND_SUB_PRIORITY_1
        @selected = select_priority_o_and_sub_priority_1(ss)
      when :PRIORITY_NIL
        @selected = select_priority_nil(ss)
      else
        @selected = ss
      end

      @selected
    end

    def select_priority_o(ss)
      ss.select { |id, hash|
        hash["priority"] == "o"
      }
    end

    def select_priority_o_and_sub_priority_0(ss)
      ss.select { |id, hash|
        hash["priority"] == "o" && hash["sub_priority"] == 0
      }
    end

    def select_priority_o_and_sub_priority_1(ss)
      ss.select { |id, hash|
        hash["priority"] == "o" && hash["sub_priority"] == 1
      }
    end

    def select_priority_nil(ss)
      ss.select { |id, hash|
        hash["priority"] == "" || hash["priority"] == nil
      }
    end
  end
end
