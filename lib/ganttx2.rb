# frozen_string_literal: true

require_relative "ganttx2/version"
require_relative "ganttx2/daterange"
require_relative "ganttx2/daterangelist"
require_relative "ganttx2/ganttx2"
require_relative "ganttx2/itemx"
require_relative "ganttx2/section"
require_relative "ganttx2/sectionlist"
require_relative "ganttx2/spreadsheet"
require_relative "ganttx2/cli"
require_relative "ganttx2/utils"
require_relative "ganttx2/dateorderedsectionlist"

# require_relative "ganttx2/"

module Ganttx2
  class Error < StandardError; end
  class InvalidStartDateClassError < Error; end
  # Your code goes here...
end
