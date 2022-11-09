# frozen_string_literal: true

RSpec.describe Ganttx2 do
  it "has a version number" do
    expect(Ganttx2::VERSION).not_to be_nil
  end

  it "make instance of Cli" do
    # bundle exec ruby exe/ganttx2 test_data/ganttx2.yml test_data/ganttx2.erb
    args = %W[test_data/ganttx2.yml test_data/ganttx2.erb test_data/config.yml]
    expect(Ganttx2::Cli.new(args)).not_to be_nil
  end

  it "make instance of DateRange" do
    start_date = Date.today
    limit = 1
    inst = Ganttx2::DateRange.new(start_date, limit)
    expect(inst).not_to be_nil
  end

  it "make instance of DateRangeList" do
    start_date = Date.today
    limit = 1
    count = 2
    inst = Ganttx2::DateRangeList.new(start_date, limit, count)
    expect(inst).not_to be_nil
  end

  it "make instance of Granttx2" do
    date_range_list = Ganttx2::DateRangeList.new(Date.today, 1, 2)
    erb_path = "test_data/ganttx.erb"
    inst = Ganttx2::Ganttx2.new(date_range_list, erb_path)
    expect(inst).not_to be_nil
  end

  it "make instance of Itemx" do
    time_span = 2
    time_span_unit = :d
    inst = Ganttx2::Itemx.new("ソフト", Date.today, time_span, time_span_unit)
    expect(inst).not_to be_nil
  end

  it "make instance of Section" do
    inst = Ganttx2::Section.new()
    expect(inst).not_to be_nil
  end

  it "make instance of SectionList" do
    date = Date.parse('2022-11-05')
    hash = { "Ruby on Rails" => { date => { "Agile Web Development with Rails 7" => "1D" } } }
    inst = Ganttx2::SectionList.new(hash)
    expect(inst).not_to be_nil
  end

  it "make instance of Spreadsheet" do
    url = "https://script.google.com/macros/s/AKfycbyTqRWEYxZ3vWBtnsk6qLdgrGNbQh9tvJgu5vbn7hqeM2dPHDVQe7_Z5IpqD0vNL8vJvg/exec"
    file_path = "d.json"
    inst = Ganttx2::Spreadsheet.new(url, file_path)
    expect(inst).not_to be_nil
  end
end
