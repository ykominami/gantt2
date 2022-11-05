# frozen_string_literal: true
require 'pp'

module Ganttx2
  class SectionList
    attr_reader :sections, :ss, :start_date, :end_date

    def initialize(hash)
      @sections = {}
      @cur_date = nil
      @start_date = nil
      @end_date = nil
      hash.each do |section_name, hash_1|
        section = Section.new.init(section_name, hash_1, @end_date)
        @sections[section_name] = section

        @start_date = section.start_date if @start_date.nil? || @start_date > section.start_date
        @end_date = section.end_date if @end_date.nil? || @end_date < section.end_date
        @prev_itemx = nil
      end
    end

    def update_start_date_and_end_date
      @sections.each do |name, section|
        @start_date = section.start_date if @start_date.nil? || @start_date > section.start_date
        @end_date = section.end_date if @end_date.nil? || @end_date < section.end_date
      end
    end

    def get_section(section_name)
      @sections[section_name]
    end

    def append_section(name, array, time_span)
      section = Section.new.make_section(name, array, @end_date, time_span)
      @sections[name] = section
      @end_date = section.end_date if @end_date.nil? || @end_date < section.end_date
    end

    def reorder
      @ss = {}
      @sections.each do |section_name, section|
        section.dates.each do |time, item|
          @ss[time] ||= {}
          @ss[time][section_name] ||= []
          @ss[time][section_name] << item
        end
      end
      self
    end
  end
end
