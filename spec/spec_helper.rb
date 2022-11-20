# frozen_string_literal: true

require "ganttx2"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

class TestSupport
  def create_instance(klass)
    case klass
    when Ganttx2::DateOrderedSectionList
      create_instance_of_dateorderedsectionlist
    end
  end

  def create_instance_of_dateorderedsectionlist
    start_date = Date.today
    limit = 1
    count = 3
    date_range_list = Ganttx2::DateRangeList.new(start_date, limit, count)
    Ganttx2::DateOrderedSectionList.new(date_range_list)
  end
end
