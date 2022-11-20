# frozen_string_literal: true

module Ganttx2
  class SectionList
    attr_reader :sections, :start_date, :end_date

    def initialize(hash, doslist)
      @doslist = doslist
      @sections = {}
      @cur_date = nil
      @start_date = nil
      @end_date = nil
      hash.each do |section_name, hash1|
        section = Section.new.init(section_name, hash1, @end_date)
        @sections[section] = section

        @start_date = section.start_date if @start_date.nil? || @start_date > section.start_date
        @end_date = section.end_date if @end_date.nil? || @end_date < section.end_date
        @prev_itemx = nil
      end
    end

    def update_start_date_and_end_date
      @sections.each do |_section_key, section|
        @start_date = section.start_date if @start_date.nil? || @start_date > section.start_date
        @end_date = section.end_date if @end_date.nil? || @end_date < section.end_date
      end
    end

    def append_section(name, array, time_span)
      section = Section.new.make_section(name, array, @end_date, time_span)
      @sections[section] = section
      # @sections[name] = section
      @end_date = section.end_date if @end_date.nil? || @end_date < section.end_date
    end

    def reorder
      @sections.each do |_section_k, section|
        section.reorder(@doslist)
      end
      @date_range_list
    end
  end
end
