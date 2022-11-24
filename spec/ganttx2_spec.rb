# frozen_string_literal: true

RSpec.describe Ganttx2 do
  let(:ts) { TestSupport.new }

  it "has a version number", xcmd: 1 do
    expect(Ganttx2::VERSION).not_to be_nil
  end

  it "make instance of Cli", xcmd: 2 do
    # bundle exec ruby exe/ganttx2 test_data/ganttx2.yml test_data/ganttx2.erb
    args = %w[test_data/ganttx2.yml test_data/ganttx2.erb test_data/config.yml]
    expect(Ganttx2::Cli.new(args)).not_to be_nil
  end

  it "make instance of DateOrderedSectionList", xcmd: 30 do
    start_date = Date.today
    limit = 1
    count = 3
    date_range_list = Ganttx2::DateRangeList.new(start_date, limit, count)
    inst = Ganttx2::DateOrderedSectionList.new(date_range_list)

    expect(inst).not_to be_nil
  end

  it "make instance of DateRange", xcmd: 3 do
    start_date = Date.today
    limit = 1
    inst = Ganttx2::DateRange.new(start_date, limit)
    expect(inst).not_to be_nil
  end

  it "make instance of DateRangeList", xcmd: 4 do
    start_date = Date.today
    limit = 1
    count = 2
    inst = Ganttx2::DateRangeList.new(start_date, limit, count)
    expect(inst).not_to be_nil
  end

  it "make instance of Granttx2", xcmd: 5 do
    doslist = ts.create_instance(Ganttx2::DateOrderedSectionList)

    erb_path = "test_data/ganttx2.erb"
    inst = Ganttx2::Ganttdata.new(doslist, erb_path)
    expect(inst).not_to be_nil
  end

  it "make instance of Itemx", xcmd: 6 do
    time_span = 2
    time_span_unit = :d
    inst = Ganttx2::Itemx.new("ソフト", Date.today, time_span, time_span_unit)
    expect(inst).not_to be_nil
  end

  it "make instance of Section", xcmd: 7 do
    inst = Ganttx2::Section.new
    expect(inst).not_to be_nil
  end

  it "make instance of SectionList", xcmd: 8 do
    doslist = ts.create_instance(Ganttx2::DateOrderedSectionList)

    date = Date.parse("2022-11-05")
    hash = { "Ruby on Rails" => { date => { "Agile Web Development with Rails 7" => "1D" } } }
    inst = Ganttx2::SectionList.new(hash, doslist)
    expect(inst).not_to be_nil
  end

  it "make instance of Spreadsheet", xcmd: 9 do
    url = "https://script.google.com/macros/s/AKfycbyTqRWEYxZ3vWBtnsk6qLdgrGNbQh9tvJgu5vbn7hqeM2dPHDVQe7_Z5IpqD0vNL8vJvg/exec"
    file_path = "d.json"
    inst = Ganttx2::Spreadsheet.new(url, file_path)
    expect(inst).not_to be_nil
  end

  it "two items which are specifed D unit", ycmd: 1 do
    doslist = ts.create_instance(Ganttx2::DateOrderedSectionList)

    date_obj = Date.parse("2022-10-31")
    content_hash = { "GAS" => { date_obj => { "GAS自動処理" => "3D", "X処理2" => "2D", "Ruby on Railsガイド 7" => "1d" } } }
    sectionlist = Ganttx2::SectionList.new(content_hash, doslist)
    section = sectionlist.sections.first.first
    expect(section).not_to be_nil
  end

  it "merge two hashs", ycmd: 2 do
    hash1 = { "A" => [1, 2], "B" => [3] }
    hash2 = { "B" => [3, 4], "C" => [4, 5] }
    hash3 = Ganttx2::Utils.hash_merge(hash1, hash2)
    expect(hash3.size).equal?(3)
  end
end
