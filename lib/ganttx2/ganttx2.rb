# frozen_string_literal: true
require 'tilt'

module Ganttx2
  class Ganttx2
    def initialize(date_range_list, erb_path)
      @date_range_list = date_range_list
      @erb_path = erb_path
      @erb_content = File.read(@erb_path)
      @scope = Object.new
    end

    def erubi_render(template_hash, scope, value_hash = {})
      unless template_hash[:OBJ]
        template_hash[:OBJ] = Tilt::ErubiTemplate.new { template_hash[:TEMPLATE]}
      end
      template_hash[:OBJ].render(scope, value_hash)
    end

    def erubi_render_with_file(template_file_path, scope, value_file_path_array)
      template_text = File.read(template_file_path)
      template_hash = { TEMPLATE: template_text,
                        OBJ: nil }
      value_hash = value_file_path_array.reduce({}) { |hash, path|
        hash0 = YAML.load_file(path)
        hash = hash.merge(hash0)
        hash
      }
      erubi_render(template_hash, scope, value_hash)
    end

    def erubi_render_with_template_file(template_file_path, scope, value_hash = {})
      template_text = File.read(template_file_path)
      template_hash = make_template_hash(template_text)
      erubi_render(template_hash, scope, value_hash)
    end

    def make_template_hash(text)
      { TEMPLATE: text,
        OBJ: nil }
    end

    def month_day(date)
      %!#{date.month}/#{date.day}!
    end

    def output_one_data_range(data_range)
      obj = Tilt::ErubiTemplate.new { @erb_content }
      value_hash = {}
      value_hash["start_date"] = month_day(data_range.start_date)
      value_hash["end_date"] = month_day(data_range.end_date)
      value_hash["data_list"] = data_range.data_list
      str = obj.render(@scope, value_hash)
    end

    def output
      @date_range_list.each do |data_range|
        str = ""
        str = output_one_data_range(data_range)
        puts str
      end
    end
  end
end
