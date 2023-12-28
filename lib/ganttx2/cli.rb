# frozen_string_literal: true

require "date"
require "yaml"
require "ganttx2"
require "optparse"

module Ganttx2
  class Cli
    def initialize(argv)
      opt = OptionParser.new
      opt.on("-o output_filename") { |v| @output_filename = v }
      opt.parse!(argv)
      @output_file = if @output_filename
                       File.open(@output_filename, "w")
                     else
                       $stdout
                     end
      # p @output_file
      @cmd = nil
      @yml_fname = argv[0]
      @erb_fname = argv[1]
      @config_fname = argv[2]
      @cmd = argv[3] if argv.size > 3
    end

    def setup
      @selected_data_by_hash = {}
      @ssheet = nil
      content = File.read(@yml_fname)

      @content_hash = YAML.safe_load(content, permitted_classes: [Date])
      raise InvalidDataYamlError, "Invalid Data yaml file(#{@yml_fname})" unless @content_hash

      @config_content = File.read(@config_fname)
      @config_hash = YAML.safe_load(@config_content, permitted_classes: [Date])
      raise InvalidConfigYamlError.call("Invalid Config yaml file(#{@config_fname})") unless @config_hash

      @url = @config_hash["url"]
      @start_date = @config_hash["start_date"]
      @store_file = @config_hash["store_file"]
      @store_yaml_file = @config_hash["store_yaml_file"]
    end

    def run
      exit_code = EXIT_CODE_OF_SUCCESS

      begin
        setup
        retrieve_spreadsheet
        execute
        merge_to_yaml_and_output
      rescue InvalidDataYamlError => e
        puts e.message
        exit(EXIT_CODE)
      rescue InvalidConfigYamlError => e
        puts e.message
        exit(EXIT_CODE)
      end
    end

    def retrieve_spreadsheet
      # Getting the spreadsheet from the url and storing it in a file.
      @ssheet = Spreadsheet.new(@url, @store_file)
      case @cmd
      when "get"
        @ssheet.get
      when "file"
        @ssheet.retrieve_from_file
      end
      select_cond = :PRIORITY_O
      # select_cond = :PRIORITY_O_AND_SUB_PRIORITY_0
      # select_cond = :PRIORITY_O_AND_SUB_PRIORITY_1
      # select_cond = :PRIORITY_NIL
      # select_cond = :PRIORITY_ALL

      selected_data = @ssheet.select_data(select_cond)
      @selected_data_by_hash = selected_data.each_with_object({}) do |x, memo|
        xhash = x[1]
        memo[xhash["category"]] ||= []
        memo[xhash["category"]] << xhash["title"]
      end
    end

    def execute
      limit = @config_hash["limit"]
      count = @config_hash["count"]

      ## pp "cli.rb @start_date=#{@start_date}"
      date_range_list = DateRangeList.new(@start_date, limit, count)
      doslist = DateOrderedSectionList.new(date_range_list)
      sectionlist = SectionList.new(@content_hash, doslist)

      # debugger

      @selected_data_by_hash.each do |name, array|
        sectionlist.append_section(name, array, 1)
      end
      sectionlist.reorder

      doslist.divide
      gantt = Ganttdata.new(doslist, @erb_fname)
      gantt.output(@output_file)
    end

    def merge_to_yaml_and_output
      hashx = @content_hash.dup
      @selected_data_by_hash.each do |name, array|
        section = sectionlist.get_section(name)
        hashx[name] = {}
        # date_str = section.start_date.strftime("%Y-%m-%d")
        hashx[name][section.start_date] = {}
        time_span_with_unit_first = "1D"
        time_span_with_unit_second = "1d"
        time_span_with_unit = time_span_with_unit_first
        array.each do |item_name|
          # arrayにitem_nameが重複して存在する場合、最初のものを残す（上書きしない）
          unless hashx[name][section.start_date][item_name]
            hashx[name][section.start_date][item_name] = time_span_with_unit
            time_span_with_unit = time_span_with_unit_second
          end
        end
        dump_yaml_to_file(hashx, @store_yaml_file)
      end
    end

    def dump_yaml_to_file(obj, fpath)
      File.write(fpath, YAML.dump(obj))
    end
  end
end
