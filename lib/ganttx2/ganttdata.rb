# frozen_string_literal: true

require "tilt"

module Ganttx2
  class Ganttdata
    def initialize(doslist, erb_path)
      @doslist = doslist
      @erb_path = erb_path
      @erb_content = File.read(@erb_path)
      @scope = Object.new
      @erbitemplate = Tilt::ErubiTemplate.new { @erb_content }
    end

    def erubi_render(template_hash, scope, value_hash = {})
      template_hash[:OBJ] = Tilt::ErubiTemplate.new { template_hash[:TEMPLATE] } unless template_hash[:OBJ]
      template_hash[:OBJ].render(scope, value_hash)
    end

    def erubi_render_with_file(template_file_path, scope, value_file_path_array)
      template_text = File.read(template_file_path)
      template_hash = { TEMPLATE: template_text,
                        OBJ: nil }
      value_hash = value_file_path_array.reduce({}) do |hash, path|
        hash0 = YAML.load_file(path)
        # hash = hash.merge(hash0)
        hash = Utils.hash_merge(hash, hash0)
        hash
      end
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
      %(#{date.month}/#{date.day})
    end

    def output_one_data_range(data_range)
      value_hash = {}
      value_hash["start_date"] = month_day(data_range.start_date)
      value_hash["end_date"] = month_day(data_range.end_date)
      value_hash["data_hash"] = data_range.data_hash
      @erbitemplate.render(@scope, value_hash)
      # debugger
    end

    def output(output_file)
      date_order_list = @doslist.date_order_list
      date_order_list.each do |data_hash|
        str = output_one_data_range(data_hash)
        # debugger
        output_file.puts(str)
      end
    end
  end
end
