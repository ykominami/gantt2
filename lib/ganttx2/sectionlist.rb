# frozen_string_literal: true

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
        @sections[section] = section

        @start_date = section.start_date if @start_date.nil? || @start_date > section.start_date
        @end_date = section.end_date if @end_date.nil? || @end_date < section.end_date
        @prev_itemx = nil
      end
    end

    def update_start_date_and_end_date
      @sections.each do |section_key, section|
        @start_date = section.start_date if @start_date.nil? || @start_date > section.start_date
        @end_date = section.end_date if @end_date.nil? || @end_date < section.end_date
      end
    end

=begin
    def get_section(section)
      @sections[section] = section
    end
=end
    def append_section(name, array, time_span)
      section = Section.new.make_section(name, array, @end_date, time_span)
      @sections[section] = section
      # @sections[name] = section
      @end_date = section.end_date if @end_date.nil? || @end_date < section.end_date
    end

    def reorder
      @ss = {}
      @sections.each do |section_k, section|
        section.dates.each do |time, item_array|
          raise unless item_array.instance_of?(Array)
          raise if item_array.instance_of?(Hash)

          item_array.each do |item|
            raise if item.instance_of?(Array)
          end

          @ss[time] ||= {}
          @ss[time][section.name] ||= []
          @ss[time][section.name] += item_array
          @ss[time][section.name].each do |item|
            raise if item.instance_of?(Array)
          end
          raise if @ss[time][section.name].instance_of?(Hash)
          raise unless @ss[time][section.name].instance_of?(Array)
        end
      end
      self
    end
  end
end
